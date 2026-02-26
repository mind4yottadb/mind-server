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
    new x,cmd,ix,cnt,paramsNode,params
    ;
    set x=%mindParams("uApi",%args(0))
    set %args(-1)=$piece(x,"^",2),%args(-2)=$piece(x,"^",1),cmd=x
    ;
    ; now parameters
    if $data(%mindParams("uApi",$zpiece(%args(0),".",1,$zlength(%args(0),".")),"parameters")) do
    . set cmd=cmd_"("
    . set ix="",cnt=0 for  set ix=$order(%mindParams("uApi",$zpiece(%args(0),".",1,$zlength(%args(0),".")),"parameters",ix)) quit:ix=""  do
    . . set paramsNode=$name(%mindParams("uApi",$zpiece(%args(0),".",1,$zlength(%args(0),".")),"parameters",ix))
    . . set cnt=cnt+1
    . . set cmd=cmd_"%args("_$select(@paramsNode@("datatype")="string":"",1:"+")_cnt_"),"
    . set cmd=$zextract(cmd,1,$length(cmd)-1)
    . set cmd=cmd_")"
    ;else  set cmd=cmd_"()"
    do log^%mindLogger("cmd is: "_cmd)
    ;
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
    . new (cmd,%mindSessionId,%args,%res,%mindParams,%ydbtcp,CRLF,LF,%remoteIp,%mindVersion,%level,%trm,%logNONE,%logSESSIONS,%logCOMMANDS,%logTIMINGS,@uApi1,@uApi2,@uApi3,@uApi4,@uApi5,@uApi6,@uApi7,@uApi8,@uApi9,@uApi10)
    . new %returns,%ret
    . set %returns=%mindParams("uApi",$zpiece(%args(0),".",1,$zlength(%args(0),".")),"returns")
    . if %returns="" xecute "do "_cmd do returnVoid^%mindRESP3()
    . else  do
    . . if %returns="object" do
    . . . xecute "set *%ret=$$"_cmd
    . . . do returnObject^%mindRESP3(.%ret)
    . . else  do
    . . . xecute "set %ret=$$"_cmd
    . . . do:%res=""
    . . . . do:%returns="string" returnString^%mindRESP3(%ret)
    . . . . do:%returns="int" returnInt^%mindRESP3(%ret)
    . . . . do:%returns="float" returnFloat^%mindRESP3(%ret)
    . . . . do:%returns="boolean" returnBoolean^%mindRESP3(%ret)
	;
uApiExecuteQuit
    quit
    ;
    ;