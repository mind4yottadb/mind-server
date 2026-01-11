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

### fs.removeFile(filename)

---

**Type**: method

**Async**: yes, returns a Promise

**Parameters**:

| name       | data type | Optional | Description                                   |
|------------|-----------|----------|-----------------------------------------------|
| `filename` | string    | No       | the absolute or relative path of the filename |

**Returns**:

`Promise <>`

---

Deletes the file pointed by `filename`.

If `filename` is not found or another error occurs, it will throw an error.

---

### EXAMPLES

````js
import mind from 'mind4yottadb'

const ydb = new mind

await ydb.connect('127.0.0.1', 10000, 'admin', 'admin')

ydb.fs.removeFile('/tmp/testfile.txt')

ydb.disconnect()

````

<br>

Using error handling:

````js
import mind from 'mind4yottadb'

const ydb = new mind

await ydb.connect('127.0.0.1', 10000, 'admin', 'admin')

try {
    await ydb.fs.removeFile('/tmp/IdontExist')

} catch (err) {
    console.log(err)
}

// or

await ydb.fs.removeFile('/tmp/IdontExist').catch((err) => console.log(err))

console.log(err)

ydb.disconnect()

````

---

[Back](../namespace.fs.md)

