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

The configuration file is called `mind.conf` and it is automatically created at installation time.

It is located in the following directory: `$ydb_dist/plugin/etc/mind`,
<br>

> Note: command line switches will override values set by the configuration file.

### File syntax:

- The file is an ASCII / UTF8 file
- Line separator can be either ASCII 10 or ASCII 13-10 pair
- Parameters are described using the key=value syntax

##### The following lines will be ignored:

- Empty lines
- Lines with only spaces or tabs
- Comment lines starting with the `#` character

##### The following parameters will be accepted

- [`protocol`](#protocolvalue)
- [`port={portNumber}`](#portportnumber)
- [`use-tls`](#use-tlsvalue)
- [`uds-file`](#uds-filefilename)
- [`uapi-dir={/path/to/dir}`](#uapidirpathtodir)
- [`idle-timeout`](#idle-timeoutvalue)
- [`log-level={value}`](#loglevelvalue)
- [`log-file={/path/to/file}`](#log-filepathtofile)
- [`dump-request={value}`](#dump-requestvalue)
- [`dump-response={value}`](#dump-responsevalue)
- [`statistics={value}`](#statisticsvalue)
- [`error-dump={value}`](#error-dumpvalue)
- [`ctrl-c`](#ctrl-cvalue)

##### Anything else will be discarded and return a 'warning', but won't prevent MIND from starting up.

---

## Parameters list

<br>

### port={portNumber}

---

Set the TCP port the server is listening to. The value can be a numerical value between 80 and 49151.

The default value is `10000`

> This value gets ignored when the `protocol` is set to `UDS`

<br>

### log-level={value}

---

Set the log level.

The default value is `commands`

You can choose between the following:

- `none` no logging is done
- `sessions` will log only sessions information (like connect, disconnect, etc.)
- `commands` will log also all the commands received and their execution result
- `responses` will log also the responses sent to the clients

<br>

### log-file={/path/to/file}

---

Specifies a file to log into instead of the console (the default).

The default value is: `<empty string>`

> Note: the file won't be cleared at startup and all new data will be appended to it.

<br>

### uApiDir={/path/to/dir}

---

Should point to a new directory that will be used to host the user's defined functions.

The default value is: `$ydb_dist/plugin/etc/mind/uApi` and the directory gets automatically created at
installation time.

<br>

### dump-request={value}

---

If set, it will include in the log also the complete command request (command name and parameters)

The default value is `off`

Possible values are:

- `on`
- `off`

<br>

### dump-response={value}

---

If set, it will include in the log also the complete command response

The default value is `off`

Possible values are:

- `on`
- `off`

<br>

### statistics={value}

---

Turns statistics off or to a specific level.

The default values is: `off`

Possible values are:

- `off` will switch statistics off
- `grand` will only record grand totals
- `details` will record also statistics related to each command

<br>

### error-dump={value}

---

Specify if and how internal errors are displayed in the log.

The default value is `none`

Possible values are:

- `none` will turn errors dump off
- `brief` will log only the $zstatus
- `extended` will log all the stack along with the $zstatus

<br>

### use-tls={value}

---

If set, it will use TLS

The default value is `off`

Possible values are:

- `on`
- `off`

<br>

### protocol={value}

---

Specify the transport protocol used to communicate with the clients.

The default value is `TCP`

Possible values are:

- `TCP`
- `UDS`

The `TCP` protocol is used to communicate with a MIND client located outside the host computer, through TPC/IP.
It can be additionally encrypted using TLS. See the [tls configuration]() section for more details.

By selecting `TCP` you can choose the port you want the server to listen to and override the default value,

The `UDS` is used to communicate with a MIND client located in the same machine as the server.
It is much faster than TCP, as it bypasses name resolution and packets checking and it is highly recommended when
architecture allows it.

By selecting `UDS` you can choose the uds-file you want the server to use and override its default value,

<br>

### uds-file={filename}

---

If set, it will change the name of the uds file

The default value is `mind4yottadb`

> This value gets ignored when the `protocol` is set to `TCP`

<br>

### idle-timeout={value}

---

The number of MINUTES of inactivity to wait before to automatically disconnect.

The default value is `30`

The counter gets reset on each executed command.

<br>

### ctrl-c={value}

---

Determine the action performed when pressing CTRL-C from the terminal window.

The `server-only` option will bring only the socket server down and all the existing sessions will keep running.

The `all-processes` option will first bring down the socket server, then send a SIGUSR2 to ALL EXISTING SESSIONS to
initiate a safe shutdown.

> The default value is `all-processes`

<br>
