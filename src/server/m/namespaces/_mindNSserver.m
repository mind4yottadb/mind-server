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
; 1 username:password
; 2 driver name
; 3 driver version
; 4 description
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
    set:%mindParams("stats")=2 ret=$increment(^%mindSessions("stats","server","login"))
    ;
    new driverInfo,ix,found,username,password
	new file,fbuffer,envVars,envVar
    ;
    ;
    ; verify mindParams
    if $zpiece(%params(1),":",1)=""!($zpiece(%params(1),":",2)="") set %res="*2"_CRLF_"-MISSING CREDENTIAL(s)"_CRLF_"-username and/or password not provided"_CRLF goto loginQuit
    ;
    ; update driver info
    set driverInfo("driverName")=%params(2),driverInfo("driverVersion")=%params(3),driverInfo("description")=%params(4),driverInfo("ipNumber")=%remoteIp
    do edit^%mindSessions(.driverInfo)
	;
    ; perform the login
    set found=0,ix=""
    set username=$zpiece(%params(1),":",1),password=$zpiece(%params(1),":",2)
    for  set ix=$order(%mindParams("users",ix)) quit:ix=""  do  quit:found
    . if %mindParams("users",ix,"username")=username,%mindParams("users",ix,"password")=password set found=1
    ;
    ; return error and quit if authentication fails
    if 'found set %res="-LOGIN FAILED Invalid credentials"_CRLF goto loginQuit
	;
	; start collecting information and embed it in the response
	;
	; array entries
	set %res=%res_"*4"_CRLF
	;
	; first entry: +OK
	set %res=%res_"+OK"_CRLF
	;
	; second entry: server
	set %res=%res_"%5"_CRLF
	;
    set %res=%res_"+hostName"_CRLF
    set %res=%res_"+HOST"_CRLF
    ;
    set %res=%res_"+mindVersion"_CRLF
    set %res=%res_"+"_%mindVersion_CRLF
    ;
    set %res=%res_"+ydbVersion"_CRLF
    set %res=%res_"+"_$zpiece($zyrelease," ",2)_CRLF
    ;
    set %res=%res_"+platform"_CRLF
    set %res=%res_"+"_$zpiece($zyrelease," ",3)_CRLF
    ;
    set %res=%res_"+architecture"_CRLF
    set %res=%res_"+"_$zpiece($zyrelease," ",4)_CRLF
	;
	; third entry: process
	set %res=%res_"%1"_CRLF
	;
    set %res=%res_"+pid"_CRLF
    set %res=%res_"+"_$job_CRLF
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
	set %res=%res_"%"_($order(envVars(""),-1)-1)_CRLF
	;
	for ix=1:1:$order(envVars(""),-1)-1  do
    . set %res=%res_"+"_$zpiece(envVars(ix),"=",1)_CRLF
    . set %res=%res_"+"_$zpiece(envVars(ix),"=",2,99)_CRLF
    ;
    do log^%mindLogger(%trm("yellow")_"  Using "_driverInfo("driverName")_" version "_driverInfo("driverVersion")_%trm("white"))
    do log^%mindLogger(%trm("yellow")_"  User: "_username_%trm("white"))
	;
loginQuit
	quit
;
;
; ************************************************************
; pinfo
; ************************************************************
; parameters:
; 1 pid
;
; Returns:
; <RESP3 MAP>
;
; ************************************************************
pinfo
    set:%mindParams("stats")=2 ret=$increment(^%mindSessions("stats","server","pinfo"))
    ;
    new isAlive,pUserTime,pSystemTime,cUserTime,cSystemTime,tCpu
    new buffer,ix,cnt
    ;
    set buffer("isAlive")=$zgetjpi(+$get(%params(1)),"ISPROCALIVE")
    set buffer("tCpu")=$zgetjpi(+$get(%params(1)),"CPUTIM")
    set buffer("cSystemTime")=$zgetjpi(+$get(%params(1)),"CSTIME")
    set buffer("cUserTime")=$zgetjpi(+$get(%params(1)),"CUTIME")
    set buffer("pSystemTime")=$zgetjpi(+$get(%params(1)),"STIME")
    set buffer("pUserTime")=$zgetjpi(+$get(%params(1)),"UTIME")
    ;
    set cnt=0,ix="" for  set ix=$order(buffer(ix)) quit:ix=""  do
    . set %res=%res_"+"_ix_CRLF_"+"_buffer(ix)_CRLF
    . set cnt=cnt+1
	;
    set %res="%"_cnt_CRLF_%res
    ;
    quit
    ;
    ;
; ************************************************************
; kill
; ************************************************************
; parameters:
; 1 pid
; 1 sigNumber
;
; Returns:
; <RESP3 SIMPLE STRING>> ok
;
kill
    set:%mindParams("stats")=2 ret=$increment(^%mindSessions("stats","server","kill"))
    ;
    if +$get(%params(1))=0 set %res="-the PID has not been provided"_CRLF quit
    if +$get(%params(2))'=2,+$get(%params(2))'=9 set %res="-the signal number is not valid"_CRLF quit
    ;
    set ret=$zsigproc(%params(1),%params(2))
    if ret'=0 set %res="-returned error: "_ret_CRLF quit
	;
    set %res="+ok"_CRLF
    ;
    quit
    ;
    ;
