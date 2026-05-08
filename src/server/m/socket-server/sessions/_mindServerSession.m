;#################################################################
;#                                                               #
;# Copyright (c) 2025-2026 DnaSoft B.V. and/or its subsidiaries. #
;# All rights reserved.                                          #
;#                                                               #
;#   This source code contains the intellectual property         #
;#   of its copyright holder(s), and is made available           #
;#   under a license.  If you do not know the terms of           #
;#   the license, please stop and do not read further.           #
;#                                                               #
;#################################################################
;
; Portions of this code have the following copyright:
; Copyright (c) 2024 YottaDB LLC and/or its subsidiaries.
; All rights reserved.
;
start ;
	new %mindTcp,tcpBuffer
	new %mindArgs,packet
	new devtmp,i,params,%mindRemoteIp
	new timerH,%mindSessionId,ix
	new %commandTerminator
	new %mindLevel,dummy,ret,loggedIn,dsm1,l
	new %timingStart,%timingEnd,%duration
	new %mindGUID
	new %mindAppName
	;
	; init main error handler
	new $etrap
	set $etrap="goto mainErrorHandler^%mindServerSession"
	set %mindLevel=$zlevel
	set loggedIn=0
	;
	set %mindCRLF=$zchar(13,10),LF=$zchar(10)
	set %commandTerminator=$zchar(3)_%mindCRLF_$zchar(3)_%mindCRLF
	set %mindTcp=$principal ; TCP Device
	set %mindSessionId="S-"_$job
    set %mindGUID=$zyhash($zut,$zut),%mindGUID="f"_$zextract(%mindGUID,3,$zlength(%mindGUID)-1)
	for ix=1:1:10-$zlength(%mindSessionId) set %mindSessionId=%mindSessionId_" "
	;
	; initialize the uApi global variables
	new uApi1,uApi2,uApi3,uApi4,uApi5,uApi6,uApi7,uApi8,uApi9,uApi10
	set uApi1="%mindVal1",uApi2="%mindVal2",uApi3="%mindVal3",uApi4="%mindVal4",uApi5="%mindVal5",uApi6="%mindVal6",uApi7="%mindVal7",uApi8="%mindVal8",uApi9="%mindVal9",uApi10="%mindVal10"
	;
	; ----------------------
	; set up the terminal for messages dumping
	; ----------------------
	open %mindParams("zio")
	;
	; ----------------------
	; open log file if needed
	; ----------------------
	new %mindRet
    if %mindParams("logFile")'="" do
    . if %mindParams("logLevel")=%mindLogNONE set %mindParams("logDevice")="" quit
    . set %mindRet=$$openFile^%mindLogger(%mindParams("logDevice"))
    . if %mindRet=0 set %mindParams("logDevice")=""
    ;
	; ----------------------
	; create a new session node (to be filled by the handshaking)
	; ----------------------
	; extract the remoteIp #
	zshow "d":devtmp
	for i=0:0 set i=$order(devtmp("D",i)) quit:'i  set:devtmp("D",i)["REMOTE" %mindRemoteIp=$zpiece($zpiece(devtmp("D",i),"REMOTE=",2),"@")
	set %mindRemoteIp=$piece(%mindRemoteIp,":",4)
	;
	; populate the session node
	set params("type")="S",params("description")="Socket clientId "_$job,params("ipNumber")=%mindRemoteIp
	do add^%mindSessions(.params)
	;
	; ----------------------
	; log dump
	; ----------------------
	do:%mindParams("logLevel")>=%mindLogSESSIONS log^%mindLogger(%mindTrm("cyan")_"CONNECT"_%mindTrm("white")_": Remote ip: "_%mindRemoteIp_" using PID: "_$job)
	;
	; ----------------------
	; TLS
	; ----------------------
	if %mindParams("useTls") do
    . view "SETENV":"ydb_crypt_config":"/opt/yottadb/current/plugin/etc/mind/mind.ydbcrypt"
	. write /tls("server",1,"mind")
    . if $piece($device,",",1) do log^%mindLogger(%mindTrm("red")_"TLS ERROR: "_$piece($device,",",2,99)) do errorHandler(1)
    ;
	; ----------------------
	; get the app name as first messages
	; ----------------------
	use %mindTcp:(chset="M":delim=$zchar(10):znodelay:morereadtime=1)
	read %mindAppName:3
	set %mindAppName=$zpiece(%mindAppName,":",2)
    ;
    do log^%mindLogger("%mindAppName:",%mindAppName)
	; -------------------------------
	; add user API dir in $zroutine
	; and eventually the "code" dir or .so in the selected app
	; -------------------------------
	;set $piece(%mindParams("userApiDir"),"/",1)="$gtm_dist"
	;do log^%mindLogger(%mindParams("userApiDir"))
    ;
    if %mindAppName'="",$data(%mindParams("uApiServer","code",%mindAppName)) set $zroutines=%mindParams("userApiDir")_" "_%mindParams("uApiServer","code",%mindAppName)_" "_$zroutines
    else  set $zroutines=%mindParams("userApiDir")_" "_$zroutines
    ;
	; ----------------------
	; initialize the uApi global variables
	; ----------------------
	new uApi1,uApi2,uApi3,uApi4,uApi5,uApi6,uApi7,uApi8,uApi9,uApi10
	;
	; set default values
	set uApi1="%mindVal1",uApi2="%mindVal2",uApi3="%mindVal3",uApi4="%mindVal4",uApi5="%mindVal5",uApi6="%mindVal6",uApi7="%mindVal7",uApi8="%mindVal8",uApi9="%mindVal9",uApi10="%mindVal10"
	;
	; and override them if app is present and has vars set
	if %mindAppName'="",$data(%mindParams("uApiServer","vars",%mindAppName)) do
	. new iy,cnt
	. set iy="",cnt=0 for  set iy=$order(%mindParams("uApiServer","vars",%mindAppName,iy)) quit:iy=""  do
	. . set cnt=cnt+1
	. . set varName="uApi"_cnt
	. . set @varName=%mindParams("uApiServer","vars",%mindAppName,iy)
    ;
	new @uApi1,@uApi2,@uApi3,@uApi4,@uApi5,@uApi6,@uApi7,@uApi8,@uApi9,@uApi10
	;
	; ----------------------
	; set up socket characteristics
	; ----------------------
	use %mindTcp:(chset="M":nodelim:znodelay:morereadtime=1)
	;
	new startIndex,endIndex,maxIndex,nTuples,tuple,valueLen,xiderBulk,xiderBulkReq,res,execError
	;
getCommands
	set (maxIndex,xiderBulk)=0,(tcpBuffer,xiderBulkReq,res)=""
	for  do
	. ; Get next command
	. set startIndex=1
	. ; Read until we see at least one delimiter (i.e. $C(13,10)). This will give us the number of tuples that follow. ;
	. for  set endIndex=$zfind(tcpBuffer,%mindCRLF,startIndex) quit:endIndex  do readpacket(.tcpBuffer,.maxIndex)
	. set nTuples=$zextract(tcpBuffer,startIndex+1,endIndex-3)
	. for tuple=0:1:nTuples-1 do
	. . ; Each tuple is a set of <length> and <value> pairs each of which is delimiter (i.e. $C(13,10)) terminated
	. . ; Read <length> which is delimiter terminated
	. . set startIndex=endIndex
	. . for  set endIndex=$zfind(tcpBuffer,%mindCRLF,startIndex) quit:endIndex  do readpacket(.tcpBuffer,.maxIndex)
	. . set valueLen=$zextract(tcpBuffer,startIndex+1,endIndex-3)
	. . ; Read <value> which is of length <valueLen>
	. . for  quit:maxIndex>=(endIndex+valueLen)  do readpacket(.tcpBuffer,.maxIndex)
	. . set %mindArgs(tuple)=$zextract(tcpBuffer,endIndex,endIndex+valueLen-1)
	. . set endIndex=endIndex+valueLen+2 ; +2 to skip past %mindCRLF delimiter
	. do parser ; invoke the parser
	. set tcpBuffer=$zextract(tcpBuffer,endIndex,maxIndex),maxIndex=maxIndex-endIndex+1
	. ;
	;
readpacket(tcpBuffer,maxIndex)
	new packet
	;
	for  read packet goto errorHandler:$zeof quit:$zlength(packet)
	;
	set tcpBuffer=tcpBuffer_packet
	set maxIndex=maxIndex+$zlength(packet)
	quit
	;
parser ;
    new %mindRes
	new %label,%routine
	new credentials,paramsNode,cnt,JERR
	;
	; Expects "nTuples" and "%mindArgs(n)" to be set by caller
	;
	; clear the response
	set %mindRes=""
	;
	; --------------------------------
	; Prepare data and detect uAPI
	; --------------------------------
	do:%mindParams("logLevel")>=%mindLogCOMMANDS log^%mindLogger(%mindTrm("green")_"COMMAND RECEIVED: "_%mindTrm("white")_%mindArgs(0))
	; dump if needed
	do:%mindParams("dumpRequest")
	. if %mindArgs(0)="server.login" set credentials=%mindArgs(1),%mindArgs(1)=$piece(%mindArgs(1),":",1)_":*******"
	. for x=0:1:nTuples-1 do log^%mindLogger(x_"- "_%mindArgs(x))
	. ;display only the user name, no password on log
	. if %mindArgs(0)="server.login" set %mindArgs(1)=credentials
	;
	; --------------------------------
	; ensure user is logged in
	; --------------------------------
	set:%mindArgs(0)="server.login" loggedIn=1
	if loggedIn=0,%mindArgs(0)'="server.login" set %mindRes="-Not logged in" goto parserQuit
	;
	; --------------------------------
	; Extract label and routine
	; --------------------------------
	; extract the command and set the argument count in command for the API
	set %mindArgs=nTuples
    if $data(%mindParams("uApi",$zpiece(%mindArgs(0),".",1,$zlength(%mindArgs(0),".")))) do uApiExecute^%mindNSuapi goto parserQuit
    else  do
	. set %mindArgs(-1)=$zpiece(%mindArgs(0),".",1),%mindArgs(-2)=$zpiece(%mindArgs(0),".",2)
	. set %mindArgs(-1)="%mindNS"_%mindArgs(-1)
	;
	; --------------------------------
	; Not supported or unknown command
	; --------------------------------
	if %mindArgs(-2)=""!($text(@%mindArgs(-2)^@%mindArgs(-1))="") do  goto parserQuit
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
    . set:%mindParams("logLevel")>=%mindLogTIMINGS %timingStart=$zut
    . ;
    . new (%mindAppName,%mindGUID,%mindSessionId,%mindArgs,%mindRes,%mindParams,%mindTcp,%mindCRLF,LF,%mindRemoteIp,%mindVersion,%mindLevel,%mindTrm,%mindLogNONE,%mindLogSESSIONS,%mindLogCOMMANDS,%mindLogTIMINGS,@uApi1,@uApi2,@uApi3,@uApi4,@uApi5,@uApi6,@uApi7,@uApi8,@uApi9,@uApi10)
	. do @%mindArgs(-2)^@%mindArgs(-1)
	;
parserQuit
	write %mindRes,%commandTerminator,!
    ;
    ; timings if needed
    set:%mindParams("logLevel")>=%mindLogTIMINGS %timingEnd=$zut,%duration=%timingEnd-%timingStart
    ;
	do:%mindParams("dumpResponse") log^%mindLogger(%mindTrm("yellow")_"RESPONSE: "_%mindTrm("white")_LF_$zwrite(%mindRes))
    ;
    set execError=$zextract(%mindRes,1,1)="-"!($extract(%mindRes,1,1)="!")
    set:$zextract(%mindRes,1,2)="--" execError=-1
    ;
    ; stats
	set:%mindParams("stats") ret=$increment(^%mindSessions("stats","_grand",$select(execError=0:"ok",execError=1:"nok",1:"invalid_cmd"))),ret=$increment(%mindParams("lstats","_grand",$select(execError=0:"ok",execError=1:"nok",1:"invalid_cmd")))
    set:%mindParams("stats")=2 ret=$increment(^%mindSessions("stats",%mindArgs(0),$select(execError=0:"ok",execError=1:"nok",1:"invalid_cmd"))),ret=$increment(%mindParams("lstats",%mindArgs(0),$select(execError=0:"ok",execError=1:"nok",1:"invalid_cmd")))
    ;
	do:%mindParams("logLevel")>=%mindLogCOMMANDS log^%mindLogger($select(execError=0:%mindTrm("light_green")_"COMMAND EXECUTED"_%mindTrm("white"),execError=-1:%mindTrm("light_red")_"M CODE NOT FOUND"_%mindTrm("white"),1:%mindTrm("red")_"COMMAND FAILED"_%mindTrm("white"))_": "_%mindArgs(0))
    do:%mindParams("logLevel")>=%mindLogTIMINGS log^%mindLogger(%mindTrm("yellow")_"in "_%duration_" us")
	;
	; get ready for next command
	kill %mindArgs,%mindRes
	;
	quit
	;
	;
mainErrorHandler ;
	use %mindParams("zio")
	;
	; log the error on console / file
	do log^%mindLogger(%mindTrm("red")_"COMMAND FAILED: "_%mindArgs(0))
	if %mindParams("errorDump")=1 do log^%mindLogger(%mindTrm("red")_"INT. ERROR: "_$zstatus)
	if %mindParams("errorDump")=2 do
	. do log^%mindLogger(%mindTrm("red")_"**********************************")
	. do log^%mindLogger(%mindTrm("red")_"*** An internal error occurred ***")
	. do log^%mindLogger(%mindTrm("red")_"**********************************")
	. do log^%mindLogger(%mindTrm("red")_"PID "_$job)
	. do log^%mindLogger(%mindTrm("red")_"Location:     "_$zpiece($zstatus,",",2))
	. do log^%mindLogger(%mindTrm("red")_"Error code:   "_$zpiece($zstatus,",",1))
	. do log^%mindLogger(%mindTrm("red")_"Mnemonic:     "_$zpiece($zstatus,",",3))
	. do log^%mindLogger(%mindTrm("red")_"Description: "_$zextract($zstatus,$zfind($zstatus,$zpiece($zstatus,",",3))+1,2048))
	. ;
	. set dsm1=$stack(-1)-1
	. do log^%mindLogger(%mindTrm("red")_"STACK:"_dsm1)
	. for l=dsm1:-1:0 do
	. . do log^%mindLogger(%mindTrm("red")_"  "_l)
	. . do log^%mindLogger(%mindTrm("red")_"  ecode: "_$stack(l,"ecode"))
	. . do log^%mindLogger(%mindTrm("red")_"  place: "_$stack(l,"place"))
	. . do log^%mindLogger(%mindTrm("red")_"  mcode: "_$stack(l,"mcode"))
	;
	; log the error on syslog
	set dummy=$ZSYSLOG("Fatal: "_$zstatus)
	;
	; execute onError() hooks if present
	if $get(%mindAppName)'="",$get(%mindParams("uApiServer","hooks",%mindAppName,"onError"))'="" do
	. do @%mindParams("uApiServer","hooks",%mindAppName,"onError"),log^%mindLogger("onError(): "_%mindParams("uApiServer","hooks",%mindAppName,"onError")_" executed.")
	;
	; send error to client
	use %mindTcp
	set %mindRes="-Internal error: "_$zstatus_%mindCRLF
	write %mindRes,$zchar(3)_%mindCRLF_$zchar(3)_%mindCRLF,!
    ;
    ; update stats if needed
	set:%mindParams("stats") ret=$increment(^%mindSessions("stats","_grand","nok")),ret=$increment(%mindSessions("lstats","_grand","nok"))
    set:%mindParams("stats")=2 ret=$increment(^%mindSessions("stats",%mindArgs(0),"nok")),ret=$increment(%mindSessions("lstats",%mindArgs(0),"nok"))
    ;
	; get ready for next command
	kill %mindArgs,%mindRes
    ;
    ; jump back to beginning and restore the correct stack level
	zgoto %mindLevel:getCommands^%mindServerSession

	;
	;
errorHandler(exitCode) ;
	; session termination
	;
	set exitCode=$get(exitCode,0)
	;
	; do logging
	do log^%mindLogger(%mindTrm("cyan")_"DISCONNECT: "_%mindTrm("white")_$select('exitCode:"Remote ip: "_%mindRemoteIp_" disconnected",1:"Session terminated due to error"))
	;
	; clean up session
	do delete^%mindSessions()
	;
	write !,$zstatus
	;
	zhalt exitCode
	;
	;
