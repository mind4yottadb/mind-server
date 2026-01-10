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

---

### process.exec(command, shell)

---

**Type**: function

**Async**: yes, returns a Promise

**Parameters**:

| name      | data type | Optional | Description                                                     |
|-----------|-----------|----------|-----------------------------------------------------------------|
| `command` | string    | No       | the command to be executed, including its (optional) parameters |
| `shell`   | string    | Yes      | the (optional) shell to be used instead of /bin/sh              |

**Returns**:

`Promise<string>`

---

Runs the passed command and return its STDOUT as a string.

The function will return when the program has terminated.


<br>

---

### EXAMPLES

````js
import mind from 'mind4yottadb'

const ydb = new mind

await ydb.connect('127.0.0.1', 10000, 'admin', 'admin')

const stdout = await ydb.process.dir('ls -la')
console.log(stdout)

ydb.disconnect()

````

returns:

````js

stdout = 'total 40' +
    'drwxr-xr-x 1 root root 4096 Dec 11 12:00 .' +
    'drwxr-xr-x 1 root root 4096 Dec 11 12:41 ..' +
    '-rwxr-xr-x 1 root root   62 Dec 11 11:58 aliases' +
    '-rwxr-xr-x 1 root root  767 Dec  4 16:07 compile' +
    '-rwxr-xr-x 1 root root 1016 Dec 11 12:00 dev.sh' +
    'drwxrwxrwx 1 root root 4096 Dec 30 16:51 m' +
    '-rwxr-xr-x 1 root root  783 Dec  4 19:36 mind' +
    'drwxr-xr-x 1 root root 4096 Jan  7 17:23 o' +
    'drwxr-xr-x 3 root root 4096 Dec 11 12:41 test'

````

<br>


---

[Back](../namespace.process.md)