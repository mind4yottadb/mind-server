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

### process.dateTime()

---

**Type**: function

**Async**:  yes, returns a Promise

**Parameters**:

| name | data type | Optional | Description |
|------|-----------|----------|-------------|

**Returns**:

`Promise<object>`

---

Returns the current date and time broken down to separate parameters.

The function returns an object with the following properties populated:

| property         | Description                                |
|------------------|--------------------------------------------|
| `dayOfMonth`     | the day of the month                       |
| `dayOfWeek`      | the day of the week. Week starts on Sunday |
| `dayOfYear`      | the number of days since January, 1st      |
| `daylightSaving` | 1 if daylight saving, 0 if not             |
| `hour`           | the current hour (in 24 h format)          |
| `minute`         | the current minute                         |
| `month`          | the current month                          |
| `sec`            | the current seconds                        |
| `timezone`       | the current timezone related to UTC        |
| `year`           | the current year                           |

An eventual internal error on the server side will throw an error.

<br>

---

### EXAMPLES

````js
import mind from 'mind4yottadb'

const ydb = new mind

await ydb.connect('127.0.0.1', 10000, 'admin', 'admin')

const datetime = ydb.process.datetime()
console.log(datetime)

ydb.disconnect()

````

returns:

````js

memUsage = {
    dayOfMonth: 7,
    dayOfWeek: 4,
    dayOfYear: 7,
    daylightSaving: 0,
    hour: 17,
    minute: 17,
    month: 1,
    second: 23,
    timezone: 0,
    year: 26
}

````

<br>


---

[Back](../namespace.process.md)