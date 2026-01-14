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

The configuration file is located in the following directory:
`$ydb_dist/plugin/etc/mind/mind.conf`
and it is created at installation time.

> Note: command line switches will override also values found in the configuration file.

### File syntax:

##### The following lines will be ignored:

- Empty lines
- Lines with only spaces or tabs
- Comment lines starting with the `#` character

##### The following entries will be accepted

- [`port={portNumber}`](#portportnumber)
- [`log-level={value}`](#loglevelvalue)
- [`log-file={/path/to/file}`](#log-filepathtofile)
- [`user-commands-dir={/path/to/dir}`](#user-commands-dirpathtodir)
- [`dump-request={value}`](#dump-requestvalue)
- [`statistics={value}`](#statisticsvalue)
- [`error-dump={value}`](#error-dumpvalue)

##### Anything else will be discarded and just return a 'warning', but won't prevent MIND from starting up.

---

### port={portNumber}

Description

### log-level={value}

### log-file={/path/to/file}

### user-commands-dir={/path/to/dir}

### dump-request={value}

### statistics={value}

### error-dump={value}



