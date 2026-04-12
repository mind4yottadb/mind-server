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

# The command line switches

There are several command line switches available to change the behaviour of the MIND server.

> Note: command line switches will override bothdefault values and values found in this configuration file.

##### The following entries will be accepted

- [`--port={portNumber}`](#--portportnumber)
- [`--log-level={value}`](#--loglevelvalue)
- [`--log-file={/path/to/file}`](#--log-filepathtofile)
- [`--dump-request={value}`](#--dump-requestvalue)
- [`--dump-response={value}`](#--dump-responsevalue)
- [`--statistics={value}`](#--statisticsvalue)
- [`--error-dump={value}`](#--error-dumpvalue)
- [`--version`](#--version)
- [`--help`](#--help)
- [`use-tls`](#--use-tlsvalue)
- [`uapi-dir={path/to/dir}`](#--uapi-dirpathtodir)

##### Anything else will be discarded and return a 'warning', but won't prevent MIND from starting up.

---

### --port={portNumber}

Set the TCP port the server is listening to. The value can be a numerical value between 80 and 49151.

The default value is `10000`

---

### --log-level={value}

Set the log level.

You can choose between the following:

- `none` no logging is done
- `sessions` will log only sessions information (like connect, disconnect, etc.)
- `commands` will log also all the commands received and their execution result
- `responses` will log also the responses sent to the clients

The default value is `commands`

---

### --log-file={/path/to/file}

Specifies a file to log into instead of the console (the default).

> Note: the file won't be cleared at startup and all new data will be appended to it.

The default value is: `<empty string>`

---

### --user-commands-dir={/path/to/dir}

Should point to a new directory that will be used to host the user's defined functions.

The default value is: `$ydb_dist/plugin/etc/mind/usercommands` and the directory gets automatically created by the
installation program.

---

### --dump-request={value}

If set, it will include in the log also the complete command request (command name and parameters)

Possible values are:

- `on`
- `off`

The default value is `off`

---

### --dump-response={value}

If set, it will include in the log also the complete command response

Possible values are:

- `on`
- `off`

The default value is `off`

---

### --use-tls={value}

If set, it will use TLS

Possible values are:

- `on`
- `off`

The default value is `off`

---

### --statistics={value}

Turns statistics off or to a specific level.

Possible values are:

- `off` will switch statistics off
- `grand` will only record grand totals
- `details` will record also statistics related to each command

The default values is: `off`

---

### --error-dump={value}

Specify if and how internal errors are displayed in the log.

Possible values are:

- `none` will turn errors dump off
- `brief` will log only the $zstatus
- `extended` will log all the stack along with the $zstatus

---

### --version

Displays the MIND server version.

---

### --help

Displays this page

---

### --uapi-dir={/path/to/dir}

Specifies the directory to be used for the userAPI


---
