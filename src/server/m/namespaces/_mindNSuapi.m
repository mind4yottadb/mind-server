;#################################################################
;#                                                               #
;# Copyright (c) 2026 DnaSoft B.V. and/or its subsidiaries.      #
;# All rights reserved.                                          #
;#                                                               #
;#   This source code contains the intellectual property         #
;#   of its copyright holder(s), and is made available           #
;#   under a license.  If you do not know the terms of           #
;#   the license, please stop and do not read further.           #
;#                                                               #
;#################################################################
;
uApiExecute
    ; uAPI !!!
    set x=%mindParams("uApi",%args(0))
    set %args(-1)=$piece(x,"^",2),%args(-2)=$piece(x,"^",1)
    ; now parameters
    if $data(%mindParams("uApi",$zpiece(%args(0),".",1,$zlength(%args(0),".")),"parameters")) do
    . set ix="",cnt=0 for  set ix=$order(%mindParams("uApi",$zpiece(%args(0),".",1,$zlength(%args(0),".")),"parameters",ix)) quit:ix=""  do
    . . set paramsNode=$name(%mindParams("uApi",$zpiece(%args(0),".",1,$zlength(%args(0),".")),"parameters",ix))
    . . set cnt=cnt+1
    . . if @paramsNode@("datatype")="object" do  quit
    . . . ; parse json to JDOM
    . . . do parse^%mindJSON($name(%args(cnt)),$name(%args(@paramsNode@("name"))),"JERR")
    . . . if $data(JERR) do log^%mindLogger("JSON ERROR")
    . . . ;
    . . if @paramsNode@("datatype")="string" set %args(@paramsNode@("name"))=%args(cnt)
    . . else  set %args(@paramsNode@("name"))=+%args(cnt)


	; --------------------------------
	; Not supported or unknown command
	; --------------------------------
	if %args(-2)=""!($text(@%args(-2)^@%args(-1))="") do  goto uApiExecuteQuit
	. set %res="--M code not found"_CRLF
	;


	; --------------------------------
	; Command dispatcher
	; --------------------------------
	do
	. ; stats first
	. set:%mindParams("stats") ret=$increment(^%mindSessions("stats","_grand","rec")),ret=$increment(%mindParams("lstats","_grand","rec"))
    . set:%mindParams("stats")=2 ret=$increment(^%mindSessions("stats",%args(0),"rec")),ret=$increment(%mindParams("lstats",%args(0),"rec"))
    . ;
    . ; timings if needed
    . set:%mindParams("logLevel")>=%logTIMINGS %timingStart=$zut
    . ;
    . new (%mindSessionId,%args,%res,%mindParams,%ydbtcp,CRLF,LF,%remoteIp,%mindVersion,%level,%trm,%logNONE,%logSESSIONS,%logCOMMANDS,%logTIMINGS,@uApi1,@uApi2,@uApi3,@uApi4,@uApi5,@uApi6,@uApi7,@uApi8,@uApi9,@uApi10)
	. do @%args(-2)^@%args(-1)
	;
uApiExecuteQuit
    quit
    ;
    ;