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
	new devtmp,i,params,remoteIp,errorString1,errorString2,errorString3
	new xiderMulti,xiderWatch,xiderCmd
	;
	new $etrap
	set $etrap="do mainErrorHandler^%mindServerSession"
	;
	set CRLF=$zchar(13,10)
	set UPA="^"
	set %ydbtcp=$principal ; TCP Device
	set errorString1="-ERR wrong number of arguments for '"
	set errorString2="' command"
	set errorString3="-ERR syntax error"
	;
	; ----------------------
	; set up the terminal for messages dumping
	; ----------------------
	open %appParams("zio")
	;
	use %appParams("zio")
	zwr
	do log^%mindLogger("This is a message for you")
	; ----------------------
	; create a new session node (to be filled by the handshaking)
	; ----------------------
	; extract the remoteIp #
	zshow "d":devtmp
	for i=0:0 set i=$order(devtmp("D",i)) quit:'i  set:devtmp("D",i)["REMOTE" remoteIp=$zpiece($zpiece(devtmp("D",i),"REMOTE=",2),"@")
	;
	; populate the session node
	set params("type")="S",params("description")="Socket clientId "_$job,params("ipNumber")=remoteIp
	do add^%mindSessions(.params)
	;
	;
	; ----------------------
	; log dump
	; ----------------------
	do log^%ydbxiderLogger("Remote clientId "_$job_" connected")
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
	. ; The size of a single MULTI packet payload is 15, so anything larger is a bulk MULTI request (Python driver pipeline)
	. set:'xiderBulk&(tcpBuffer["MULTI"!(tcpBuffer["multi"))&($zlength(tcpBuffer)>15) xiderBulk=1
	. do parser ; invoke the parser
	. set tcpBuffer=$zextract(tcpBuffer,endIndex,maxIndex),maxIndex=maxIndex-endIndex+1
	. ;
	;
readpacket(tcpBuffer,maxIndex)
	new packet
	for  read packet goto errorHandler:$zeof quit:$zlength(packet)
	do:%ydbxiderParams("logging")>=logDEBUG&'%ydbxiderParams("testMode") log^%ydbxiderLogger(packet)
	set tcpBuffer=tcpBuffer_packet
	set maxIndex=maxIndex+$zlength(packet)
	quit
	;
parser ;
	; Expects "nTuples" and "xider(n)" to be set by caller
	;
	; get ready for next command
	new cmd,cmdl,xiderRet,xiderStatus,xiderRetDetail
	; safeguard the RESP response dispatcher
	set (xiderRet,xiderStatus,xiderRetDetail)=""
	;
	; extract the command and set the argument count in command for the API
	set cmd=$zconvert(xider(1),"u"),cmdl=$zconvert(cmd,"l"),xider=nTuples
	;
	; ---------------------
	; CLIENT
	; ---------------------
	if cmd="CLIENT" do
	. write xiderRetType(Ok)_CRLF,!
	. ; here we store the session
	;
	; ---------------------
	; COMMAND
	; ---------------------
	else  if cmd="COMMAND" do
	. do COMMAND^xider
	. ;
	. write xiderRetType(Ok)_CRLF,!
	;
	else  if cmd="EXEC" do
	. new xiderExecRet,xiderExecStatus
	. ;
	. ; call the data layer
	. do EXEC^xider
	. ;
	. ; and ack the caller with the response
	. write xiderExecRet,!
	; ---------------------
	; API Commands
	; ---------------------
	else  if $zlength($text(@cmd^xider)) do
	. ; call the data layer
	. do @cmd^xider
	. ;
	. ; and ack the caller with the response
	. if xiderBulk set xiderBulkReq=xiderBulkReq_xiderRet
	. else  write xiderRet,!
	;
	; --------------------------------
	; Not supported or unknown command
	; --------------------------------
	else  do
	. write $$^%MPIECE(xiderRetType(UnknownCommand),"{cmd}",xider(1))
	. new i for i=2:1:xider write " '"_xider(i)_"'"
	. write CRLF,!
	;
	; get ready for next command
	kill xider
	;
	quit
	;
	;mainErrorHandler ;
	use zpout
	;
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
	do:$ZSYSLOG("Fatal: "_$zstatus) errorHandler^%ydbxiderServerSession(5)
	;
	;
errorHandler(exitCode) ;
	; session termination
	;
	set exitCode=$get(exitCode,0)
	;
	; do logging
	;do:%mindParams("logging")>=logVERBOSE&'%ydbxiderParams("testMode") log^%ydbxiderLogger($select('exitCode:"Remote clientId "_$job_" disconnected",1:"Session terminate due to error"))
	;
	; clean up session
	do delete^%ydbxiderSessions()
	;
	zhalt exitCode
	;
	;
	;
