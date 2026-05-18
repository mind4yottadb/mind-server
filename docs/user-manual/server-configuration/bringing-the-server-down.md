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

# Bringing the server down

The server can be brought in two different ways:

#### If you want to keep the worker processes running

If you wish to keep all the worker processes running, then you need to terminate the process with a SIGINT:

````shell
kill -s SIGINT {pid}
````

#### If you want to terminate all the worker processes

If you wish to keep all the worker processes running, then you need to terminate the process with a SIGUSR1:

````shell
kill -s SIGUSR1 {pid}
````

OR

You can simply type `CTRL-C` from the running shell.

