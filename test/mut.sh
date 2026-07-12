#!/bin/bash
#################################################################
#                                                               #
# Copyright (c) 2026 DnaSoft B.V. and/or its subsidiaries.       #
# All rights reserved.                                          #
#                                                               #
#    This source code contains the intellectual property	      #
#    of its copyright holder(s), and is made available	        #
#    under a license.  If you do not know the terms of	        #
#    the license, please stop and do not read further.	        #
#                                                               #
#################################################################

export test_branch=$1

if [ "$test_branch" = "" ]; then
  export test_branch="main"
fi

if [ "$test_branch_server" != "" ]; then
  export test_branch="$test_branch_server"
fi

. $ydb_dist/ydb_env_set

if ! yottadb -r ^mindCmake; then
	exitCode=$(($exitCode + 1))
fi

exit

exitCode=0

if ! yottadb -r ^mindCommandLineParser; then
	exitCode=$(($exitCode + 1))
fi

if ! yottadb -r ^mindConfigFileParser; then
	exitCode=$(($exitCode + 2))
fi

if ! yottadb -r ^mindUsersFile; then
	exitCode=$(($exitCode + 4))
fi

if ! yottadb -r ^mindUserApiFileParser; then
	exitCode=$(($exitCode + 8))
fi

if ! yottadb -r ^mindSettingsOverrides; then
	exitCode=$(($exitCode + 16))
fi

echo "Global exit code: "$exitCode

exit $exitCode

# current total: 414
