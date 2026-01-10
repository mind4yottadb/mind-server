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

### fs.rmdir(path)

---

**Type**: method

**Async**: yes, returns a Promise

**Parameters**:

| name   | data type | Optional | Description                             |
|--------|-----------|----------|-----------------------------------------|
| `path` | string    | No       | the path of the directory to be deleted |

**Returns**:

`Promise<>`

---

Creates the directory specified in `path`.

If `path` is not found, it is not empty, it is not a directory or another error occurs, it will throw an error.

<br>

---

### EXAMPLES

````js
import mind from 'mind4yottadb'

const ydb = new mind

await ydb.connect('127.0.0.1', 10000, 'admin', 'admin')

await ydb.fs.rmdir('/tmp/newDirectory')

ydb.disconnect()

````

<br>

Using error handling:

````js
import mind from 'mind4yottadb'

const ydb = new mind

await ydb.connect('127.0.0.1', 10000, 'admin', 'admin')

try {
    await ydb.fs.rmdir('/tmp/newDirectory')

} catch (err) {
    console.log(err)
}

// or

await ydb.fs.rmdir('/tmp/newDirectory').catch((err) => console.log(err))

ydb.disconnect()

````

---

[Back](../namespace.fs.md)