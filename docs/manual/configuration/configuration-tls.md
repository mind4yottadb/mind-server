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

# Configuring TLS

TLS allows you to encrypt all the traffic between the MIND Server and the MIND client.

It can be switched on only if:

- TLS is installed in the MIND server (default is not installed)
- TLS is properly configured and your certificates (whether CA or self-signed) are available

To understand if TLS is installed and configured on your system, start MIND up and look at the startup sequence:
If the line saying: `use TLS:` is populated with `Not installed or configured` it means that either the libraries or the
configuration file are not present.
If the line saying: `use TLS:` is populated with `No` it means that everything checks out, and once your tls
configuration file points to your certificate files you can simply switch it on, by changing either the conf file or use
the command line switch `--use-tls`.
If the line saying: `use TLS:` is populated with `Yes` and the log returns no error after a client tries to connect, it
means you are all good, it is working.

---

Installing TLS on your MIND server

---

bla bla


<br>

Configuring TLS on your server with your certificate files

---

bla bla