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

# The configuration file

The configuration file is the first file to be read when MIND starts up.
Any entry will override the parameter default value.

The configuration file is located in the following directory:
`$ydb_dist/plugin/etc/mind/mind.conf`
and it is created at installation time.

> Note: command line switches will override also values found in this configuration file.

### File syntax:

##### The following lines will be ignored:

- Empty lines
- Lines with only spaces or tabs
- Comment lines starting with the `#` character

##### The following entries will be accepted

- [`port={portNumber}`](#portportnumber)
- [`log-level={value}`](#loglevelvalue)
- [`log-file={/path/to/file}`](#log-filepathtofile)
- [`user-commands-dir={/path/to/dir}`](#user-commands-dirpathtodir)
- [`dump-request={value}`](#dump-requestvalue)
- [`statistics={value}`](#statisticsvalue)
- [`error-dump={value}`](#error-dumpvalue)

##### Anything else will be discarded and return a 'warning', but won't prevent MIND from starting up.

---

### port={portNumber}

Set the TCP port the server is listening to. The value can be a numerical value between 80 and 49151.

The default value is `10000`

### log-level={value}

Set the log level.

You can choose between the following:

- `none` no logging is done
- `sessions` will log only sessions information (like connect, disconnect, etc.)
- `commands` will log also all the commands received and their execution result
- `responses` will log also the responses sent to the clients

The default value is `commands`

### log-file={/path/to/file}

Specifies a file to log into instead of the console (the default).

> Note: the file won't be cleared at startup and all new data will be appended to it.

The default value is: `<empty string>`

### user-commands-dir={/path/to/dir}

Should point to a new directory that will be used to host the user's defined functions.

The default value is: `$ydb_dist/plugin/etc/mind/usercommands` and the directory gets automatically created by the
installation program.

### dump-request={value}

If set, it will include in the log also the complete command request (command name and parameters)

Possible values are:

- `on`
- `off`

The default value is `off`

### statistics={value}

Turns statistics off or to a specific level.

Possible values are:

- `off` will switch statistics off
- `grand` will only record grand totals
- `details` will record also statistics related to each command

The default values is: `off`

### error-dump={value}

Specify if and how internal errors are displayed in the log.

Possible values are:

- `none` will turn errors dump off
- `brief` will log only the $zstatus
- `extended` will log all the stack along with the $zstatus

