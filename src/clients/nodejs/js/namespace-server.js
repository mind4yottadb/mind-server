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

const server = {}

Object.defineProperties(server, {
    /*
    hostName: {
        enumerable: true,
        configurable: true
    },

     */
    mindVersion: {
        enumerable: true,
        configurable: true
    },
    ydbVersion: {
        enumerable: true,
        configurable: true
    },
    platform: {
        enumerable: true,
        configurable: true
    },
    architecture: {
        enumerable: true,
        configurable: true
    },
})

module.exports = server

