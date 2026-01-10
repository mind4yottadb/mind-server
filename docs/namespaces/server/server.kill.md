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

### server.kill(signal)

---

**Type**: method

**Async**: yes, returns a Promise

**Parameters**:

| name        | data type | Optional | Description                                                          |
|-------------|-----------|----------|----------------------------------------------------------------------|
| `pid`       | number    | No       | the process id of the program you wish to terminate                  |
| `sigNumber` | number    | Yes      | the (optional) signal number. If omitter, it will default to SIG_INT |

**Returns**:

`Promise`

---

Sends the `sigNumber` to the process pointed by `pid`

> You can use the constants included in the process object as `sigNumber`

Any error returned by the call will be thrown as Error.


<br>

---

### EXAMPLES

````js
import mind from 'mind4yottadb'

const ydb = new mind

await ydb.connect('127.0.0.1', 10000, 'admin', 'admin')

await ydb.server.kill(12023, ydb.process.SIG_KIL)

ydb.disconnect()

````

<br>


---

[Back](../namespace.process.md)