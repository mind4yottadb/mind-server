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

### process.spawn(command, logFile)

---

**Type**: function

**Async**: yes, returns a Promise

**Parameters**:

| name      | data type | Optional | Description                                                     |
|-----------|-----------|----------|-----------------------------------------------------------------|
| `command` | string    | No       | the command to be executed, including its (optional) parameters |
| `logFile` | string    | Yes      | the (optional) path to a log file to redirest the STDOUT        |

**Returns**:

`Promise<number>`

---

Runs the passed command and return its `pid`.

> The function will return immediately, while the program will run in the background.

Any error returned by the running of the command will be thrown as Error.


<br>

---

### EXAMPLES

````js
import mind from 'mind4yottadb'

const ydb = new mind

await ydb.connect('127.0.0.1', 10000, 'admin', 'admin')

const pid = await ydb.process.spawn('/otp/redis-cli -p 8080')
console.log(pid)

ydb.disconnect()

````

returns:

````js

pid = 10234

````

<br>


---

[Back](../namespace.process.md)