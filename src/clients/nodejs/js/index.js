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

    const op = 'mind.login'

    my_send(socket, "*1" + mind.CRLF + mind.blobString + op.length.toString() + mind.CRLF + 'mind.login' + mind.CRLF);
    const msg = await my_rec(socket);
    //console.log(msg)
});

const afterRead = data => {
    console.log('After read:' + data)
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

async function my_rec(socket_) {
    let msg = '';
    socket_.setEncoding('utf8');
    //while (msg.length < length) {
    let buff = ''

    socket_.on('data', await async function (data) {
        buff += data.toString()
        console.log('Received: -' + data + '-')
        console.log('buff: ', buff)
        console.log('Slice: ' + buff.slice(-3))
        if (buff.slice(-3) === 'xxx') {
            afterRead(buff)
        }
    })

    socket_.on('end', async function (data) {
        console.log('End received with: ' + data)
    })
    console.log('buffer global:' + buff)
}

