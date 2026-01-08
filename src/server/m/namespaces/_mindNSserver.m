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
; ************************************************************
; login
; ************************************************************
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
    if $zpiece(command(2),":",1)=""!($zpiece(command(2),":",2)="") set %mindRes="*2"_CRLF_"-MISSING CREDENTIAL(s)"_CRLF_"-username and/or password not provided"_CRLF,%mindRes("status")=0 goto loginQuit
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
    if 'found set %mindRes="-LOGIN FAILED Invalid credentials"_CRLF,%mindRes("status")=0 goto loginQuit
	;
	; start collecting information and embed it in the response
	;
	; array entries
	set %mindRes=%mindRes_"*4"_CRLF
	;
	; first entry: +OK
	set %mindRes=%mindRes_"+OK"_CRLF
	;
	; second entry: server
		set %mindRes=%mindRes_"%5"_CRLF
	;
        set %mindRes=%mindRes_"+hostName"_CRLF
        set %mindRes=%mindRes_"+HOST"_CRLF
        ;
        set %mindRes=%mindRes_"+mindVersion"_CRLF
        set %mindRes=%mindRes_"+"_%mindVersion_CRLF
        ;
        set %mindRes=%mindRes_"+ydbVersion"_CRLF
        set %mindRes=%mindRes_"+"_$zpiece($zyrelease," ",2)_CRLF
        ;
        set %mindRes=%mindRes_"+platform"_CRLF
        set %mindRes=%mindRes_"+"_$zpiece($zyrelease," ",3)_CRLF
        ;
        set %mindRes=%mindRes_"+architecture"_CRLF
        set %mindRes=%mindRes_"+"_$zpiece($zyrelease," ",4)_CRLF
	;
	; third entry: process
	set %mindRes=%mindRes_"%1"_CRLF
	;
        set %mindRes=%mindRes_"+pid"_CRLF
        set %mindRes=%mindRes_"+"_$job_CRLF
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
	set %mindRes=%mindRes_"%"_($order(envVars(""),-1)-1)_CRLF
	;
	for ix=1:1:$order(envVars(""),-1)-1  do
        . set %mindRes=%mindRes_"+"_$zpiece(envVars(ix),"=",1)_CRLF
        . set %mindRes=%mindRes_"+"_$zpiece(envVars(ix),"=",2,99)_CRLF
        ;
	;
	set %mindRes("status")=1
	;
loginQuit
	quit
;
;
; ************************************************************
; pinfo
; ************************************************************
pinfo
    new isAlive,pUserTime,pSystemTime,cUserTime,cSystemTime,tCpu
    new buffer,ix,cnt
    ;
    set buffer("isAlive")=$zgetjpi(+$get(command(2)),"ISPROCALIVE")
    set buffer("tCpu")=$zgetjpi(+$get(command(2)),"CPUTIM")
    set buffer("cSystemTime")=$zgetjpi(+$get(command(2)),"CSTIME")
    set buffer("cUserTime")=$zgetjpi(+$get(command(2)),"CUTIME")
    set buffer("pSystemTime")=$zgetjpi(+$get(command(2)),"STIME")
    set buffer("pUserTime")=$zgetjpi(+$get(command(2)),"UTIME")
    ;
    set cnt=0,ix="" for  set ix=$order(buffer(ix)) quit:ix=""  do
    . set %mindRes=%mindRes_"+"_ix_CRLF_"+"_buffer(ix)_CRLF
    . set cnt=cnt+1
	;
    set %mindRes="%"_cnt_CRLF_%mindRes,%mindRes("status")=1
    ;
    quit
    ;
    ;
; ************************************************************
; kill
; ************************************************************
kill
    if +$get(command(2))=0 set %mindRes="-the PID has not been provided"_CRLF,%mindRes("status")=0 quit
    if +$get(command(3))'=2,+$get(command(3))'=9 set %mindRes="-the signal number is not valid"_CRLF,%mindRes("status")=0 quit
    ;
    set ret=$zsigproc(command(2),command(3))
    if ret'=0 set %mindRes="-returned error: "_ret_CRLF,%mindRes("status")=0 quit
	;
    set %mindRes="+ok"_CRLF,%mindRes("status")=1
    ;
    quit
    ;
    ;
