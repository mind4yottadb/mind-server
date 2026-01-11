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

### fs.stat(filename)

---

**Type**: function

**Async**: yes, returns a Promise

**Parameters**:

| name       | data type | Optional | Description                      |
|------------|-----------|----------|----------------------------------|
| `filename` | string    | No       | the filename you want to enquire |

**Returns**:

`Promise<object>`

---

Returns information about the file specified in `filename`.

No permissions are required on the file itself, but permission is required on all of the directories in `filename` that
lead to the file.

The function returns an object with the following properties populated:

| property  | Description                     |
|-----------|---------------------------------|
| `atime`   | time of last access             |
| `blksize` | blocksize for file system I/O   |
| `blocks`  | number of 512B blocks allocated |
| `ctime`   | time of last status change      |
| `dev`     | ID of device containing file    |
| `gid`     | group ID of owner               |
| `ino`     | inode number                    |
| `mode`    | protection                      |
| `mtime`   | time of last modification       |
| `natime`  |                                 |
| `nctime`  |                                 |
| `nlink`   | number of hard links            |
| `nmtime`  |                                 |
| `rdev`    | device ID (if special file)     |
| `size`    | total size, in bytes            |
| `uid`     | user ID of owner                |

If the `filename` is not found or another error occurs, it will throw an error.

<br>

---

### EXAMPLES

````js
import mind from 'mind4yottadb'

const ydb = new mind

await ydb.connect('127.0.0.1', 10000, 'admin', 'admin')

const res = await ydb.fs.stat('/tmp')
console.log(res)

ydb.disconnect()

````

returns:

````js
ret = {
    atime: 1767708095,
    blksize: 4096,
    blocks: 40,
    ctime: 1767792603,
    dev: 120,
    gid: 0,
    ino: 313218,
    mode: 17407,
    mtime: 1767792603,
    natime: 765643816,
    nctime: 934960574,
    nlink: 1,
    nmtime: 934960574,
    rdev: 0,
    size: 20480,
    uid: 0
}
````

<br>

Using error handling:

````js
import mind from 'mind4yottadb'

const ydb = new mind

await ydb.connect('127.0.0.1', 10000, 'admin', 'admin')

try {
    const ret = await ydb.fs.stat('/tmp')
    console.log(ret)

} catch (err) {
    console.log(err)
}

// or

const ret = await ydb.fs.stat('/tmp').catch((err) => console.log(err))
console.log(ret)

ydb.disconnect()

````

---

[Back](../namespace.fs.md)