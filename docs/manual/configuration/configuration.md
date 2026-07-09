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

# MIND server configuration

The MIND server allows you to configure many parameters through the configuration file, the command line switches and
environment variables.

---

The [configuration file]() is located in the `$ydb_dist/plugin/etc/mind` directory.

---

The [command-line switches]() can be used to override any parameter set in the conf file.

---

The [environment variables settings]() are used only to configure the following:

- Maximum number of sockets (YottaDB default is 64)
- Support for SIGUSR2 signal (recommended)

**NOTE:** The default MIND startup script has already these setting configured for you, with SIGUSR2 enabled and
MAX_SOCKETS set to 16384.

---

The [users file]() is used to specify remote client users credentials and roles.

---
