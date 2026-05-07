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
    set x=%mindParams("uApi",%mindArgs(0))
    set %mindArgs(-1)=$piece(x,"^",2),%mindArgs(-2)=$piece(x,"^",1),%mindArgs("cmd")=x
    ;
    ; now parameters
    if $data(%mindParams("uApi",$zpiece(%mindArgs(0),".",1,$zlength(%mindArgs(0),".")),"parameters")) do
    . set %mindArgs("cmd")=%mindArgs("cmd")_"("
    . set ix="",cnt=0 for  set ix=$order(%mindParams("uApi",$zpiece(%mindArgs(0),".",1,$zlength(%mindArgs(0),".")),"parameters",ix)) quit:ix=""  do
    . . set paramsNode=$name(%mindParams("uApi",$zpiece(%mindArgs(0),".",1,$zlength(%mindArgs(0),".")),"parameters",ix))
    . . set cnt=cnt+1
    . . if %mindArgs(cnt)="___" set %mindArgs("cmd")=%mindArgs("cmd")_"," quit
    . . if @paramsNode@("datatype")="object"!(@paramsNode@("datatype")="json") do  quit
    . . . do parse^%mindJSON($name(%mindArgs(cnt)),$name(%mindArgs(@paramsNode@("name"))),"JERR")
    . . . if $data(JERR) do returnErrorString^%mindRESP3("error parsing json: "_$get(JERR(1))_" "_$get(JERR(2))) goto uApiExecuteQuit
    . . . set %mindArgs("cmd")=%mindArgs("cmd")_"""%mindArgs("""""_@paramsNode@("name")_""""")"","
    . . if @paramsNode@("datatype")="varByRef" do  quit
    . . . set %mindArgs("cmd")=%mindArgs("cmd")_"."_%mindArgs(cnt)_","
    . . set %mindArgs("cmd")=%mindArgs("cmd")_$select(@paramsNode@("datatype")="string":"",1:"+")_"%mindArgs("_cnt_"),"
    . set %mindArgs("cmd")=$zextract(%mindArgs("cmd"),1,$length(%mindArgs("cmd"))-1)
    . set %mindArgs("cmd")=%mindArgs("cmd")_")"
    ;
	; --------------------------------
	; Not supported or unknown command
	; --------------------------------
	if %mindArgs(-2)=""!($text(@%mindArgs(-2)^@%mindArgs(-1))="") do  goto uApiExecuteQuit
	. set %mindRes="-M code not found"_%mindCRLF
	;
	; --------------------------------
	; Command dispatcher
	; --------------------------------
	do
	. ; stats first
	. set:%mindParams("stats") ret=$increment(^%mindSessions("stats","_grand","rec")),ret=$increment(%mindParams("lstats","_grand","rec"))
    . set:%mindParams("stats")=2 ret=$increment(^%mindSessions("stats",%mindArgs(0),"rec")),ret=$increment(%mindParams("lstats",%mindArgs(0),"rec"))
    . ;
    . ; timings if needed
    . set:%mindParams("logLevel")>=%logTIMINGS %timingStart=$zut
    . ;
    . new (%mindSessionId,%mindArgs,%mindRes,%mindParams,%mindTcp,%mindCRLF,LF,%mindRemoteIp,%mindVersion,%mindLevel,%trm,%logNONE,%logSESSIONS,%logCOMMANDS,%logTIMINGS,@uApi1,@uApi2,@uApi3,@uApi4,@uApi5,@uApi6,@uApi7,@uApi8,@uApi9,@uApi10)
    . new %returns,%ret
    . set %returns=%mindParams("uApi",$zpiece(%mindArgs(0),".",1,$zlength(%mindArgs(0),".")),"returns")
    . if %returns="" xecute "do "_%mindArgs("cmd") do returnVoid^%mindRESP3() quit
    . else  do
    . . if %returns="object"!(%returns="json") do
    . . . xecute "set *%ret=$$"_%mindArgs("cmd")
    . . . do:%mindRes="" returnObject^%mindRESP3(.%ret)
    . . . quit
    . . else  do
    . . . xecute "set %ret=$$"_%mindArgs("cmd")
    . . . do:%mindRes=""
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