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
        if (dataA[ix] === '*2') {
            reject(dataA[1] + ' ' + dataA[2])
            return
        }
        if (dataA[ix] !== '*4') {
            reject('invalid packet signature at line: ' + ix + ' Expected: *4')
            return
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

        // proceed with the process array
        if (dataA[ix] !== '%4') reject('invalid packet signature at line: ' + ix + 'Expected: %4')

        const processLength = parseInt(dataA[ix].slice(1))

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

            console.log(mindConst.extractSimpleString(dataA[ix] + ' ' + strValue))
            Object.defineProperties(that.process.env, {
                [mindConst.extractSimpleString(dataA[ix])]: {
                    value: isNaN(parseInt(strValue)) ? strValue : parseInt(strValue),
                    enumerable: true,
                    configurable: true
                }
            })
        }

        // resolve the promise
        resolve('all ok')
    })
}