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

### process.cwdGet()

---

**Type**: function

**Async**: yes, returns a Promise

**Parameters**:

| name | data type | Optional | Description |
|------|-----------|----------|-------------|

**Returns**:

`Promise<string>`

---

Returns the Current Working Directory of your session.

It can be changed using the [process.cwdSet()](process.cwdSet.md) function.


<br>

---

### EXAMPLES

````js
import mind from 'mind4yottadb'

const ydb = new mind

await ydb.connect('127.0.0.1', 10000, 'admin', 'admin')

const cwd = await ydb.process.cwdGet()
console.log(cwd)

ydb.disconnect()

````

returns:

````js

cwd = '/opt/mind'

````

<br>


---

[Back](../namespace.process.md)