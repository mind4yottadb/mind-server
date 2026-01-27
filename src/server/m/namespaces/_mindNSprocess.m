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
; cwdGet
; ************************************************************
; parameters:
;
; Returns:
; <RESP3 SIMPLE STRING> {path}
;
; ************************************************************
cwdGet
    set %res="+"_$zdirectory_CRLF
    ;
    quit
    ;
    ;
; ************************************************************
; cwdSet
; ************************************************************
; parameters:
; 1: Path
;
; Returns:
; <RESP3 SIMPLE STRING> ok
;
; ************************************************************
cwdSet
    if $get(%params(1))="" set %res="-the path has not been provided"_CRLF quit
    if $zsearch(%params(1))="" set %res="-the provided path does not exists or it is not accessible"_CRLF quit
    ;
    set $zdirectory=%params(1)
    set %res="+ok"
    ;
    quit
    ;
    ;
; ************************************************************
; spawn(command,stdoutlog)
; ************************************************************
; parameters:
; 1: command
; 2: stroutLog
;
; Returns:
; <RESP3 SIMPLE STRING> {pid}
;
; ************************************************************
spawn
    if $get(%params(1))="" set %res="-the command has not been provided"_CRLF quit
    ;
    new currentDevice,PID,device
    ;
    set %params(2)=$get(%params(2))
    set currentDevice=$zio
	set device="spawn-"_$job
    ;
    ; build command string
    set %params=%params(1)_$select(%params(2)="":"",-1:" > "_%params(2))
    ;
	open device:(shell="/bin/sh":command=%params:readonly:independent:exception="goto spawnOpenError^%mindNSprocess")::"pipe"
	use device
	set PID=$key
	close device
	;
	use currentDevice
    ;
    set %res="+"_PID_CRLF
    ;
    quit
    ;
spawnOpenError
    set %res="-the command returned the following error:"_$zstatus_CRLF
    ;
    quit
    ;
    ;
; ************************************************************
; exec(command,shell)
; ************************************************************
; parameters:
; 1: command
; 2: shell
;
; Returns:
; <RESP3 BLOB> {stdout}
;
; ************************************************************
exec
	; The shell parameter is used to use an alternative shell (like bash)
    if $get(%params(1))="" set %res="-the command has not been provided"_CRLF quit
    ;
	new device,string,currentdevice
	;
	set:%params(2)="" %params(2)="/bin/sh"
	;
	set currentdevice=$io
	set device="runshellcommmandpipe"_$job
	set return=""
	;
	open device:(shell=%params(2):command=%params(1):readonly:exception="goto execOpenError^%mindNSprocess"):5:"pipe"
	use device
	for  quit:$zeof=1  read string set return=return_string_LF
terminateRead
	close device ;if $get(return(counter))="" kill return(counter)
	;
	use currentdevice
	;
	if $zclose'=0 set %res="-the command returned error: "_$zclose_" "_return_CRLF quit
	;
	set %res=$$buildBlob^%mindRESP3(return)
    ;
	quit
	;
execOpenError
    if $piece($zstatus,",",1)=150373082 goto terminateRead
    set %res="-the command returned error: "_$zpiece($zstatus,",")_","_$zpiece($zstatus,",",4,99)_CRLF
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
    set %res=":"_($zut\1E6)_CRLF
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
    set %res=":"_($zut\$select(%params(1)="ms":1000,1:1))_CRLF
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
    if +$get(err)>0 set %res="-the command returned the internal error: "_err_CRLF quit
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
    set %res=buffer
    ;
    quit
    ;
    ;
; ************************************************************
; memUsage
; ************************************************************
; parameters:
;
; Returns:
; <RESP3 BLOB> {stdout}
;
; ************************************************************
memUsage
    new cnt,ix,buffer
    ;
    set buffer("realStorage")=$zrealstor
    set buffer("allocatedStorage")=$zallocstor
    set buffer("usedStorage")=$zusedstor
    ;
    do buildMap^%mindRESP3(.buffer)
    set %res=buffer
    ;
    quit
    ;
    ;
; ************************************************************
; getEnvVars
; ************************************************************
; parameters:
;
; Returns:
; <RESP3 MAP>
;
; ************************************************************
getEnvVars
    new file,fbuffer,envvars,ix
    ;
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
    quit
