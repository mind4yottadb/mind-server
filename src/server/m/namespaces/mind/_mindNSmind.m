;#################################################################
;#                                                               #
;# Copyright (c) 2025 DnaSoft B.V. and/or its subsidiaries.      #
;# All rights reserved.                                          #
;#                                                               #
;#   This source code contains the intellectual property         #
;#   of its copyright holder(s), and is made available           #
;#   under a license.  If you do not know the terms of           #
;#   the license, please stop and do not read further.           #
;#                                                               #
;#################################################################
;
;
; --------------------------------
; login
; --------------------------------
;
; parameters:
; 1 <username:password>
; 2 <driver name>
; 3 <driver version>
; 4 <description>
;
; response success
; *2
;   %2
;      +hostName
;       +<host name>
;      +mind version
;       +<mind version>
;   +OK
;
; response failure
; *2
;   +<error type>
;   +<error description>
;
; --------------------------------
login








loginQuit
    quit
;
;
; --------------------------------
; terminate
; --------------------------------
;
; parameters:
;
; response
;
; --------------------------------
terminate