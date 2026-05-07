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
;----------------------------------------------
; log(message,level)
;
; message	A stringto be dumped
; level		The log level to display the message. A value of 0 (none) to 3 (responses)
; 			or use the contants: %mindLogNONE,%mindLogSESSIONS,%mindLogCOMMANDS,%mindLogTIMINGS
;
; Note: it will automatically switch and restore the device
;
;----------------------------------------------
log(message,level)
    quit:%mindParams("logDevice")=""
    set level=$get(level)
    if level'="",level>%mindParams("logLevel") quit
    ;
	new io,zh
	;
	set zh=$zhorolog,io=$zio
	;
	; use current log device
	use %mindParams("logDevice")
	;
	write %mindTrm("white"),%mindTrm("bgnd_black")
	write $select($get(%mindSessionId)="":"SERVER    ",1:%mindSessionId)_"   "_$zdate(zh,"YYYY-MM-DD 24:60:SS."),$translate($justify($zpiece(zh,",",3)\1000,3)," ","0")," ",message,!
	;
	; restores the io
	use io
	;
	quit
	;
	;
initialize	
	set %mindLogNONE=0,%mindLogSESSIONS=1,%mindLogCOMMANDS=2,%mindLogTIMINGS=3
	set %mindParams("logLevels")=",none,sessions,commands,timings,"
	set %mindParams("logLevels","none")=""
	set %mindParams("logLevels","sessions")=""
	set %mindParams("logLevels","commands")=""
	set %mindParams("logLevels","timings")=""
	;
	quit
	;
	;
convertLevel(level)
	new levels,ix,levelNum
	;
	set levelNum=-1
	set *levels=$$SPLIT^%MPIECE(%mindParams("logLevels"),",")
	set ix="" for  set ix=$order(levels(ix)) quit:ix=""  if level=levels(ix) set levelNum=ix-1 quit
	;	
	quit levelNum
	;
	;
convertLevelNumber(levelNumber)
	new levels
	;
	set *levels=$$SPLIT^%MPIECE(%mindParams("logLevels"),",")
    ;
    quit levels(levelNumber+1)
	;
	;
openFile(filename)
    open filename:(APPEND:exception="quit 0")
    quit 1
    ;
    ;