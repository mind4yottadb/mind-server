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
; *4
;   +OK
;   %5
;      +hostName
;       +<host name>
;      +mind version
;       +<mind version>
;		+ydb version
;		+<ydb version>
;		+platform
;		+<platform>
;		+architecture
;		+<architecture>
;
;   %4
;   arch
;   <arch>
;   cwd
;   <cwd>
;   pid
;   <pid>
;   platform
;   <platform>
;
;
;
;   PROCESS ENVS
;   +<name>
;   +<value>
;
; response failure
; *2
;   -<error type>
;   -<error description>
;
; --------------------------------
login
    new driverInfo,ix,found,username,password
	new file,fbuffer,envVars,envVar
    ;
    ;
    ; verify mindParams
    if $zpiece(command(2),":",1)=""!($zpiece(command(2),":",2)="") write "*2"_CRLF_"-MISSING CREDENTIAL(s)"_CRLF_"-username and/or password not provided"_CRLF goto loginQuit
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
    ; return error and quit if authentication fails
    if 'found write "*2"_CRLF_"-LOGIN FAILED"_CRLF_"-Invalid credentials"_CRLF goto loginQuit
	;
	; start collecting information and embed it in the response
	;
	; array entries
	write "*4"_CRLF
	;
	; first entry: +OK
	write "+OK"_CRLF
	;
	; second entry: server
	write "%5"_CRLF
	;
        write "+hostName"_CRLF
        write "+HOST"_CRLF
        ;
        write "+mindVersion"_CRLF
        write "+"_%mindVersion_CRLF
        ;
        write "+ydbVersion"_CRLF
        write "+"_$zpiece($zyrelease," ",2)_CRLF
        ;
        write "+platform"_CRLF
        write "+"_$zpiece($zyrelease," ",3)_CRLF
        ;
        write "+architecture"_CRLF
        write "+"_$zpiece($zyrelease," ",4)_CRLF
	;
	; third entry: process
	write "%4"_CRLF
	;
        write "+arch"_CRLF
        write "+"_$zpiece($zyrelease," ",4)_CRLF
        ;
        write "+cwd"_CRLF
        write "+"_$zdirectory_CRLF
        ;
        write "+pid"_CRLF
        write "+"_$job_CRLF
        ;
        write "+platform"_CRLF
        write "+"_$zpiece($zyrelease," ",3)_CRLF
        ;
	;
	; fourth entry: env vars
	;
	; get env vars
	set file="/proc/self/environ"
	open file:readonly use file read fbuffer close file
	set *envVars=$$SPLIT^%MPIECE(fbuffer,$zchar(0))
	;
	; and dump them in the response
	write "%"_($order(envVars(""),-1)-1)_CRLF
	;
	for ix=1:1:$order(envVars(""),-1)-1  do
        . write "+"_$zpiece(envVars(ix),"=",1)_CRLF
        . write "+"_$zpiece(envVars(ix),"=",2,99)_CRLF
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