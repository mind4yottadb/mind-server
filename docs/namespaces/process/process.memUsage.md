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

### process.memUsage

---

**Type**: function

**Async**:  yes, returns a Promise

**Parameters**:

| name | data type | Optional | Description |
|------|-----------|----------|-------------|

**Returns**:

`Promise<object>`

---

Returns the `allocatedStorage`, the `usedStorage` and the `realStorage` used by your session.

> `allocatedStorage`: contains the number of bytes that are (sub) allocated (including overhead) by YottaDB for various
> activities.

> `realStorage`: contains the total memory (in bytes) allocated by the YottaDB process, which may or may not actually be
> in use.

> `usedStorage`: is the value in `allocatedStorage` minus storage management overhead and represents the actual memory,
> in bytes, requested by current activities.

An eventual internal error on the server side will throw an error.

<br>

---

### EXAMPLES

````js
import mind from 'mind4yottadb'

const ydb = new mind

await ydb.connect('127.0.0.1', 10000, 'admin', 'admin')

const memUsage = ydb.process.memUsage()
console.log(memUsage)

ydb.disconnect()

````

returns:

````js

memUsage = {
    allocatedStorage: 1647396,
    realStorage: 1701396,
    usedStorage: 1647396
}

````

<br>


---

[Back](../namespace.process.md)