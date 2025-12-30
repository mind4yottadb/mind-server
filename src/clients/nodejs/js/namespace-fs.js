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

class fs {
    // ************************************
    // readFile
    // ************************************
    readFile = function (filename = '') {
        const that = this

        return new Promise(function (resolve, reject) {
            if (that.rootThat.connected === false || that.rootThat.loggedIn === false) reject(new Error('Not logged in'))

            // send command
            const opCode = 'fs.readFile'
            that.writer("*2" + mindConst.CRLF +
                mindConst.getBlob(opCode) +
                mindConst.getBlob(filename)
            );

            that.reader(data => {
                if (data.charAt(0) === '-') {
                    reject(data.slice(1))
                }
                resolve(data.slice(data.indexOf(mindConst.CRLF) + 2, data.length - 2))
            })
        })
    }

    // ************************************
    // writeFile
    // ************************************
    writeFile = function (filename = '', data = '') {
        const that = this

        return new Promise(function (resolve, reject) {
            if (that.connected === false || that.loggedIn === false) reject(new Error('Not logged in'))

            // send command
            const opCode = 'fs.writeFile'
            that.writer("*3" + mindConst.CRLF +
                mindConst.getBlob(opCode) +
                mindConst.getBlob(filename) +
                mindConst.getBlob(data)
            );

            that.reader(data => {
                if (data.charAt(0) === '-' || data.indexOf('+ok') === -1) {
                    reject(data.slice(1))
                }
                resolve()
            })
        })
    }

    // ************************************
    // appendFile
    // ************************************
    appendFile = function (filename = '', data = '') {
        const that = this

        return new Promise(function (resolve, reject) {
            if (that.connected === false || that.loggedIn === false) reject(new Error('Not logged in'))

            // send command
            const opCode = 'fs.appendFile'
            that.writer("*3" + mindConst.CRLF +
                mindConst.getBlob(opCode) +
                mindConst.getBlob(filename) +
                mindConst.getBlob(data)
            );

            that.reader(data => {
                if (data.charAt(0) === '-' || data.indexOf('+ok') === -1) {
                    reject(data.slice(1))
                }
                resolve()
            })
        })
    }

    // ************************************
    // readdir
    // ************************************
    readdir = function (path = '', mask = '*') {
        const that = this

        return new Promise(function (resolve, reject) {
            if (that.connected === false || that.loggedIn === false) reject(new Error('Not logged in'))

            // send command
            const opCode = 'fs.readdir'
            that.writer("*3" + mindConst.CRLF +
                mindConst.getBlob(opCode) +
                mindConst.getBlob(path) +
                mindConst.getBlob(mask)
            );

            that.reader(data => {
                if (data.charAt(0) === '-') {
                    reject(mindConst.getBlob(data).slice(1))
                }
                resolve(data.slice(1).split(','))
            })
        })
    }

    removeFile = function (filename = '') {
        const that = this

        return new Promise(function (resolve, reject) {
            if (that.rootThat.connected === false || that.rootThat.loggedIn === false) reject(new Error('Not logged in'))

            // send command
            const opCode = 'fs.removeFile'
            that.writer("*2" + mindConst.CRLF +
                mindConst.getBlob(opCode) +
                mindConst.getBlob(filename)
            );

            that.reader(data => {
                console.log(data)
                if (data.charAt(0) === '-' || data.indexOf('+ok') === -1) {
                    reject(data.slice(1))
                }
                resolve()
            })
        })
    }

    renameFile = function (filename = '', newFilename = '') {
        const that = this

        return new Promise(function (resolve, reject) {
            if (that.rootThat.connected === false || that.rootThat.loggedIn === false) reject(new Error('Not logged in'))

            // send command
            const opCode = 'fs.renameFile'
            that.writer("*3" + mindConst.CRLF +
                mindConst.getBlob(opCode) +
                mindConst.getBlob(filename) +
                mindConst.getBlob(newFilename)
            );

            that.reader(data => {
                console.log(data)
                if (data.charAt(0) === '-' || data.indexOf('+ok') === -1) {
                    reject(data.slice(1))
                }
                resolve()
            })
        })
    }

    copyFile = function (args) {
    }
    cp = function (args) {
    }
    mkdir = function (args) {
    }
    mkdtemp = function (args) {
    }
    realpath = function (args) {
    }
    rmdir = function (args) {
    }
    unlink = function (args) {
    }
}

module.exports = fs