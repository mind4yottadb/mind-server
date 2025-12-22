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
const {getBlob} = require("./constants");

const driverName = 'mind4yottadb'
const driverVersion = '0.0.1'
const driverDescription = 'MIND for YottaDB node.js driver'

module.exports = class mind extends EventEmitter {
    // ********************************
    // public methods and properties
    // ********************************

    connected = false
    loggedIn = false

    commandTimeout = 5000
    sessionTimeout = 36000

    #socket = null

    server = nsServer
    process = new nsProcess

    fs = {}

    connect = (host, port, username, password) => {
        const that = this

        return new Promise(function (resolve, reject) {
            that.#socket = net.createConnection(port, host, async () => {
                that.connected = true

                // mount event handler and route it to the event emitter
                that.#socket.on('end', () => {
                    that.emit('end', new Error('Connection closed'))
                })

                // perform the login
                await that.#login(resolve, username, password)
            })

            // mount event handler and route it to the event emitter
            that.#socket.on('error', err => {
                that.emit('error', err)
                reject(err)
            })
        })
    }

    disconnect = () => {
        this.#socket.destroy()
    }

    // ********************************
    // private methods and properties
    // ********************************

    #login = async (resolve, username, password) => {
        const that = this

        const opCode = 'server.login'
        const credentials = username + ':' + password

        that.#writePacket("*5" + mindConst.CRLF +
            mindConst.getBlob(opCode) + mindConst.getBlob(credentials) +
            mindConst.getBlob(driverName) + mindConst.getBlob(driverVersion) + mindConst.getBlob(driverDescription)
        );

        console.log(mindConst.getBlob(opCode) + mindConst.getBlob(credentials))
        that.#readPacket(data => {
            // process response


            console.log(data)


            // resolve the promise
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

