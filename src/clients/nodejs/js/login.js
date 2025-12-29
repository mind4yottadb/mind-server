/*#################################################################
#                                                               #
# Copyright (c) 2025 DnaSoft BV and/or its subsidiaries.        #
# All rights reserved.                                          #
#                                                               #
#   This source code contains the intellectual property         #
#   of its copyright holder(s), and is made available           #
#   under a license.  If you do not know the terms of           #
#   the license, please stop and do not read further.           #
#                                                               #
#################################################################*/

const mindConst = require("./constants");

const driverName = 'mind4yottadb'
const driverVersion = '0.0.1'
const driverDescription = 'MIND for YottaDB node.js driver'

module.exports = async function (that, writer, reader, resolve, reject, username, password) {
    const opCode = 'server.login'
    const credentials = username + ':' + password

    // send command
    writer("*5" + mindConst.CRLF +
        mindConst.getBlob(opCode) + mindConst.getBlob(credentials) +
        mindConst.getBlob(driverName) + mindConst.getBlob(driverVersion) + mindConst.getBlob(driverDescription)
    );

    // process response
    reader(data => {
        const dataA = data.split(mindConst.CRLF)
        let ix = 0
        let iy = 0

        // check header
        if (dataA[ix].charAt(0) === '-') {
            reject(dataA[0].slice(1))
        }

        if (dataA[ix] !== '*4') {
            reject('invalid packet signature at line: ' + ix + ' Expected: *4')
        }

        // proceed with the server array
        ix += 2
        const serverLength = parseInt(dataA[ix].slice(1))

        iy = ix
        for (ix = ix + 1; ix < iy + serverLength * 2; ix += 2) {
            Object.defineProperties(that.server, {
                [mindConst.extractSimpleString(dataA[ix])]: {
                    value: mindConst.extractSimpleString(dataA[ix + 1]),
                    enumerable: true,
                    configurable: true
                }
            })
        }

        const mindVersion = that.server.mindVersion
        if (mindVersion < that.requiresMind) {
            reject('invalid mind server version, expected ' + that.requiresMind + ' or higher, but found ' + mindVersion)
        }

        // proceed with the process array
        if (dataA[ix] !== '%4') reject('invalid packet signature at line: ' + ix + 'Expected: %4')

        const processLength = parseInt(dataA[ix].slice(1))

        // add props with setters / getters to process
        Object.defineProperties(that.process, {
            cwd: {
                get: function () {
                    console.log(this)
                    const that = this
                    return new Promise(function (resolve, reject) {
                        if (that.connected === false || that.loggedIn === false) reject(new Error('Not logged in'))

                        // send command
                        const opCode = 'process.cwdGet'
                        writer("*1" + mindConst.CRLF +
                            mindConst.getBlob(opCode)
                        );

                        reader(data => {
                            if (data.charAt(0) === '-') {
                                reject(data)
                            }
                            resolve(data.slice(data.indexOf(mindConst.CRLF) + 2, data.length - 2))
                        })
                    })


                },
                set: function (val) {
                    process.cwd = val
                },
                enumerable: true
            },
        })

        // continue
        iy = ix
        for (ix = ix + 1; ix < iy + processLength * 2; ix += 2) {
            const name = mindConst.extractSimpleString(dataA[ix])

            if (name === "cwd") {
                that.process.cwd = mindConst.extractSimpleString(dataA[ix + 1])

            } else {
                const strValue = mindConst.extractSimpleString(dataA[ix + 1])
                Object.defineProperties(that.process, {
                    [mindConst.extractSimpleString(dataA[ix])]: {
                        value: isNaN(parseInt(strValue)) ? strValue : parseInt(strValue),
                        enumerable: true,
                        configurable: true
                    }
                })
            }
        }

        // and terminate with the env vars
        const envObj = {}
        const envLength = parseInt(dataA[ix].slice(1))

        Object.defineProperties(that.process, {
            env: {
                value: {},
                enumerable: true,
                configurable: true
            }
        })

        iy = ix
        for (ix = ix + 1; ix < iy + envLength * 2 - 1; ix += 2) {
            const strValue = mindConst.extractSimpleString(dataA[ix + 1])

            Object.defineProperties(that.process.env, {
                [mindConst.extractSimpleString(dataA[ix])]: {
                    value: isNaN(parseInt(strValue)) ? strValue : parseInt(strValue),
                    enumerable: true,
                    configurable: true
                }
            })
        }

        Object.defineProperties(that.fs, {
            rootThat: {
                value: that,
                enumerable: false,
                configurable: false
            },
            writer: {
                value: writer,
                enumerable: false,
                configurable: false
            },
            reader: {
                value: reader,
                enumerable: false,
                configurable: false
            }
        })


        // resolve the promise
        resolve()
    })
}