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
;#################################################################
;#                                                               #
;# Copyright (c) 2024 YottaDB LLC and/or its subsidiaries.       #
;# All rights reserved.                                          #
;#                                                               #
;#  This source code contains the intellectual property	         #
;#  of its copyright holder(s), and is made available            #
;#  under a license.  If you do not know the terms of            #
;#  the license, please stop and do not read further.            #
;#                                                               #
;#################################################################
;
start ;
	new CRLF,%ydbtcp,tcpBuffer,xider,UPA,LF
	new %params,packet
	new devtmp,i,params,%remoteIp
	new timerH,%mindSessionId,ix
	new %commandTerminator
	new %level,dummy
	;
	; init main error handler
	new $etrap
	set $etrap="goto mainErrorHandler^%mindServerSession"
	set %level=$zlevel
	;
	set CRLF=$zchar(13,10),LF=$zchar(10)
	set UPA="^"
	set %commandTerminator=$zchar(3)_CRLF_$zchar(3)_CRLF
	set %ydbtcp=$principal ; TCP Device
	set %mindSessionId="S-"_$job
	for ix=1:1:10-$zlength(%mindSessionId) set %mindSessionId=%mindSessionId_" "
	;
	; ----------------------
	; set up the terminal for messages dumping
	; ----------------------
	open %mindParams("zio")
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
	. . set %params(tuple)=$zextract(tcpBuffer,endIndex,endIndex+valueLen-1)
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
	;do:%mindParams("dumpRequest") log^%mindLogger(packet)
	set tcpBuffer=tcpBuffer_packet
	set maxIndex=maxIndex+$zlength(packet)
	quit
	;
parser ;
    new %res
	new %label,%routine
	;
	; Expects "nTuples" and "%params(n)" to be set by caller
	;
	do:%mindParams("dumpRequest")
	. do log^%mindLogger("T"_nTuples)
	. for x=0:1:nTuples-1 do log^%mindLogger(x_"- "_%params(x))
	;
	; clear the response
	set %res=""
	;
	; extract the command and set the argument count in command for the API
	set %params=nTuples
	set %params(-1)=$zpiece(%params(0),".",1),%params(-2)=$zpiece(%params(0),".",2)
	;
	; --------------------------------
	; Extract label and routine
	; --------------------------------
	set %params(-1)="%mindNS"_%params(-1)
	do:%mindParams("logLevel")>=%logCOMMANDS log^%mindLogger(%trm("green")_"COMMAND RECEIVED: "_%trm("white")_%params(0))
	do:%mindParams("dumpRequest") log^%mindLogger(%params(-1)_"   "_%params(-2))
	;
	; --------------------------------
	; Not supported or unknown command
	; --------------------------------
	if %params(-2)=""!($text(@%params(-2)^@%params(-1))="") do  goto parserQuit
	. set %res="--Unknown namespace or command"_CRLF
	;
	; --------------------------------
	; Command dispatcher
	; --------------------------------
	do
	. set:%mindParams("stats") ret=$increment(^%mindSessions("stats"))
	. new (%mindSessionId,%params,%res,%mindParams,%ydbtcp,CRLF,LF,%remoteIp,%mindVersion,%logRESPONSES,%level,%logCOMMANDS,%trm)
	. do @%params(-2)^@%params(-1)
	;
parserQuit
	write %res,%commandTerminator,!
    ;
	do:%mindParams("logLevel")>=%logRESPONSES log^%mindLogger(%trm("yellow")_"RESPONSE: "_%trm("white")_LF_$zwrite(%res))
    ;
    set execError=$zextract(%res,1,1)="-"!($extract(%res,1,1)="!")
    set:$zextract(%res,1,2)="--" execError=-1
	do:%mindParams("logLevel")>=%logCOMMANDS log^%mindLogger($select(execError=0:%trm("light_green")_"COMMAND EXECUTED"_%trm("white"),execError=-1:%trm("light_red")_"COMMAND INVALID"_%trm("white"),1:%trm("red")_"COMMAND FAILED"_%trm("white"))_": "_%params(0))
	;
	; get ready for next command
	kill %params,%res
	;
	quit
	;
	;
mainErrorHandler ;
	use %mindParams("zio")
	;
	; log the error on console
	write !,"**********************************"
	write !,"*** An internal error occurred ***"
	write !,"**********************************",!
	write !,"PID",?19,$job
	write !,"Location",?19,$zpiece($zstatus,",",2)
	write !,"Error code",?19,$zpiece($zstatus,",",1)
	write !,"Mnemonic",?19,$zpiece($zstatus,",",3)
	; the description in $zstatus can contain many commas, so just find where we left off and extract to the max $zstatus length
	write !,"Description",?18,$zextract($zstatus,$zfind($zstatus,$zpiece($zstatus,",",3))+1,2048)
	write !
	;
	set dsm1=$stack(-1)-1
	write !,"$stack(-1):",dsm1
	for l=dsm1:-1:0 do
	. write !,l
	. for i="ecode","place","mcode" write ?5,i,?15,$stack(l,i),!
	;
	; log the error on syslog
	set dummy=$ZSYSLOG("Fatal: "_$zstatus)
	;
	; send error to client
	use %ydbtcp
	set %res="-Internal error: "_$zstatus_CRLF
	write %res,$zchar(3)_CRLF_$zchar(3)_CRLF,!
    ;
	; get ready for next command
	;set $ecode=""
	kill %params,%res
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
