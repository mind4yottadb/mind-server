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

# MIND apps: the uAPI

A `mind app` sits on top of the MIND server and extends its remote capabilities.
It allows you map extrinsic function and routines to be executed by the remote client.

Additionally, allows you to share variables between remote calls, creating a stateful session.

Code can be either .m routines or a compiled .so file. Additionally, you can map existing code reacjable by the $
zroutines (meaning you can remotely
execute any code).

We provide a very simple library to accept and return any of the following datatypes:

- `string`
- `float`
- `int`
- `boolean`
- `object`

We also provide events (`onInit`, `onError` and `onTerminate`) where you can hook your own code.

Data conversion between M and the client's target language is fully transparent to the programmer.

Multiple apps can be loaded and shared by a single server session.

We also provide a template project where you can write, debug and create an installable package for safe deployments.

- Basic principles
- The working directory
- M Routines
    - Return values
    - RESP3 formatters
    - Global scoped variables
    - Error handling
- The application JSON file
    - [namespaces](app-namespace.md)
    - [methods](app-method.md)
    - [properties](app-property.md)
    - [Parameters](app-parameter.md)
