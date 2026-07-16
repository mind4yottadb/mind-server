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

There are several command line switches available to change the behavior of the MIND server.

> Note: command line switches will override both internal default values and values found in
> this [configuration file]().

To get a list of all available switches, use the [`--help`](#--help) switch.

To display the MIND version, use the [`--version`](#--version) switch.

Additionally, The following switches will be accepted:

- [`--version`](#--version)
- [`--help`](#--help)
- [`--protocol={TCP || UDS}`](#--protocoltcpuds)
- [`--port={portNumber}`](#--portportnumber)
- [`--use-tls`](#--use-tlsvalue)
- [`--uds-file={filename}`](#--uds-filefilename)
- [`--idle-timeout`](#--idle-timeoutvalue)
- [`--log-level={value}`](#--log-levelvalue)
- [`--log-file={/path/to/file}`](#--log-filepathtofile)
- [`--dump-request={value}`](#--dump-requestvalue)
- [`--dump-response={value}`](#--dump-responsevalue)
- [`--statistics={value}`](#--statisticsvalue)
- [`--error-dump={value}`](#--error-dumpvalue)
- [`--uapi-dir={path/to/dir}`](#--uapi-dirpathtodir)
- [`--show-app-details`](#--show-app-details)
- [`--console-width`](#--console-widthvalue)
- [`--ctrl-c`](#--ctrl-cvalue)

<br>

#### --protocol={TCP || UDS}

---

Specify the transport protocol used to communicate with the clients.

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

#### --port={portNumber}

---

Set the TCP port the server is listening to. The value can be a numerical value between 80 and 49151.

The default value is `10000`

> This value gets ignored when the `protocol` is set to `UDS`

<br>

#### --uds-file={filename}

---

If set, it will change the name of the uds file

The default value is `mind4yottadb`

> This value gets ignored when the `protocol` is set to `TCP`

<br>

#### --log-level={value}

---

Set the log level that gets displayed in the console or written to a file.

The default value is `commands`

You can choose between the following:

- `none` no logging is done
- `sessions` will log only sessions information (like connect, disconnect, etc.)
- `commands` will log also all the commands received and their execution result
- `responses` will log also the responses sent to the clients

<br>

#### --log-file={/path/to/file}

---

Specifies a file to log into instead of the console (the default).

The default value is: `<empty string>`

> Note: the file won't be cleared at startup and all new data will be appended to it.

<br>

#### --user-commands-dir={/path/to/dir}

---

Should point to a new directory that will be used to host the user's defined functions.

The default value is: `$ydb_dist/plugin/etc/mind/usercommands` and the directory gets automatically created by the
installation program.

<br>

#### --dump-request={value}

---

If set, it will include in the log also the complete command request (command name and parameters)

The default value is `off`

Possible values are:

- `on`
- `off`

<br>

#### --dump-response={value}

---

If set, it will include in the log also the complete command response

The default value is `off`

Possible values are:

- `on`
- `off`

<br>

#### --use-tls={value}

---

If set, it will use TLS

The default value is `off`

Possible values are:

- `on`
- `off`

<br>

#### --statistics={value}

---

The default values is: `off`

Turns statistics off or to a specific level.

Possible values are:

- `off` will switch statistics off
- `grand` will only record grand totals
- `details` will record also statistics related to each command

<br>

#### --error-dump={value}

---

Specify if and how internal errors are displayed in the log.

The default values is: `none`

Possible values are:

- `none` will turn errors dump off
- `brief` will log only the $zstatus
- `extended` will log all the stack along with the $zstatus

<br>

#### --show-app-details

---

Displays a complete list of the methods , hooks and vars for each found uAPI app.

<br>

#### --version

---

Displays the MIND server version.

<br>

#### --help

---

Displays this page

<br>

#### --uapi-dir={/path/to/dir}

---

Specifies the directory to be used for the userAPI.

<br>

#### --console-width={value}

---

Changes the width of the console output.

It can be a value between 32 and 1024.

The default value is 132.

> This setting will be ignored if the log target is a file.

<br>

### --idle-timeout={value}

---

The number of MINUTES of inactivity to wait before to automatically disconnect.

The counter gets reset on each executed command.

> The default value is 30 minutes

<br>

### --ctrl-c={value}

---

Determine the action performed when pressing CTRL-C from the terminal window.

The `server-only` option will bring only the socket server down and all the existing sessions will keep running.

The `all-processes` option will first bring down the socket server, then send a SIGUSR2 to ALL EXISTING SESSIONS to
initiate a safe shutdown.

> The default value is `all-processes`

<br>
