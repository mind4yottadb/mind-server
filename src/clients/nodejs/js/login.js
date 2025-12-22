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

    writer("*5" + mindConst.CRLF +
        mindConst.getBlob(opCode) + mindConst.getBlob(credentials) +
        mindConst.getBlob(driverName) + mindConst.getBlob(driverVersion) + mindConst.getBlob(driverDescription)
    );

    console.log(mindConst.getBlob(opCode) + mindConst.getBlob(credentials))
    reader(data => {
        // process response


        Object.defineProperties(that.server, {
            hostName: {
                value: 'new value'
            }
        })


        console.log(data)

        // resolve the promise
        resolve('Login error')
    })
}