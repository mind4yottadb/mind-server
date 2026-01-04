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
	new command,packet
	new devtmp,i,params,remoteIp
	new timerH,%mindSessionId,ix
	new commandTerminator
	;
	; init main error handler
	new $etrap
	set $etrap="goto mainErrorHandler^%mindServerSession"
	;
	set CRLF=$zchar(13,10),LF=$zchar(10)
	set UPA="^"
	set commandTerminator=$zchar(3)_CRLF_$zchar(3)_CRLF
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
	for i=0:0 set i=$order(devtmp("D",i)) quit:'i  set:devtmp("D",i)["REMOTE" remoteIp=$zpiece($zpiece(devtmp("D",i),"REMOTE=",2),"@")
	set remoteIp=$piece(remoteIp,":",4)
	;
	; populate the session node
	set params("type")="S",params("description")="Socket clientId "_$job,params("ipNumber")=remoteIp
	do add^%mindSessions(.params)
	;
	;
	; ----------------------
	; log dump
	; ----------------------
	do:%mindParams("logLevel")>=%logSESSIONS log^%mindLogger(%mindTrm("cyan")_"CONNECT"_%mindTrm("white")_": Remote ip: "_remoteIp_" using PID: "_$job)
	;
	; ----------------------
	; set up socket characteristics
	; ----------------------
	use %ydbtcp:(chset="M":nodelim:znodelay:morereadtime=1)
	;
	new startIndex,endIndex,maxIndex,nTuples,tuple,valueLen,xiderBulk,xiderBulkReq,res
	;
	set (maxIndex,xiderBulk)=0,(tcpBuffer,xiderBulkReq,res)=""
	for  do
	. ; Get next command
	. set startIndex=1
	. ; Read until we see at least one delimiter (i.e. $C(13,10)). This will give us the number of tuples that follow. ;
	. for  set endIndex=$zfind(tcpBuffer,CRLF,startIndex) quit:endIndex  do readpacket(.tcpBuffer,.maxIndex)
	. set nTuples=$zextract(tcpBuffer,startIndex+1,endIndex-3)
	. for tuple=1:1:nTuples do
	. . ; Each tuple is a set of <length> and <value> pairs each of which is delimiter (i.e. $C(13,10)) terminated
	. . ; Read <length> which is delimiter terminated
	. . set startIndex=endIndex
	. . for  set endIndex=$zfind(tcpBuffer,CRLF,startIndex) quit:endIndex  do readpacket(.tcpBuffer,.maxIndex)
	. . set valueLen=$zextract(tcpBuffer,startIndex+1,endIndex-3)
	. . ; Read <value> which is of length <valueLen>
	. . for  quit:maxIndex>=(endIndex+valueLen)  do readpacket(.tcpBuffer,.maxIndex)
	. . set command(tuple)=$zextract(tcpBuffer,endIndex,endIndex+valueLen-1)
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
	;do:%mindParams("testMode") log^%mindLogger(packet)
	set tcpBuffer=tcpBuffer_packet
	set maxIndex=maxIndex+$zlength(packet)
	quit
	;
parser ;
    new %mindRes
	new label,routine
	;
    ; reset timer
    ;set $ztimeout=-1
    ;
	; Expects "nTuples" and "command(n)" to be set by caller
	;
	do:%mindParams("testMode")
	. do log^%mindLogger("T"_nTuples)
	. for x=1:1:nTuples do log^%mindLogger(x_"- "_command(x))
	;
	; clear the response
	set %mindRes="",%mindRes("status")=0
	;
	; extract the command and set the argument count in command for the API
	set command=nTuples
	set cmd("namespace")=$zpiece(command(1),".",1),cmd("routine")=$zpiece(command(1),".",2)
	;
	set label=cmd("routine")
	set routine="%mindNS"_cmd("namespace")
	do:%mindParams("logLevel")>=%logCOMMANDS log^%mindLogger(%mindTrm("green")_"COMMAND RECEIVED: "_%mindTrm("white")_command(1))
	do:%mindParams("testMode") log^%mindLogger(label_"   "_routine)
	;
	; --------------------------------
	; Not supported or unknown command
	; --------------------------------
	if label=""!($text(@label^@routine)="") do  goto parserQuit
	. set %mindRes="-Unknown namespace or command"_CRLF,%mindRes("status")=-1
	;
	; ---------------------
	; Dispatcher
	; ---------------------
	do @label^@routine
	;
parserQuit
	write %mindRes,commandTerminator,!
    ;
	do:%mindParams("logLevel")>=%logRESPONSES log^%mindLogger(%mindTrm("yellow")_"RESPONSE: "_%mindTrm("white")_LF_$zwrite(%mindRes))
    ;
	do:%mindParams("logLevel")>=%logCOMMANDS log^%mindLogger($select(%mindRes("status")=1:%mindTrm("light_green")_"COMMAND EXECUTED"_%mindTrm("white"),%mindRes("status")=-1:%mindTrm("light_red")_"COMMAND INVALID"_%mindTrm("white"),1:%mindTrm("red")_"COMMAND FAILED"_%mindTrm("white"))_": "_command(1))
	;
	; get ready for next command
	kill command,%mindRes
	;
	quit
	;
	;
mainErrorHandler ;
	use %mindParams("zio")
	;
	;set ^stef=$zstatus
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
	do:$ZSYSLOG("Fatal: "_$zstatus) errorHandler^%mindServerSession(5)
	;
	;
errorHandler(exitCode) ;
	; session termination
	;
	set exitCode=$get(exitCode,0)
	;
	; do logging
	do log^%mindLogger(%mindTrm("cyan")_"DISCONNECT: "_%mindTrm("white")_$select('exitCode:"Remote ip: "_remoteIp_", using PID: "_$job_" disconnected",1:"Session terminated due to error"))
	;
	; clean up session
	do delete^%mindSessions()
	;
	write !,$zstatus
	;
	zhalt exitCode
	;
	;
timerSession
    do log^%mindLogger("Terminating session due to idle timeout")
    halt
    ;
	;
timerCommand
    do log^%mindLogger("Terminating session due to command timeout")
    halt
    ;
	;
