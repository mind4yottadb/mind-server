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
; 			or use the contants: %logNONE,%logSESSIONS,%logCOMMANDS,%logTIMINGS
;
; Note: it will automatically switch and restore the device
;
;----------------------------------------------
log(message,level)
    set level=$get(level)
    if level'="",level>%mindParams("logLevel") quit
    ;
	new io,zh
	;
	set zh=$zhorolog,io=$zio
	;
	; use current log device
    ; and open it if it is a file
	use %mindParams("logDevice")
	;
	write %trm("white"),%trm("bgnd_black")
	write $select($get(%mindSessionId)="":"SERVER    ",1:%mindSessionId)_"   "_$zdate(zh,"YYYY-MM-DD 24:60:SS."),$translate($justify($zpiece(zh,",",3)\1000,3)," ","0")," ",message,!
	;
	; restores the io
	use io
	;
	quit
	;
	;
initialize	
	set %logNONE=0,%logSESSIONS=1,%logCOMMANDS=2,%logTIMINGS=3
	set %mindParams("logLevels")="none,sessions,commands,timings"
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
testFile(filename)
    open filename:(APPEND:exception="quit 0")
    quit 1
