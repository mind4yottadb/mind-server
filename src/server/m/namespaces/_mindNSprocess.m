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
cwdGet

    set %mindRes="+"_$zdirectory_CRLF,%mindRes("status")=1
    ;
    quit
    ;
    ;
; ************************************************************
; cwdSet
; ************************************************************
cwdSet
    if $get(command(2))="" set %mindRes="-the path has not been provided"_CRLF,%mindRes("status")=0 quit
    if $zsearch(command(2))="" set %mindRes="-the provided path does not exists or it is not accessible"_CRLF,%mindRes("status")=0 quit
    ;
    set $zdirectory=command(2)
    set %mindRes="+ok"
    set %mindRes("status")=1
    ;
    quit
    ;
    ;
; ************************************************************
; spawn(command,stdoutlog)
; ************************************************************
spawn
    if $get(command(2))="" set %mindRes="-the command has not been provided"_CRLF,%mindRes("status")=0 quit
    ;
    new currentDevice,PID,device
    ;
    set command(3)=$get(command(3))
    set currentDevice=$zio
	set device="spawn-"_$job
    ;
    ; build command string
    set command=command(2)_$select(command(3)="":"",-1:" > "_command(3))
    ;
	open device:(shell="/bin/sh":command=command:readonly:independent:exception="goto spawnOpenError^%mindNSprocess")::"pipe"
	use device
	set PID=$key
	close device
	;
	use currentDevice
    ;
    set %mindRes="+"_PID_CRLF,%mindRes("status")=1 quit
    ;
    quit
    ;
spawnOpenError
    set %mindRes="-the command returned the following error:"_$zstatus_CRLF,%mindRes("status")=0 quit
    quit
    ;
    ;
; ************************************************************
; exec(command,shell)
; ************************************************************
exec
	; The shell parameter is used to use an alternative shell (like bash)
    if $get(command(2))="" set %mindRes="-the command has not been provided"_CRLF,%mindRes("status")=0 quit
    ;
	new device,string,currentdevice
	;
	set:command(3)="" command(3)="/bin/sh"
	;
	set currentdevice=$io
	set device="runshellcommmandpipe"_$job
	set return=""
	;
	open device:(shell=command(3):command=command(2):readonly:exception="goto execOpenError^%mindNSprocess"):5:"pipe"
	use device
	for  quit:$zeof=1  read string set return=return_string_LF
terminateRead
	close device ;if $get(return(counter))="" kill return(counter)
	;
	use currentdevice
	;
	if $zclose'=0 set %mindRes="-the command returned error: "_$zclose_" "_return_CRLF,%mindRes("status")=0 quit
	;
	set %mindRes=$$RESP3getBlob^%mindUtils(return),%mindRes("status")=1
    ;
	quit
	;
execOpenError
    if $piece($zstatus,",",1)=150373082 goto terminateRead
    set %mindRes="-the command returned error: "_$zpiece($zstatus,",")_","_$zpiece($zstatus,",",4,99)_CRLF,%mindRes("status")=0
    ;
    quit
	;
	;
; ************************************************************
; unixtime
; ************************************************************
unixtime
    set %mindRes=":"_$zut_CRLF,%mindRes("status")=1
    ;
    quit
    ;
    ;
; ************************************************************
; datetime
; ************************************************************
datetime
    new sec,min,hour,mday,mon,year,wday,yday,isdst,tzone
    new unixtime,cnt,ix,buffer
    ;
    set unixtime=$zut\1000000
    do &ydbposix.localtime(unixtime,.sec,.min,.hour,.mday,.mon,.year,.wday,.yday,.isdst,.err)
    ;
    if +$get(err)>0 set %mindRes="-the command returned the internal error: "_err_CRLF,%mindRes("status")=0 quit
    ;
    set buffer("second")=sec
    set buffer("minute")=min
    set buffer("hour")=hour
    ;
    set buffer("dayOfMonth")=mday
    set buffer("month")=mon+1
    set buffer("year")=year#100
    ;
    set buffer("dayOfWeek")=wday+1
    set buffer("dayOfYear")=yday+1
    set buffer("daylightSaving")=isdst
    set buffer("timezone")=$zpiece($zhorolog,",",4)

    set cnt=0,ix="" for  set ix=$order(buffer(ix)) quit:ix=""  do
    . set %mindRes=%mindRes_"+"_ix_CRLF_"+"_buffer(ix)_CRLF
    . set cnt=cnt+1
	;
    set %mindRes="%"_cnt_CRLF_%mindRes,%mindRes("status")=1
    ;
    quit
    ;
    ;