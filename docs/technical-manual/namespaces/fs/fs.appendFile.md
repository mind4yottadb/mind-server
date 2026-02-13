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

### fs.appendFile(filename, data)

---

**Type**: method

**Async**: yes, returns a Promise

**Parameters**:

| name       | data type | Optional | Description                                   |
|------------|-----------|----------|-----------------------------------------------|
| `filename` | string    | No       | the absolute or relative path of the filename |
| `data`     | string    | No       | the data to be appended.                      |

**Returns**:

`Promise<>`

---

Appends the string in `data` to the file specified in `filename`.

If `filename` is not found or another error occurs, it will throw an error.

<br>

---

### EXAMPLES

````js
import mind from 'mind4yottadb'

const ydb = new mind

await ydb.connect('127.0.0.1', 10000, 'admin', 'admin')

await ydb.fs.appendFile('/tmp/testfile.txt', 'add another line\n')

ydb.disconnect()

````

<br>

Using error handling:

````js
import mind from 'mind4yottadb'

const ydb = new mind

await ydb.connect('127.0.0.1', 10000, 'admin', 'admin')

try {
    await ydb.fs.readFile('/tmp/IdontExist', 'add another line\n')

} catch (err) {
    console.log(err)
}

// or

await ydb.fs.readFile('/tmp/IdontExist', 'add another line\n').catch((err) => console.log(err))

ydb.disconnect()

````

---

[Back](../namespace.fs.md)