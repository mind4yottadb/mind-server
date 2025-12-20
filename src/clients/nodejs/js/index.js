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

const net = require('net')
const mindConst = require('./constants')
const nsProcess = require('./namespace-process')

class mind {
    connected = false
    loggedIn = false

    commandTimeout = 5000
    sessionTimeout = 36000

    #socket = null

    server = {}

    process = nsProcess

    fs = {}

    connect = (host, port, username, password) => {
        const that = this

        return new Promise(function (resolve, reject) {
            that.#socket = net.createConnection(port, host, async () => {
                that.connected = true

                // mount handlers
                that.#socket.on('close', hadError => {
                })
                that.#socket.on('end', hadError => {
                })

                await that.#login(resolve, username, password)
            })

            that.#socket.on('error', err => {
                reject(err)
            })
        })
    }

    disconnect = () => {
    }

    #login = async (resolve, username, password) => {
        const that = this

            const opCode = 'mind.login'

            that.#writePacket("*1" + mindConst.CRLF + mindConst.blobString + opCode.length.toString() + mindConst.CRLF + 'mind.login' + mindConst.CRLF);

        console.log('packet written')
            that.#readPacket(data => {
                // process response

                console.log('processing response:' + data)

                resolve(data)
            })
    }

    #writePacket = (msg) => {
        const that = this

        let total_sent = 0;
        while (total_sent < msg.length) {
            const msg_sliced = msg.slice(total_sent, msg.length);
            const sentOk = that.#socket.write(msg_sliced);

            if (!sentOk) throw new Error('RuntimeError: socket connection broken');

            total_sent = total_sent + msg_sliced.length;
        }
    }

    #readPacket = (callback) => {
        let buff = ''
        const that = this

        this.#socket.on('data', function (data) {
            buff += data.toString()

            // wait for packet terminator
            if (buff.slice(-3) === 'xxx') {
                that.#socket.removeAllListeners('data')
                callback(buff)
            }
        })
    }
}

module.exports = mind