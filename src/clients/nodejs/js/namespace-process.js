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

class process {
    exec = function (args) {

    }

    spawn = function (args) {

    }
}

// add props with setters / getters
Object.defineProperties(process, {
    cwd: {
        get: function () {
            return process.cwd
        },
        set: function (val) {
            process.cwd = val
        },
    },
})

module.exports = process


