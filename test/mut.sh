#!/bin/bash
#################################################################
#                                                               #
# Copyright (c) 2024 YottaDB LLC and/or its subsidiaries.       #
# All rights reserved.                                          #
#                                                               #
#    This source code contains the intellectual property	      #
#    of its copyright holder(s), and is made available	        #
#    under a license.  If you do not know the terms of	        #
#    the license, please stop and do not read further.	        #
#                                                               #
#################################################################

. $ydb_dist/ydb_env_set

exitCode=0

if ! yottadb -r ^mindCommandLineParser; then
	exitCode=1
fi

if ! yottadb -r ^mindConfigFileParser; then
	exitCode=1
fi

if ! yottadb -r ^mindUsersFile; then
  exitCode=1
fi

if ! yottadb -r ^mindUserApiFileParser; then
	exitCode=1
fi

echo "Exit code: "$exitCode

exit $exitCode

