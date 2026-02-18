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
	new %ydbtcp,tcpBuffer
	new %args,packet
	new devtmp,i,params,%remoteIp
	new timerH,%mindSessionId,ix
	new %commandTerminator
	new %level,dummy,ret,loggedIn,dsm1,l
	new %timingStart,%timingEnd,%duration
	;
	; init main error handler
	new $etrap
	set $etrap="goto mainErrorHandler^%mindServerSession"
	set %level=$zlevel
	set loggedIn=0
	;
	set CRLF=$zchar(13,10),LF=$zchar(10)
	set %commandTerminator=$zchar(3)_CRLF_$zchar(3)_CRLF
	set %ydbtcp=$principal ; TCP Device
	set %mindSessionId="S-"_$job
	for ix=1:1:10-$zlength(%mindSessionId) set %mindSessionId=%mindSessionId_" "
	;
	; initialize the uApi global variables
	new uApi1,uApi2,uApi3,uApi4,uApi5,uApi6,uApi7,uApi8,uApi9,uApi10
	set uApi1="%val1",uApi2="%val2",uApi3="%val3",uApi4="%val4",uApi5="%val5",uApi6="%val6",uApi7="%val7",uApi8="%val8",uApi9="%val9",uApi10="%val10"
	;
	; ----------------------
	; set up the terminal for messages dumping
	; ----------------------
	open %mindParams("zio")
	;
	; ----------------------
	; open log file if needed
	; ----------------------
    if %mindParams("logFile")'="" open %mindParams("logDevice"):APPEND
    ;
	; -------------------------------
	; add user API dir in $zroutine
	; -------------------------------
    set $zroutine=%mindParams("userApiDir")_"* "_$zroutine
    ;
	; ----------------------
	; create a new session node (to be filled by the handshaking)
	; ----------------------
	; extract the remoteIp #
	zshow "d":devtmp
	for i=0:0 set i=$order(devtmp("D",i)) quit:'i  set:devtmp("D",i)["REMOTE" %remoteIp=$zpiece($zpiece(devtmp("D",i),"REMOTE=",2),"@")
	set %remoteIp=$piece(%remoteIp,":",4)
	;
	; populate the session node
	set params("type")="S",params("description")="Socket clientId "_$job,params("ipNumber")=%remoteIp
	do add^%mindSessions(.params)
	;
	;
	; ----------------------
	; log dump
	; ----------------------
	do:%mindParams("logLevel")>=%logSESSIONS log^%mindLogger(%trm("cyan")_"CONNECT"_%trm("white")_": Remote ip: "_%remoteIp_" using PID: "_$job)
	;
	write /tls("server",1,"mind")
    do log^%mindLogger($device)
    ;

	; ----------------------
	; get the app name as first messages
	; ----------------------
	new appName
	use %ydbtcp:(chset="M":delim=$zchar(10):znodelay:morereadtime=1)
	read appName:3
	set appName=$zpiece(appName,":",2)
    ;
	; ----------------------
	; initialize the uApi global variables
	; ----------------------
	new uApi1,uApi2,uApi3,uApi4,uApi5,uApi6,uApi7,uApi8,uApi9,uApi10
	;
	; set default values
	set uApi1="%val1",uApi2="%val2",uApi3="%val3",uApi4="%val4",uApi5="%val5",uApi6="%val6",uApi7="%val7",uApi8="%val8",uApi9="%val9",uApi10="%val10"
	;
	; and override them if app is present and has vars set
	if appName'="",$data(%mindParams("uApiServer","vars",appName)) do
	. new iy,cnt
	. set iy="",cnt=0 for  set iy=$order(%mindParams("uApiServer","vars",appName,iy)) quit:iy=""  do
	. . set cnt=cnt+1
	. . set varName="uApi"_cnt
	. . set @varName=%mindParams("uApiServer","vars",appName,iy)
    ;
	new @uApi1,@uApi2,@uApi3,@uApi4,@uApi5,@uApi6,@uApi7,@uApi8,@uApi9,@uApi10
	;
	; ----------------------
	; set up socket characteristics
	; ----------------------
	use %ydbtcp:(chset="M":nodelim:znodelay:morereadtime=1)
	;
	new startIndex,endIndex,maxIndex,nTuples,tuple,valueLen,xiderBulk,xiderBulkReq,res,execError
	;
getCommands
	set (maxIndex,xiderBulk)=0,(tcpBuffer,xiderBulkReq,res)=""
	for  do
	. ; Get next command
	. set startIndex=1
	. ; Read until we see at least one delimiter (i.e. $C(13,10)). This will give us the number of tuples that follow. ;
	. for  set endIndex=$zfind(tcpBuffer,CRLF,startIndex) quit:endIndex  do readpacket(.tcpBuffer,.maxIndex)
	. set nTuples=$zextract(tcpBuffer,startIndex+1,endIndex-3)
	. for tuple=0:1:nTuples-1 do
	. . ; Each tuple is a set of <length> and <value> pairs each of which is delimiter (i.e. $C(13,10)) terminated
	. . ; Read <length> which is delimiter terminated
	. . set startIndex=endIndex
	. . for  set endIndex=$zfind(tcpBuffer,CRLF,startIndex) quit:endIndex  do readpacket(.tcpBuffer,.maxIndex)
	. . set valueLen=$zextract(tcpBuffer,startIndex+1,endIndex-3)
	. . ; Read <value> which is of length <valueLen>
	. . for  quit:maxIndex>=(endIndex+valueLen)  do readpacket(.tcpBuffer,.maxIndex)
	. . set %args(tuple)=$zextract(tcpBuffer,endIndex,endIndex+valueLen-1)
	. . set endIndex=endIndex+valueLen+2 ; +2 to skip past CRLF delimiter
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
    new %res
	new %label,%routine
	new credentials,paramsNode,cnt,JERR
	;
	; Expects "nTuples" and "%args(n)" to be set by caller
	;
	; clear the response
	set %res=""
	;
	; extract the command and set the argument count in command for the API
	set %args=nTuples
    if $data(%mindParams("uApi",$zpiece(%args(0),".",1,$zlength(%args(0),".")))) do
    . ; uAPI !!!
    . set x=%mindParams("uApi",%args(0))
    . set %args(-1)=$piece(x,"^",2),%args(-2)=$piece(x,"^",1)
    . ; now parameters
    . if $data(%mindParams("uApi",$zpiece(%args(0),".",1,$zlength(%args(0),".")),"parameters")) do
    . . set ix="",cnt=0 for  set ix=$order(%mindParams("uApi",$zpiece(%args(0),".",1,$zlength(%args(0),".")),"parameters",ix)) quit:ix=""  do
    . . . set paramsNode=$name(%mindParams("uApi",$zpiece(%args(0),".",1,$zlength(%args(0),".")),"parameters",ix))
    . . . set cnt=cnt+1
    . . . if @paramsNode@("datatype")="object" do  quit
    . . . . ; parse json to JDOM
    . . . . do parse^%mindJSON($name(%args(cnt)),$name(%args(@paramsNode@("name"))),"JERR")
    . . . . if $data(JERR) do log^%mindLogger("JSON ERROR")
    . . . . ;
    . . . if @paramsNode@("datatype")="string" set %args(@paramsNode@("name"))=%args(cnt)
    . . . else  set %args(@paramsNode@("name"))=+%args(cnt)
    . ;
    else  do
	. set %args(-1)=$zpiece(%args(0),".",1),%args(-2)=$zpiece(%args(0),".",2)
	. set %args(-1)="%mindNS"_%args(-1)
	;
	; --------------------------------
	; Extract label and routine
	; --------------------------------
	do:%mindParams("logLevel")>=%logCOMMANDS log^%mindLogger(%trm("green")_"COMMAND RECEIVED: "_%trm("white")_%args(0))
	; dump if needed
	do:%mindParams("dumpRequest")
	. ;do log^%mindLogger(%args(-1)_"   "_%args(-2))
	. if %args(0)="server.login" set credentials=%args(1),%args(1)=$piece(%args(1),":",1)_":*******"
	. for x=0:1:nTuples-1 do log^%mindLogger(x_"- "_%args(x))
	. ;display only the user name, no password on log
	. if %args(0)="server.login" set %args(1)=credentials
	;
	; --------------------------------
	; ensure user is logged in
	; --------------------------------
	set:%args(0)="server.login" loggedIn=1
	if loggedIn=0,%args(0)'="server.login" set %res="-Not logged in" goto parserQuit
	;
	; --------------------------------
	; Not supported or unknown command
	; --------------------------------
	if %args(-2)=""!($text(@%args(-2)^@%args(-1))="") do  goto parserQuit
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
parserQuit
	write %res,%commandTerminator,!
    ;
    ; timings if needed
    set:%mindParams("logLevel")>=%logTIMINGS %timingEnd=$zut,%duration=%timingEnd-%timingStart
    ;
	do:%mindParams("dumpResponse") log^%mindLogger(%trm("yellow")_"RESPONSE: "_%trm("white")_LF_$zwrite(%res))
    ;
    set execError=$zextract(%res,1,1)="-"!($extract(%res,1,1)="!")
    set:$zextract(%res,1,2)="--" execError=-1
    ;
    ; stats
	set:%mindParams("stats") ret=$increment(^%mindSessions("stats","_grand",$select(execError=0:"ok",execError=1:"nok",1:"invalid_cmd"))),ret=$increment(%mindParams("lstats","_grand",$select(execError=0:"ok",execError=1:"nok",1:"invalid_cmd")))
    set:%mindParams("stats")=2 ret=$increment(^%mindSessions("stats",%args(0),$select(execError=0:"ok",execError=1:"nok",1:"invalid_cmd"))),ret=$increment(%mindParams("lstats",%args(0),$select(execError=0:"ok",execError=1:"nok",1:"invalid_cmd")))
    ;
	do:%mindParams("logLevel")>=%logCOMMANDS log^%mindLogger($select(execError=0:%trm("light_green")_"COMMAND EXECUTED"_%trm("white"),execError=-1:%trm("light_red")_"M CODE NOT FOUND"_%trm("white"),1:%trm("red")_"COMMAND FAILED"_%trm("white"))_": "_%args(0))
    do:%mindParams("logLevel")>=%logTIMINGS log^%mindLogger(%trm("yellow")_"in "_%duration_" us")
	;
	; get ready for next command
	kill %args,%res
	;
	quit
	;
	;
mainErrorHandler ;
	use %mindParams("zio")
	;
	; log the error on console
	do log^%mindLogger(%trm("red")_"COMMAND FAILED: "_%args(0))
	if %mindParams("errorDump")=1 do log^%mindLogger(%trm("red")_"INT. ERROR: "_$zstatus)
	if %mindParams("errorDump")=2 do
	. do log^%mindLogger(%trm("red")_"**********************************")
	. do log^%mindLogger(%trm("red")_"*** An internal error occurred ***")
	. do log^%mindLogger(%trm("red")_"**********************************")
	. do log^%mindLogger(%trm("red")_"PID "_$job)
	. do log^%mindLogger(%trm("red")_"Location:     "_$zpiece($zstatus,",",2))
	. do log^%mindLogger(%trm("red")_"Error code:   "_$zpiece($zstatus,",",1))
	. do log^%mindLogger(%trm("red")_"Mnemonic:     "_$zpiece($zstatus,",",3))
	. ; the description in $zstatus can contain many commas, so just find where we left off and extract to the max $zstatus length
	. do log^%mindLogger(%trm("red")_"Description: "_$zextract($zstatus,$zfind($zstatus,$zpiece($zstatus,",",3))+1,2048))
	. ;
	. set dsm1=$stack(-1)-1
	. do log^%mindLogger(%trm("red")_"STACK:"_dsm1)
	. for l=dsm1:-1:0 do
	. . do log^%mindLogger(%trm("red")_"  "_l)
	. . do log^%mindLogger(%trm("red")_"  ecode: "_$stack(l,"ecode"))
	. . do log^%mindLogger(%trm("red")_"  place: "_$stack(l,"place"))
	. . do log^%mindLogger(%trm("red")_"  mcode: "_$stack(l,"mcode"))
	;
	; log the error on syslog
	set dummy=$ZSYSLOG("Fatal: "_$zstatus)
	;
	; send error to client
	use %ydbtcp
	set %res="-Internal error: "_$zstatus_CRLF
	write %res,$zchar(3)_CRLF_$zchar(3)_CRLF,!
    ;
    ; update stats if needed
	set:%mindParams("stats") ret=$increment(^%mindSessions("stats","_grand","nok")),ret=$increment(%mindSessions("lstats","_grand","nok"))
    set:%mindParams("stats")=2 ret=$increment(^%mindSessions("stats",%args(0),"nok")),ret=$increment(%mindSessions("lstats",%args(0),"nok"))
    ;
	; get ready for next command
	kill %args,%res
    ;
    ; jump back to beginning and restore the correct stack level
	zgoto %level:getCommands^%mindServerSession

	;
	;
errorHandler(exitCode) ;
	; session termination
	;
	set exitCode=$get(exitCode,0)
	;
	; do logging
	do log^%mindLogger(%trm("cyan")_"DISCONNECT: "_%trm("white")_$select('exitCode:"Remote ip: "_%remoteIp_" disconnected",1:"Session terminated due to error"))
	;
	; clean up session
	do delete^%mindSessions()
	;
	write !,$zstatus
	;
	zhalt exitCode
	;
	;
