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
const EventEmitter = require('node:events');
const eventEmitter = new EventEmitter();

const mindConst = require('./constants')

const nsProcess = require('./namespace-process')
const nsServer = require('./namespace-server')
const nsFs = require('./namespace-fs')

const {getBlob} = require("./constants");
const login = require('./login')

module.exports = class mind extends EventEmitter {
    // ********************************
    // public methods and properties
    // ********************************
    connected = false
    loggedIn = false

    #socket = null

    requiresMind = '0.1.0'
    server = new nsServer
    process = new nsProcess
    fs = new nsFs

    connect = (host, port, username, password) => {
        const that = this

        return new Promise(function (resolve, reject) {
            that.#socket = net.createConnection(port, host, async () => {
                that.connected = true

                // mount event handler and route it to the event emitter
                that.#socket.on('end', () => {
                    that.disconnect()

                    that.emit('disconnected', new Error('Disconnected'))
                })

                // mount event handler and route it to the event emitter
                that.#socket.on('error', err => {
                    that.emit('error', err)
                    reject(err)
                })

                // perform the login
                try {
                    await login(that, that.#writePacket, that.#readPacket, resolve, reject, username, password)

                    that.loggedIn = true


                } catch (err) {
                    that.connected = false
                    that.loggedIn = false
                }
            })
        })
    }

    disconnect = () => {
        this.#socket.destroy()
        this.connected = false
        this.loggedIn = false
    }

    // ********************************
    // private methods and properties
    // ********************************
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
        const commandTerminator = '\x03\r\n\x03\r\n'
        let buff = ''
        const that = this

        this.#socket.on('data', function (data) {
            buff += data.toString()

            // wait for packet terminator
            if (buff.slice(-6) === commandTerminator) {
                that.#socket.removeAllListeners('data')
                callback(buff.slice(0, -6))
            }
        })
    }
}

