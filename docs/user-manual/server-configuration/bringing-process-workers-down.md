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

# Bringing process working down

Individual process workers can be brought down in two ways:

#### If you want to terminate all the worker processes

If you wish to terminate a worker processes, you need to send a SIGUSR1 to the process:

By doing so, an eventual onTerminate() event, mounted by a running application, will be executed.

````shell
kill -s SIGUSR1 {pid}
````

#### NOT RECOMMENDED, use it as last resource

If you wish to terminate a process worker AND the SIGUSR1 is not working, then you can send a SIGINT to the process to
terminate it:

> This will properly close the database and release the shared memory, but it will NOT execute eventual onTerminate()
> events, mounted by a running application.

````shell
kill -s SIGINT {pid}
````

OR

You can simply type `CTRL-C` from the running shell.

