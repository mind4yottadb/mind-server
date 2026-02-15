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

### fs.readDir(path, mask)

---

**Type**: function

**Async**: yes, returns a Promise

**Parameters**:

| name   | data type | Optional | Description            |
|--------|-----------|----------|------------------------|
| `path` | string    | No       | the path to search for |
| `mask` | string    | Yes      | the mask to be used    |

**Returns**:

`Promise<array>`

---

Reads the dir content specified in `path` using the optional `mask` parameter.

If `mask` is missing, it will default to `*.*`.

If `path` is not found or another error occurs, it will throw an error.

<br>

---

### EXAMPLES

Using no mask...

````js
import mind from 'mind4yottadb'

const ydb = new mind

await ydb.connect('127.0.0.1', 10000, 'admin', 'admin')

const res = await ydb.fs.readDir('/etc')

console.log(res)

ydb.disconnect()

````

...it will return all files and directories:

````js
[
    'adduser.conf',
    'alternatives',
    'apt',
    'bash.bashrc',
    'bash_completion.d',
    'bindresvport.blacklist',
    'etc...'
]

````

<br>

Using a mask...

````js
import mind from 'mind4yottadb'

const ydb = new mind

await ydb.connect('127.0.0.1', 10000, 'admin', 'admin')

const res = await ydb.fs.readDir('/etc', '*.conf')

console.log(res)

ydb.disconnect()

````

...it will return only files matching the mask:

````js
[
    'adduser.conf',
    'debconf.conf',
    'deluser.conf',
    'e2scrub.conf',
    'ld.so.conf',
    'libaudit.conf',
    'etc...'
]

````

<br>

Using error handling:

````js
import mind from 'mind4yottadb'

const ydb = new mind

await ydb.connect('127.0.0.1', 10000, 'admin', 'admin')

try {
    const res = await ydb.fs.readDir('/etc', '*.conf')

} catch (err) {
    console.log(err)
}

// or

const res = await ydb.fs.readDir('/etc', '*.conf').catch((err) => console.log(err))


ydb.disconnect()

````

---

[Back](../namespace.fs.md)