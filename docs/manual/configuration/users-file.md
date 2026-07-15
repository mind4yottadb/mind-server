<!--
###############################################################
#                                                               #
# Copyright (c) 2026 DnaSoft BV and/or its subsidiaries.        #
# All rights reserved.                                          #
#                                                               #
#   This source code contains the intellectual property         #
#   of its copyright holder(s), and is made available           #
#   under a license.  If you do not know the terms of           #
#   the license, please stop and do not read further.           #
#                                                               #
###############################################################*/
-->

# Users file

The user file is a JSON file describing the users allowed in the server by a remote `login` from a client, once
connection is successful.

At the moment it is very simple, as it contains only `username` and `password`, but in a later stage it will enforce
`roles` to restrict user's rights.

Additionally, the file is not encrypted, but there are plans to encrypt it in the future.

````json
[
    {
        "username": "admin",
        "password": "admin"
    },
    {
        "username": "user",
        "password": "user"
    }
]

````

