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
    set %mindRes="+"_$zdirectory_%mindCRLF
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
    if $get(%mindArgs(1))="" set %mindRes="-the path has not been provided"_%mindCRLF quit
    if $zsearch(%mindArgs(1))="" set %mindRes="-the provided path does not exists or it is not accessible"_%mindCRLF quit
    ;
    set $zdirectory=%mindArgs(1)
    set %mindRes="+ok"
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
    if $get(%mindArgs(1))="" set %mindRes="-the command has not been provided"_%mindCRLF quit
    ;
    new currentDevice,PID,device
    ;
    set %mindArgs(2)=$get(%mindArgs(2))
    set currentDevice=$zio
	set device="spawn-"_$job
    ;
    ; build command string
    set %mindArgs=%mindArgs(1)_$select(%mindArgs(2)="":"",-1:" > "_%mindArgs(2))
    ;
	open device:(shell="/bin/sh":command=%mindArgs:readonly:independent:exception="goto spawnOpenError^%mindNSprocess")::"pipe"
	use device
	set PID=$key
	close device
	;
	use currentDevice
    ;
    set %mindRes="+"_PID_%mindCRLF
    ;
    quit
    ;
spawnOpenError
    set %mindRes="-the command returned the following error:"_$zstatus_%mindCRLF
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
    if $get(%mindArgs(1))="" set %mindRes="-the command has not been provided"_%mindCRLF quit
    ;
	new device,string,currentdevice
	;
	set:$get(%mindArgs(2))="" %mindArgs(2)="/bin/sh"
	;
	set currentdevice=$io
	set device="runshellcommmandpipe"_$job
	set return=""
	;
	open device:(shell=%mindArgs(2):command=%mindArgs(1):readonly:exception="goto execOpenError^%mindNSprocess"):5:"pipe"
	use device
	for  quit:$zeof=1  read string set return=return_string_LF
terminateRead
	close device ;if $get(return(counter))="" kill return(counter)
	;
	use currentdevice
	;
	if $zclose'=0 set %mindRes="-the command returned error: "_$zclose_" "_return_%mindCRLF quit
	;
	set %mindRes=$$buildBlob^%mindRESP3(return)
    ;
	quit
	;
execOpenError
    if $piece($zstatus,",",1)=150373082 goto terminateRead
    set %mindRes="-the command returned error: "_$zpiece($zstatus,",")_","_$zpiece($zstatus,",",4,99)_%mindCRLF
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
    set %mindRes=buffer
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
	set %mindRes=%mindRes_"%"_($order(envVars(""),-1)-1)_%mindCRLF
	;
	for ix=1:1:$order(envVars(""),-1)-1  do
    . set %mindRes=%mindRes_"+"_$zpiece(envVars(ix),"=",1)_%mindCRLF
    . set %mindRes=%mindRes_"+"_$zpiece(envVars(ix),"=",2,99)_%mindCRLF
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
    . set buffer($zpiece(lock," ",2,$zlength(lock," ")-1))=+$zpiece(lock,"=",2)
    ;
    do buildMap^%mindRESP3(.buffer)
    set %mindRes=buffer
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
    set %mindRes="+ok"_%mindCRLF
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
    if $get(%mindArgs(2),0)<0 set %mindRes="-timeout can not be negative" quit
    ;
    new locks,cmd,ix,level
    new $etrap
    set $etrap="zgoto level:commitLocksTimeout"
    set level=$zlevel
    ;
    set *locks=$$SPLIT^%MPIECE(%mindArgs(1),",")
    ;
    set cmd="lock +("
    set ix="" for  set ix=$order(locks(ix)) quit:ix=""  set:locks(ix)'="" cmd=cmd_locks(ix)_","
    set cmd=$zextract(cmd,1,$zlength(cmd)-1)_")"
    set timeout=0
    set:%mindArgs(2)>0 cmd=cmd_":"_%mindArgs(2)_" set:$test=0 $ecode=""888"""
    ;
    xecute cmd
    ;
    set %mindRes="+ok"_%mindCRLF
    ;
    quit
    ;
commitLocksTimeout
    set %mindRes="-timeout elapsed"
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
    if $zsyslog(%mindArgs(1))
    ;
    set %mindRes="+ok"_%mindCRLF
    ;
    quit
    ;
    ;
