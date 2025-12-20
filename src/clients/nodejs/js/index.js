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

class mind {
    connected = false
    loggedIn = false

    commandTimeout = 5000
    sessionTimeout = 36000

    #socket = null

    server = {}

    process = {}

    fs = {}

    connect = (host, port, username, password) => {
        const that = this

        return new Promise(function (resolve, reject) {
            that.#socket = net.createConnection(port, host, async () => {
                that.connected = true

            })
        })
    }
}