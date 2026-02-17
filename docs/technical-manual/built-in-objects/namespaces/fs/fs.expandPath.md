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

### fs.expandPath(path)

---

**Type**: function

**Async**: yes, returns a Promise

**Parameters**:

| name   | data type | Optional | Description                 |
|--------|-----------|----------|-----------------------------|
| `path` | string    | No       | the path you wish to expand |

**Returns**:

`Promise<string>`

---

Returns the extended path of the passed `path` by expanding the included environment variables.

If the `path` is not found or another error occurs, it will throw an error.

<br>

---

### EXAMPLES

````js
import mind from 'mind4yottadb'

const ydb = new mind

await ydb.connect('127.0.0.1', 10000, 'admin', 'admin')

const ret = await ydb.fs.expandPath('$ydb_dist/plugin')
console.log(ret)

ydb.disconnect()
````

returns:

````js
ret = '/opt/yottadb/current/plugin'
````

<br>

Using error handling:

````js
import mind from 'mind4yottadb'

const ydb = new mind

await ydb.connect('127.0.0.1', 10000, 'admin', 'admin')

try {
    const ret = await ydb.fs.expandPath('$ydb_dist/plugin')
    console.log(ret)

} catch (err) {
    console.log(err)
}

// or

const ret = await ydb.fs.expandPath('$ydb_dist/plugin').catch((err) => console.log(err))
console.log(ret)

ydb.disconnect()

````

---

[Back](../namespace.fs.md)