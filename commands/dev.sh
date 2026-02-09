#!/bin/bash
#################################################################
#                                                               #
# Copyright (c) 2025 DnaSoft BV and/or its subsidiaries.        #
# All rights reserved.                                          #
#                                                               #
#   This source code contains the intellectual property         #
#   of its copyright holder(s), and is made available           #
#   under a license.  If you do not know the terms of           #
#   the license, please stop and do not read further.           #
#                                                               #
#################################################################

echo "Initializing MIND for YottaDB dev environment..."
export ydb_routines='/opt/mind/o*(/opt/mind/m /opt/mind/test/m) /opt/yottadb/current/libyottadbutil.so'
source /opt/yottadb/current/ydb_env_set
source /opt/mind/aliases
echo "MIND for YottaDB dev environment initialized"
