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
    set %args(-1)=$piece(x,"^",2),%args(-2)=$piece(x,"^",1),%args("cmd")=x
    ;
    ; now parameters
    if $data(%mindParams("uApi",$zpiece(%args(0),".",1,$zlength(%args(0),".")),"parameters")) do
    . set %args("cmd")=%args("cmd")_"("
    . set ix="",cnt=0 for  set ix=$order(%mindParams("uApi",$zpiece(%args(0),".",1,$zlength(%args(0),".")),"parameters",ix)) quit:ix=""  do
    . . set paramsNode=$name(%mindParams("uApi",$zpiece(%args(0),".",1,$zlength(%args(0),".")),"parameters",ix))
    . . set cnt=cnt+1
    . . if %args(cnt)="___" set %args("cmd")=%args("cmd")_"," quit
    . . if @paramsNode@("datatype")="object"!(@paramsNode@("datatype")="json") do  quit
    . . . do parse^%mindJSON($name(%args(cnt)),$name(%args(@paramsNode@("name"))),"JERR")
    . . . if $data(JERR) do returnErrorString^%mindRESP3("error parsing json: "_$get(JERR(1))_" "_$get(JERR(2))) goto uApiExecuteQuit
    . . . set %args("cmd")=%args("cmd")_"""%args("""""_@paramsNode@("name")_""""")"","
    . . if @paramsNode@("datatype")="varByRef" do  quit
    . . . set %args("cmd")=%args("cmd")_"."_%args(cnt)_","
    . . set %args("cmd")=%args("cmd")_$select(@paramsNode@("datatype")="string":"",1:"+")_"%args("_cnt_"),"
    . set %args("cmd")=$zextract(%args("cmd"),1,$length(%args("cmd"))-1)
    . set %args("cmd")=%args("cmd")_")"
    ;
	; --------------------------------
	; Not supported or unknown command
	; --------------------------------
	if %args(-2)=""!($text(@%args(-2)^@%args(-1))="") do  goto uApiExecuteQuit
	. set %res="-M code not found"_CRLF
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
    . new (%mindSessionId,%args,%res,%mindParams,%mindTcp,CRLF,LF,%remoteIp,%mindVersion,%level,%trm,%logNONE,%logSESSIONS,%logCOMMANDS,%logTIMINGS,@uApi1,@uApi2,@uApi3,@uApi4,@uApi5,@uApi6,@uApi7,@uApi8,@uApi9,@uApi10)
    . new %returns,%ret
    . set %returns=%mindParams("uApi",$zpiece(%args(0),".",1,$zlength(%args(0),".")),"returns")
    . if %returns="" xecute "do "_%args("cmd") do returnVoid^%mindRESP3() quit
    . else  do
    . . if %returns="object"!(%returns="json") do
    . . . xecute "set *%ret=$$"_%args("cmd")
    . . . do:%res="" returnObject^%mindRESP3(.%ret)
    . . . quit
    . . else  do
    . . . xecute "set %ret=$$"_%args("cmd")
    . . . do:%res=""
    . . . . if %returns="string" do returnString^%mindRESP3(%ret) quit
    . . . . if %returns="int" do returnInt^%mindRESP3(+%ret) quit
    . . . . if %returns="float" do returnFloat^%mindRESP3(+%ret) quit
    . . . . if %returns="boolean" do returnBoolean^%mindRESP3(+%ret) quit
    . . . . if %returns="null" do returnNull^%mindRESP3()
	;
uApiExecuteQuit
    quit
    ;
    ;