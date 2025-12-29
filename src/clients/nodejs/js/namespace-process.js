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

class process {
    exec = function (args) {

    }

    spawn = function (args) {

    }

    cwdGet = function () {
        const that = this

        return new Promise(function (resolve, reject) {
            if (that.connected === false || that.loggedIn === false) reject(new Error('Not logged in'))

            // send command
            const opCode = 'process.cwdGet'
            that.writer("*1" + mindConst.CRLF +
                mindConst.getBlob(opCode)
            );

            that.reader(data => {
                if (data.charAt(0) === '-') {
                    reject(data.slice(1))
                }

                resolve(data.slice(1))
            })
        })
    }

    cwdSet = function (path = '') {
        const that = this

        return new Promise(function (resolve, reject) {
            if (that.connected === false || that.loggedIn === false) reject(new Error('Not logged in'))

            // send command
            const opCode = 'process.cwdSet'
            that.writer("*2" + mindConst.CRLF +
                mindConst.getBlob(opCode) +
                mindConst.getBlob(path)
            );

            that.reader(data => {
                if (data.charAt(0) === '-') {
                    reject(data.slice(1))
                }

                //that.cwd = path
                resolve()
            })
        })
    }
}


module.exports = process


