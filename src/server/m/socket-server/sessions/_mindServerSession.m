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
	new CRLF,%ydbtcp,tcpBuffer,xider,UPA
	new command,packet
	new devtmp,i,params,remoteIp
	new timerH,%mindSessionId,ix
	;
	; init main error handler
	new $etrap
	set $etrap="goto mainErrorHandler^%mindServerSession"
	;
	set CRLF=$zchar(13,10)
	set UPA="^"
	set %ydbtcp=$principal ; TCP Device
	set %mindSessionId="S-"_$job
	for ix=1:1:10-$zlength(%mindSessionId) set %mindSessionId=%mindSessionId_" "
	;
	; init the sessionidle timer if needed
	set:+%mindParams("sessionIdleTimeout") $ztimeout=%mindParams("sessionIdleTimeout")_":goto timerSession"
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
	do:%mindParams("logLevel")>=%logSESSIONS log^%mindLogger("Remote ip: "_remoteIp_" connected, using PID: "_$job)
	;
	; ----------------------
	; set up socket characteristics
	; ----------------------
	use %ydbtcp:(chset="M":nodelim:znodelay:morereadtime=1)
	;
	new startIndex,endIndex,maxIndex,nTuples,tuple,valueLen,xiderBulk,xiderBulkReq
	set (maxIndex,xiderBulk)=0,(tcpBuffer,xiderBulkReq)=""
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
	; set command timeout
	if +%mindParams("commandTimeout") set $ztimeout=%mindParams("commandTimeout")_":goto timerSession"
	else  set $ztimeout=-1
    ;
	do:%mindParams("testMode") log^%mindLogger(packet)
	set tcpBuffer=tcpBuffer_packet
	set maxIndex=maxIndex+$zlength(packet)
	quit
	;
parser ;
    ; reset timer
    set $ztimeout=-1
    ;
	; Expects "nTuples" and "command(n)" to be set by caller
	;
	do:(%mindParams("logLevel")>=%logCOMMANDS)
	. ; use %mindParams("zio")
	. ;
	. do log^%mindLogger(nTuples)
	. for x=1:1:nTuples do log^%mindLogger(x_"- "_command(x))
	. ;
	. use %ydbtcp
	;
	; get ready for next command
	new cmd,cmdl,xiderRet,xiderStatus,xiderRetDetail
	new label,routine
	;
	; safeguard the RESP response dispatcher
	set (xiderRet,xiderStatus,xiderRetDetail)=""
	;
	; extract the command and set the argument count in command for the API
	set cmd=$zconvert(command(1),"u"),cmdl=$zconvert(cmd,"l"),command=nTuples
	set cmd("namespace")=$zpiece(cmdl,".",1),cmd("routine")=$zpiece(cmdl,".",2)
	;
	; ---------------------
	; REDIS-CLI COMMAND
	; ---------------------
	if cmd="COMMAND" do  goto parserQuit
	. write "+OK"_CRLF,!
	;
	set label=cmd("routine")
	set routine="%mindNS"_cmd("namespace")
	;
	; --------------------------------
	; Not supported or unknown command
	; --------------------------------
	if label=""!($text(@label^@routine)="") do  goto parserQuit
	. write "-Unknown namespace or command"_CRLF,!
	;
	; ---------------------
	; Dispatcher
	; ---------------------
	do @label^@routine
	write "xxx",!
	;
parserQuit
	; get ready for next command
	kill command
	;
	; remount the session timeout if needed
	if +%mindParams("sessionIdleTimeout") set $ztimeout=%mindParams("sessionIdleTimeout")_":goto timerSession"
	else  set $ztimeout=-1
    ;
	quit
	;
	;
mainErrorHandler ;
	use %mindParams("zio")
	;
	;set ^stef=$zstatus
	write !!,"**********************************"
	write !,"*** An internal error occurred ***"
	write !,"**********************************",!
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
	do log^%mindLogger($select('exitCode:"Remote ip: "_remoteIp_", using PID: "_$job_" disconnected",1:"Session terminate due to error"))
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
