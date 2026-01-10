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

### process.unixtime()

---

**Type**: function

**Async**: yes, returns a Promise

**Parameters**:

| name | data type | Optional | Description |
|------|-----------|----------|-------------|

**Returns**:

`Promise<int>`

---

`unixtime` (UNIX time or universal time) returns the number of microseconds since January 1, 1970 00:00:00 UTC, which
provides a time stamp for directly comparing different timezones. `unixtime` accuracy is subject to the precision of the
system clock


<br>

---

### EXAMPLES

````js
import mind from 'mind4yottadb'

const ydb = new mind

await ydb.connect('127.0.0.1', 10000, 'admin', 'admin')

const unixTime = ydb.process.unixtime()
console.log(unixTime)

ydb.disconnect()

````

returns:

````js

unixTime = 1767806071551168

````

<br>


---

[Back](../namespace.process.md)