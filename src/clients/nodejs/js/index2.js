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
const mind = require('./constants.js')

const port = 10000;
const host = '127.0.0.1';


const socket = net.createConnection(port, host, async () => {
    console.log('Socket connected....');

    socket.setEncoding('utf8');


    //const msg = await afterRead(socket);
    //console.log('calling login')
    //const ret = await login()
    //console.log('login result:')
    //console.log(ret)

    const stef = new mind2()
    const stef2 = new mind2()
    const ret2 = await stef.fs.readFile2('test file')
    console.log("Ret is: " + ret2)
    console.log(stef.sys.pid)
    console.log(stef.process.env.ydb_rev)

    Object.defineProperty(stef.process.env, 'ydb_current', {
        get() {
            return '/r.12/'
        }
    })

    console.log(stef.process.env.ydb_current)

    console.log(stef.sys.pid)
    console.log(stef2.sys.pid)
    stef2.sys.pid = 44
    console.log(stef.sys.pid)
    console.log(stef2.sys.pid)


});

socket.on('error', err => {
    console.log('Socket err:' + err);
})

socket.on('connect', () => {
    console.log('Socket connected');
})

socket.on('connectionAttempt', (err) => {
    console.log('connectionAttempt', err);
})
socket.on('connectionAttemptFailed', (err) => {
    console.log('connectionAttemptFailed', err);
})


async function login(file) {

    return new Promise(function (resolve, reject) {
        const op = 'mind.login'

        my_send(socket, "*1" + mind.CRLF + mind.blobString + op.length.toString() + mind.CRLF + 'mind.login' + mind.CRLF);

        readSocket(resolve, file)
    })
}

function readSocket(resolve, type) {
    let buff = ''

    socket.on('data', function (data) {
        buff += data.toString()
        //console.log('Received: -' + data + '-')
        //console.log('buff: ', buff)
        //console.log('Slice: ' + buff.slice(-3))
        if (buff.slice(-3) === 'xxx') {
            socket.removeAllListeners('data')
            parser(resolve, buff, type)
        }
    })
}

function parser(resolve, buff, type) {
    console.log(type)
    resolve(buff)

}

function my_send(socket_, msg) {
    let total_sent = 0;
    while (total_sent < msg.length) {
        const msg_sliced = msg.slice(total_sent, msg.length);
        const sentOk = socket_.write(msg_sliced);
        if (!sentOk) throw new Error('RuntimeError: socket connection broken');
        total_sent = total_sent + msg_sliced.length;
    }
}

class mind2 {
    fs = {
        readFile2: file => login(file)
    }

    sys = {
        testMe: 'testggg',

        get pid() {
            return this.testMe
        },

        set pid(x) {
            this.testMe = x
        }
    }

    process = {
        env: {
            get ydb_rev() {
                return '/test/'
            }
        }
    }

}