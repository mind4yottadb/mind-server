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
;		+ydb version
;		+<ydb version>
;   +OK
;
; response failure
; *2
;   +<error type>
;   +<error description>
;
; --------------------------------
login
    write "LOGIN",!
    new driverInfo,ix,found,username,password
    ;
    ; update driver info
    set driverInfo("driverName")=command(3),driverInfo("driverVersion")=command(4),driverInfo("description")=command(5),driverInfo("ipNumber")=remoteIp
    do edit^%mindSessions(.driverInfo)
	;
    ; perform the login
    set found=0,ix=""
    set username=$zpiece(command(2),":",1),password=$zpiece(command(2),":",2)
    for  set ix=$order(%mindParams("users",ix)) quit:ix=""  do  quit:found
    . if %mindParams("users",ix,"username")=username,%mindParams("users",ix,"password")=password set found=1
    ;
    write "Found:"_found,!
	;
	;
	;
	;
	;
	;
	;
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