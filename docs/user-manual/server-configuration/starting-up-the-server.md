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

# Starting up the server

By default, the server uses its internal default values, which are the following:

- Transport protocol: `TCP`
- Listening port: `10000`
- Use TLS: `No`
- Log level: `commands`
- Log to: `CONSOLE`
- Dump requests: `No`
- Dump responses: `No`
- Statistics: `Off`
- Errors dump: `Brief`
- User API dir: `$ydb_dist/plugin/etc/mind/uApi/`

However, these values can be overridden by the `mind.conf` file and the command line switches.

If a parameter is present in both the configuration file and the command line, **the command line takes the precedence
**.

At startup, the server displays a splash screen, displaying the following information:

- The processing of the configuration file
- The processing of the users file
- The existence of uAPI json files
- The parsing and compilation of the uAPI json files.
- An overview of all the server parameters

#### IMPORTANT

During the startup:

- errors in the `mind.conf` file gets reported, but they get ignored and won't prevent MIND to be launched.
- errors in the user file are FATAL and will exit with the exit code of 1.
- errors in the uAPI json files will be reported, including the error type and the location in the document
  AND **will prevent the app to be loaded and available to the clients**, but it won't prevent MIND to be launched.


