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
	; update session information
	set buffer("username")=$zpiece(%params(1),":",1)
	do edit^%mindSessions(.buffer)
	;
	; start collecting information and embed it in the response
	;
	; array entries
	set %res=%res_"*3"_CRLF
	;
	; first entry: +OK
	set %res=%res_"+OK"_CRLF
	;
	; second entry: server
    set %res=%res_%mindParams("serverInfo")
	;
	; third entry: process
	set %res=%res_"%1"_CRLF
	;
    set %res=%res_"+pid"_CRLF
    set %res=%res_"+"_$job_CRLF
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
    do buildMap^%mindRESP3(.buffer)
    set %res=buffer
    ;
    quit
    ;
    ;
; ************************************************************
; kill
; ************************************************************
; parameters:
; 1 pid
; 2 sigNumber
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
; ************************************************************
; GUID
; ************************************************************
; parameters:
; 1 format
;
; Returns:
; <RESP3 SIMPLE STRING>> guid
;
GUID
    new guid
    ;
    set guid=$zyhash($zut,$zut),guid=$zextract(guid,3,$zlength(guid))
    set:$find(%params(1),"D") guid=$zextract(guid,1,8)_"-"_$zextract(guid,9,12)_"-"_$zextract(guid,13,16)_"-"_$zextract(guid,17,20)_"-"_$zextract(guid,21,50)
    set:$find(%params(1),"B") guid="{"_guid_"}"
    ;
    set %res="+"_guid_CRLF
    quit
    ;
    ;
getHostName()
    new hostName,file
    ;
    set file="/etc/hostname",hostName=""
    ;
    open file:(READONLY:EXCEPTION="goto getHostNameError")
    use file read hostName close file
    ;
    quit hostName
    ;
getHostNameError
    quit "Not available"
    ;
    ;
; ************************************************************
; stats
; ************************************************************
; parameters:
;
; Returns:
; <RESP3 BLOB> {json}
;
; ************************************************************
stats
    if $data(^%mindSessions("stats"))<9 set %res="+no data"_CRLF quit
    ;
    new buffer,ix,JDOM
    ;
    ; grand totals first
    set buffer("grand_total","total_received")=$get(^%mindSessions("stats","_grand","rec"),0)-1
    set buffer("grand_total","total_ok")=$get(^%mindSessions("stats","_grand","ok"),0)
    set buffer("grand_total","total_nok")=$get(^%mindSessions("stats","_grand","nok"),0)
    set buffer("grand_total","total_invalid_cmd")=$get(^%mindSessions("stats","_grand","invalid_cmd"),0)
    ;
    ; then details, if available
    set ix="" for  set ix=$order(^%mindSessions("stats",ix)) quit:ix=""  do
    . quit:$extract(ix,1,1)="_"!(ix="session.stats")
    . set buffer(ix,"total_received")=$get(^%mindSessions("stats",ix,"rec"),0)
    . set buffer(ix,"total_ok")=$get(^%mindSessions("stats",ix,"ok"),0)
    . set buffer(ix,"total_nok")=$get(^%mindSessions("stats",ix,"nok"),0)
    . set buffer(ix,"total_invalid_cmd")=$get(^%mindSessions("stats",ix,"invalid_cmd"),0)
    ;
    do stringify^%mindJSON("buffer","JDOM","JSONerr")
    if $data(JSONerr) set %res="-Error serializing JSON: "_$get(JSONerr(1))_" "_$get(JSONerr(2))_CRLF quit
    ;
    set ix="" for  set ix=$order(JDOM(ix)) quit:ix=""  set %res=%res_JDOM(ix)
    ;
    set %res=$$buildBlob^%mindRESP3(%res)
    ;
    quit
    ;
    ;
; ************************************************************
; listSessions
; ************************************************************
; parameters:
;
; Returns:
; <RESP3 BLOB> {json}
;
; ************************************************************
listSessions
    new ix,buffer,cnt,unixtime,elapsed
    new sec,min,hour,mday,mon,year,wday,yday,isdst,tzone
    ;
    set unixtime=$zut,ix="",cnt=0
    for  set ix=$order(^%mindSessions(ix)) quit:+ix=0  do
    . set cnt=cnt+1
    . set buffer(cnt,"pid")=ix
    . set buffer(cnt,"ipNumber")=$get(^%mindSessions(ix,"ipNumber"))
    . set buffer(cnt,"username")=$get(^%mindSessions(ix,"username"))
    . set buffer(cnt,"driverName")=$get(^%mindSessions(ix,"driverName"))
    . set buffer(cnt,"driverVersion")=$get(^%mindSessions(ix,"driverVersion"))
    . set buffer(cnt,"description")=$get(^%mindSessions(ix,"description"))
    . ;
    . set elapsed=(unixtime-$get(^%mindSessions(ix,"connectTime"),0))/1E6
    . do &ydbposix.localtime(elapsed,.sec,.min,.hour,.mday,.mon,.year,.wday,.yday,.isdst,.err)
    . set buffer(cnt,"elapsedTime","sec")=sec
    . set buffer(cnt,"elapsedTime","min")=min
    . set buffer(cnt,"elapsedTime","hour")=hour
    ;
    do stringify^%mindJSON("buffer","JDOM","JSONerr")
    if $data(JSONerr) set %res="-Error serializing JSON: "_$get(JSONerr(1))_" "_$get(JSONerr(2))_CRLF quit
    ;
    set ix="" for  set ix=$order(JDOM(ix)) quit:ix=""  set %res=%res_JDOM(ix)
    ;
    set %res=$$buildBlob^%mindRESP3(%res)
    ;
    quit
    ;
    ;
compileServerInfo()
    new serverArray
    ;
    set serverArray=""
	; second entry: server
	set serverArray=serverArray_"%5"_CRLF
	;
    set serverArray=serverArray_"+hostName"_CRLF
    ;
    set serverArray=serverArray_"+"_$$getHostName()_CRLF
    ;
    set serverArray=serverArray_"+mindVersion"_CRLF
    set serverArray=serverArray_"+"_%mindVersion_CRLF
    ;
    set serverArray=serverArray_"+ydbVersion"_CRLF
    set serverArray=serverArray_"+"_$zpiece($zyrelease," ",2)_CRLF
    ;
    set serverArray=serverArray_"+platform"_CRLF
    set serverArray=serverArray_"+"_$zpiece($zyrelease," ",3)_CRLF
    ;
    set serverArray=serverArray_"+architecture"_CRLF
    set serverArray=serverArray_"+"_$zpiece($zyrelease," ",4)_CRLF
	;
	quit serverArray
	;
	;
; ************************************************************
; syslogMessage
; ************************************************************
; parameters:
; 1 message
;
; Returns:
; <RESP3 SIMPLE STRING>> ok
;
; ************************************************************
syslogMessage
    if $zsyslog(%params(1))
    ;
    set %res="+ok"_CRLF
    ;
    quit
    ;
    ;
