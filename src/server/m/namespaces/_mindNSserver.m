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
; 5 app name (optional)
;
; response success
; *4
; --------------------------------
login
    set:%mindParams("stats")=2 ret=$increment(^%mindSessions("stats","server","login"))
    ;
    new driverInfo,ix,found,username,password
    ;
    ; verify mindParams
    if $zpiece(%mindArgs(1),":",1)=""!($zpiece(%mindArgs(1),":",2)="") set %mindRes="*2"_%mindCRLF_"-MISSING CREDENTIAL(s)"_%mindCRLF_"-username and/or password not provided"_%mindCRLF goto loginQuit
    ;
    ; update driver info
    set driverInfo("driverName")=%mindArgs(2),driverInfo("driverVersion")=%mindArgs(3),driverInfo("description")=%mindArgs(4),driverInfo("ipNumber")=%mindRemoteIp
    do edit^%mindSessions(.driverInfo)
	;
    ; perform the login
    set found=0,ix=""
    set username=$zpiece(%mindArgs(1),":",1),password=$zpiece(%mindArgs(1),":",2)
    for  set ix=$order(%mindParams("users",ix)) quit:ix=""  do  quit:found
    . if %mindParams("users",ix,"username")=username,%mindParams("users",ix,"password")=password set found=1
    ;
    ; return error and quit if authentication fails
    if 'found set %mindRes="-LOGIN FAILED Invalid credentials"_%mindCRLF goto loginQuit
	;
	; update session information
	set buffer("username")=$zpiece(%mindArgs(1),":",1)
	do edit^%mindSessions(.buffer)
	;
	; check if an app was requested and error out if not found
    if $get(%mindArgs(5))'="",$data(%mindParams("uApi",%mindArgs(5)))=0 do  goto loginQuit
    . set %mindRes="-app: "_%mindArgs(5)_" not found"
    ;
	; start collecting information and embed it in the response
	;
	; array entries
	set %mindRes=%mindRes_"*4"_%mindCRLF
	;
	; first entry: +OK
	set %mindRes=%mindRes_"+OK"_%mindCRLF
	;
	; second entry: server
    set %mindRes=%mindRes_%mindParams("serverInfo")
	;
	; third entry: process
	set %mindRes=%mindRes_"%2"_%mindCRLF
	;
    set %mindRes=%mindRes_"+pid"_%mindCRLF
    set %mindRes=%mindRes_"+"_$job_%mindCRLF
    ;
    set %mindRes=%mindRes_"+GUID"_%mindCRLF
    set %mindRes=%mindRes_"+"_%mindGUID_%mindCRLF
    ;
    set %mindRes=%mindRes_"+serverPid"_%mindCRLF
    set %mindRes=%mindRes_"+"_%mindParams("serverPid")_%mindCRLF
    ;
	; 4th entry entry: uApi JSON
	set %mindRes=%mindRes_$$buildBlob^%mindRESP3($select($get(%mindArgs(5))="":"",1:%mindParams("uApiJson",%mindArgs(5))))
	;
	; if app was requested, configure the %mindParams("uApi")
	if $get(%mindArgs(5))'="" do
	. merge temp=%mindParams("uApi",%mindArgs(5))
	. kill %mindParams("uApi")
	. merge %mindParams("uApi")=temp kill temp
	;
    do log^%mindLogger(%mindTrm("yellow")_"  Using "_driverInfo("driverName")_" version "_driverInfo("driverVersion")_%mindTrm("white"),%mindLogNONE)
    do log^%mindLogger(%mindTrm("yellow")_"  User: "_username_%mindTrm("white"),%mindLogNONE)
    ; log the app name, if found
    do:$get(%mindArgs(5))'="" log^%mindLogger(%mindTrm("yellow")_"  App name: "_%mindArgs(5),%mindLogNONE)
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
    set buffer("isAlive")=$zgetjpi(+$get(%mindArgs(1)),"ISPROCALIVE")
    set buffer("tCpu")=$zgetjpi(+$get(%mindArgs(1)),"CPUTIM")
    set buffer("cSystemTime")=$zgetjpi(+$get(%mindArgs(1)),"CSTIME")
    set buffer("cUserTime")=$zgetjpi(+$get(%mindArgs(1)),"CUTIME")
    set buffer("pSystemTime")=$zgetjpi(+$get(%mindArgs(1)),"STIME")
    set buffer("pUserTime")=$zgetjpi(+$get(%mindArgs(1)),"UTIME")
    ;
    do buildMap^%mindRESP3(.buffer)
    set %mindRes=buffer
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
    if +$get(%mindArgs(1))=0 set %mindRes="-the PID has not been provided"_%mindCRLF quit
    if +$get(%mindArgs(2))'=2,+$get(%mindArgs(2))'=9 set %mindRes="-the signal number is not valid"_%mindCRLF quit
    ;
    set ret=$zsigproc(%mindArgs(1),%mindArgs(2))
    if ret'=0 set %mindRes="-returned error: "_ret_%mindCRLF quit
	;
    set %mindRes="+ok"_%mindCRLF
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
    set:$find(%mindArgs(1),"D") guid=$zextract(guid,1,8)_"-"_$zextract(guid,9,12)_"-"_$zextract(guid,13,16)_"-"_$zextract(guid,17,20)_"-"_$zextract(guid,21,50)
    set:$find(%mindArgs(1),"B") guid="{"_guid_"}"
    ;
    set %mindRes="+"_guid_%mindCRLF
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
    if $data(^%mindSessions("stats"))<9 set %mindRes="+no data"_%mindCRLF quit
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
    if $data(JSONerr) set %mindRes="-Error serializing JSON: "_$get(JSONerr(1))_" "_$get(JSONerr(2))_%mindCRLF quit
    ;
    set ix="" for  set ix=$order(JDOM(ix)) quit:ix=""  set %mindRes=%mindRes_JDOM(ix)
    ;
    set %mindRes=$$buildBlob^%mindRESP3(%mindRes)
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
    if $data(JSONerr) set %mindRes="-Error serializing JSON: "_$get(JSONerr(1))_" "_$get(JSONerr(2))_%mindCRLF quit
    ;
    set ix="" for  set ix=$order(JDOM(ix)) quit:ix=""  set %mindRes=%mindRes_JDOM(ix)
    ;
    set %mindRes=$$buildBlob^%mindRESP3(%mindRes)
    ;
    quit
    ;
    ;
compileServerInfo()
    new serverArray
    ;
    set serverArray=""
	; second entry: server
	set serverArray=serverArray_"%5"_%mindCRLF
	;
    set serverArray=serverArray_"+hostName"_%mindCRLF
    ;
    set serverArray=serverArray_"+"_$$getHostName()_%mindCRLF
    ;
    set serverArray=serverArray_"+mindVersion"_%mindCRLF
    set serverArray=serverArray_"+"_%mindVersion_%mindCRLF
    ;
    set serverArray=serverArray_"+ydbVersion"_%mindCRLF
    set serverArray=serverArray_"+"_$zpiece($zyrelease," ",2)_%mindCRLF
    ;
    set serverArray=serverArray_"+platform"_%mindCRLF
    set serverArray=serverArray_"+"_$zpiece($zyrelease," ",3)_%mindCRLF
    ;
    set serverArray=serverArray_"+architecture"_%mindCRLF
    set serverArray=serverArray_"+"_$zpiece($zyrelease," ",4)_%mindCRLF
	;
	quit serverArray
	;
	;
; ************************************************************
; plist
; ************************************************************
; parameters:
;
; Returns:
; <RESP3 BLOB>> JSON
;
; ************************************************************
plist
    new ix,buffer,execArray,line,row,JDOM,JSONerr,JSON
    ;
    set %mindArgs(1)="ps -AF"
    do exec^%mindNSprocess
    ;
    set %mindRes=$zextract(%mindRes,$zfind(%mindRes,%mindCRLF),$zlength(%mindRes)-2)
    set *execArray=$$SPLIT^%MPIECE(%mindRes,LF)
    ;
    set ix="",row=0
    for  set ix=$order(execArray(ix)) quit:ix=""  do
    . set line=execArray(ix),row=row+1
    . kill buffer
    . ;
    . if $zfind(line,"UID")=0 do
    . . ; UID
    . . set buffer("uid")=$$FUNC^%TRIM($zextract(line,1,7))
    . . ; PID
    . . set buffer("pid")=+$$FUNC^%TRIM($zextract(line,9,16))
    . . ; PPID
    . . set buffer("ppid")=+$$FUNC^%TRIM($zextract(line,18,24))
    . . ; command
    . . set buffer("command")=$$FUNC^%TRIM($zextract(line,65,999))
    . . ;
    . . merge:buffer("pid") JDOM(row)=buffer
    ;
    do stringify^%mindJSON("JDOM","JSON","JSONerr")
    if $data(JSONerr) set %mindRes="-Error serializing JSON: "_$get(JSONerr(1))_" "_$get(JSONerr(2))_%mindCRLF quit
    ;
    set (ix,%mindRes)="" for  set ix=$order(JSON(ix)) quit:ix=""  set %mindRes=%mindRes_JSON(ix)
    ;
    set %mindRes=$$buildBlob^%mindRESP3(%mindRes)
    ;
    quit
    ;
    ;
; ************************************************************
; unixtime
; ************************************************************
; parameters:
;
; Returns:
; <RESP3 NUMBER> {unixtime}
;
; ************************************************************
unixtime
    set %mindRes=":"_($zut\1E6)_%mindCRLF
    ;
    quit
    ;
    ;
; ************************************************************
; now
; ************************************************************
; parameters:
; 1 resolution = "ms" || "us"
;
; Returns:
; <RESP3 NUMBER> {now}
;
; ************************************************************
now
    set %mindRes=":"_($zut\$select(%mindArgs(1)="ms":1000,1:1))_%mindCRLF
    ;
    quit
    ;
    ;
; ************************************************************
; datetime
; ************************************************************
; parameters:
;
; Returns:
; <RESP3 MAP>
;
; ************************************************************
datetime
    new sec,min,hour,mday,mon,year,wday,yday,isdst,tzone
    new unixtime,cnt,ix,buffer
    ;
    set unixtime=$zut\1E6
    do &ydbposix.localtime(unixtime,.sec,.min,.hour,.mday,.mon,.year,.wday,.yday,.isdst,.err)
    ;
    if +$get(err)>0 set %mindRes="-the command returned the internal error: "_err_%mindCRLF quit
    ;
    set buffer("second")=sec
    set buffer("minute")=min
    set buffer("hour")=hour
    ;
    set buffer("dayOfMonth")=mday
    set buffer("month")=mon+1
    set buffer("year")="20"_year#100
    ;
    set buffer("dayOfWeek")=wday+1
    set buffer("dayOfYear")=yday+1
    set buffer("daylightSaving")=isdst
    set buffer("timezone")=$zpiece($zhorolog,",",4)
    ;
    do buildMap^%mindRESP3(.buffer)
    set %mindRes=buffer
    ;
    quit
    ;
    ;
; ************************************************************
; horolog
; ************************************************************
; parameters:
;
; Returns:
; <RESP3 MAP>
;
; ************************************************************
horolog
    new buffer,ret
    ;
    set ret=$zhorolog
    set buffer("horolog")=$zpiece(ret,",",1,2)
    set buffer("microseconds")=$zpiece(ret,",",3)
    set buffer("utcOffset")=$zpiece(ret,",",4)
    ;
    do buildMap^%mindRESP3(.buffer)
    set %mindRes=buffer
    ;
    quit
    ;
    ;
