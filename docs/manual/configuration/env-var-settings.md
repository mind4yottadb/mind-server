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

# The environment variables settings

The environment variables settings is needed for those settings that MUST be set before the YottaDB image gets loaded
into memory.

The two settings that are important to MIND are the following:

- `ydb_max_sockets`
  <br>It sets the maximum number of socket instances allowed by the process. The default value is 64 and the startup
  file provided by MIND
  sets it to 16384. For details about this setting
  visit [YottaDB Administration and Operations Guide: ydb-max-sockets](https://docs.yottadb.com/AdminOpsGuide/basicops.html#ydb-max-sockets)
- `ydb_treat_sigusr2_like_sigusr1`
  <br>This setting is important when you are using a workers-pool and you want to change settings (for debug purposes)
  while the code is running, without the need to bring the entire pool down and up again.
  For this purpose we broadcast the SIGUSR2 signal to all processes in the pool.
  For details about this setting
  visit [YottaDB Administration and Operations Guide: ydb_treat_sigusr2_like_sigusr1](https://docs.yottadb.com/AdminOpsGuide/basicops.html#ydb-treat-sigusr2-like-sigusr1)
