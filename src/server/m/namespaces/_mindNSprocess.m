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
    if $get(%args(1))="" set %res="-the path has not been provided"_CRLF quit
    if $zsearch(%args(1))="" set %res="-the provided path does not exists or it is not accessible"_CRLF quit
    ;
    set $zdirectory=%args(1)
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
    if $get(%args(1))="" set %res="-the command has not been provided"_CRLF quit
    ;
    new currentDevice,PID,device
    ;
    set %args(2)=$get(%args(2))
    set currentDevice=$zio
	set device="spawn-"_$job
    ;
    ; build command string
    set %args=%args(1)_$select(%args(2)="":"",-1:" > "_%args(2))
    ;
	open device:(shell="/bin/sh":command=%args:readonly:independent:exception="goto spawnOpenError^%mindNSprocess")::"pipe"
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
    if $get(%args(1))="" set %res="-the command has not been provided"_CRLF quit
    ;
	new device,string,currentdevice
	;
	set:$get(%args(2))="" %args(2)="/bin/sh"
	;
	set currentdevice=$io
	set device="runshellcommmandpipe"_$job
	set return=""
	;
	open device:(shell=%args(2):command=%args(1):readonly:exception="goto execOpenError^%mindNSprocess"):5:"pipe"
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
    ;
    ;
; ************************************************************
; showLocks
; ************************************************************
; parameters:
;
; Returns:
; <RESP3 MAP>
;
; ************************************************************
showLocks
    new buffer,locks,ix,lock
    ;
    zshow "L":locks
    ;
    set ix=0 for  set ix=$order(locks("L",ix)) quit:ix=""  do
    . set lock=locks("L",ix)
    . set buffer($zpiece(lock," ",2))=$zpiece($zpiece(lock," ",3),"=",2)
    ;
    do buildMap^%mindRESP3(.buffer)
    set %res=buffer
    ;
    quit
    ;
    ;
; ************************************************************
; removeAllLocks
; ************************************************************
; parameters:
;
; Returns:
; <RESP3 MAP>
;
; ************************************************************
removeAllLocks
    lock
    ;
    set %res="+ok"_CRLF
    ;
    quit
    ;
    ;
; ************************************************************
; commitLocks
; ************************************************************
; parameters:
; 1 lock array LF separated
;
; Returns:
; <RESP3 MAP>
;
; ************************************************************
commitLocks
    if $get(%args(2),0)<0 set %res="-timeout can not be negative" quit
    ;
    new locks,cmd,ix,level
    new $etrap
    set $etrap="zgoto level:commitLocksTimeout"
    set level=$zlevel
    ;
    set *locks=$$SPLIT^%MPIECE(%args(1),",")
    ;
    set cmd="lock +("
    set ix="" for  set ix=$order(locks(ix)) quit:ix=""  set:locks(ix)'="" cmd=cmd_locks(ix)_","
    set cmd=$zextract(cmd,1,$zlength(cmd)-1)_")"
    set timeout=0
    set:%args(2)>0 cmd=cmd_":"_%args(2)_" set:$test=0 $ecode=""888"""
    ;
    xecute cmd
    ;
    set %res="+ok"_CRLF
    ;
    quit
    ;
commitLocksTimeout
    set %res="-timeout elapsed"
    ;
    quit
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
    if $zsyslog(%args(1))
    ;
    set %res="+ok"_CRLF
    ;
    quit
    ;
    ;
