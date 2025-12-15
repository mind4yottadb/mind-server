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
; Portions of this code have the following copyright
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
	do:%ydbxiderParams("logging")>=logVERBOSE&'%ydbxiderParams("testMode") log^%ydbxiderLogger("Remote clientId "_$job_" connected")
	;
	; ----------------------
	; initialize the API layer in socket mode
	; ----------------------
	set xider("noParamsValidation")=0
	do init^xider(1)
	;
	; ----------------------
	; set up socket characteristics
	; ----------------------
	use %ydbtcp:(chset="M":nodelim:znodelay)
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
	for  read packet:%ydbxiderParams("socketTimeout") goto errorHandler:$zeof quit:$zlength(packet)
	do:%ydbxiderParams("logging")>=logDEBUG&'%ydbxiderParams("testMode") log^%ydbxiderLogger(packet)
	set tcpBuffer=tcpBuffer_packet
	set maxIndex=maxIndex+$zlength(packet)
	quit
	;
parser	;
	; Expects "nTuples" and "command" to be set by caller
	;
	new cmd,ix,iy
	;
	; extract the command
	set cmd=$zconvert(command(1),"u")
	; and place the count as value
	;
	kill xider,xiderRet,xiderStatus
	;
	; ---------------------
	; CLIENT
	; ---------------------
	if cmd="CLIENT" do
	. write "+OK"_CRLF,!
	. ; here we store the session
	;
	; ---------------------
	; SET
	; ---------------------
	else  if cmd="SET" do
	. if 3>nTuples write errorString1_cmd_errorString2_CRLF,! set:$get(xiderMulti) xiderMulti=-1
	. else  do
	. . set xider("key")=command(2)
	. . set xider("value")=command(3)
	. . ;
	. . for ix=4:1:nTuples do
	. . . set command=$zconvert(command(ix),"u")
	. . . if command="NX"!(command="XX")!(command="KEEPTTL")!(command="GET") set xider("params",command)="",ix=ix+1 quit
	. . . if command="EX"!(command="PX")!(command="EXAT")!(command="PXAT") set xider("params",command)=command(ix+1),ix=ix+2 quit
	. . . ; bad parameter, force to exit or it will loop foever
	. . . set ix=nTuples+1
	. . ;
	. . ; call the data layer
	. . do SET^xider
	. . ;
	. . ; and ack the caller with the response
	. . if xiderBulk set xiderBulkReq=xiderBulkReq_xider("ret")
	. . else  write xider("ret"),!
	;
	; ---------------------
	; GET
	; ---------------------
	else  if cmd="GET" do
	. if 2>nTuples write errorString1_cmd_errorString2_CRLF,! set:$get(xiderMulti) xiderMulti=-1
	. else  do
	. . set xider("key")=command(2)
	. . ;
	. . ; call the data layer
	. . do GET^xider
	. . ;
	. . ; and ack the caller with the response
	. . if xiderBulk set xiderBulkReq=xiderBulkReq_xider("ret")
	. . else  write xider("ret"),!
	;
	; ---------------------
	; DEL
	; ---------------------
	else  if cmd="DEL" do
	. if 2>nTuples write errorString1_cmd_errorString2_CRLF,! set:$get(xiderMulti) xiderMulti=-1
	. else  do
	. . for iy=2:1:nTuples set xider("keys",iy-1)=command(iy)
	. . ;
	. . ; call the data layer
	. . do DEL^xider
	. . ;
	. . ; and ack the caller with the response
	. . if xiderBulk set xiderBulkReq=xiderBulkReq_xider("ret")
	. . else  write xider("ret"),!
	;
	; ---------------------
	; EXISTS
	; ---------------------
	else  if cmd="EXISTS" do
	. if 2>nTuples write errorString1_cmd_errorString2_CRLF,! set:$get(xiderMulti) xiderMulti=-1
	. else  do
	. . for iy=2:1:nTuples set xider("keys",iy-1)=command(iy)
	. . ;
	. . ; call the data layer
	. . do EXISTS^xider
	. . ;
	. . ; and ack the caller with the response
	. . if xiderBulk set xiderBulkReq=xiderBulkReq_xider("ret")
	. . else  write xider("ret"),!
	;
	; ---------------------
	; APPEND
	; ---------------------
	else  if cmd="APPEND" do
	. if 3>nTuples write errorString1_cmd_errorString2_CRLF,! set:$get(xiderMulti) xiderMulti=-1
	. else  do
	. . set xider("key")=command(2)
	. . set xider("value")=command(3)
	. . ;
	. . ; call the data layer
	. . do APPEND^xider
	. . ;
	. . ; and ack the caller with the response
	. . if xiderBulk set xiderBulkReq=xiderBulkReq_xider("ret")
	. . else  write xider("ret"),!
	;
	; ---------------------
	; STRLEN
	; ---------------------
	else  if cmd="STRLEN" do
	. if 2>nTuples write errorString1_cmd_errorString2_CRLF,! set:$get(xiderMulti) xiderMulti=-1
	. else  do
	. . set xider("key")=command(2)
	. . ;
	. . ; call the data layer
	. . do STRLEN^xider
	. . ;
	. . ; and ack the caller with the response
	. . if xiderBulk set xiderBulkReq=xiderBulkReq_xider("ret")
	. . else  write xider("ret"),!
	;
	; ---------------------
	; GETRANGE
	; ---------------------
	else  if cmd="GETRANGE" do
	. if 4>nTuples write errorString1_cmd_errorString2_CRLF,! set:$get(xiderMulti) xiderMulti=-1
	. else  do
	. . set xider("key")=command(2)
	. . set xider("start")=command(3)
	. . set xider("end")=command(4)
	. . ;
	. . ; call the data layer
	. . do GETRANGE^xider
	. . ;
	. . ; and ack the caller with the response
	. . if xiderBulk set xiderBulkReq=xiderBulkReq_xider("ret")
	. . else  write xider("ret"),!
	;
	; ---------------------
	; SUBSTR
	; ---------------------
	else  if cmd="SUBSTR" do
	. if 4>nTuples write errorString1_cmd_errorString2_CRLF,! set:$get(xiderMulti) xiderMulti=-1
	. else  do
	. . set xider("key")=command(2)
	. . set xider("start")=command(3)
	. . set xider("end")=command(4)
	. . ;
	. . ; call the data layer
	. . do SUBSTR^xider
	. . ;
	. . ; and ack the caller with the response
	. . if xiderBulk set xiderBulkReq=xiderBulkReq_xider("ret")
	. . else  write xider("ret"),!
	;
	; ---------------------
	; SETRANGE
	; ---------------------
	else  if cmd="SETRANGE" do
	. if 4>nTuples write errorString1_cmd_errorString2_CRLF,! set:$get(xiderMulti) xiderMulti=-1
	. else  do
	. . set xider("key")=command(2)
	. . set xider("offset")=command(3)
	. . set xider("value")=command(4)
	. . ;
	. . ; call the data layer
	. . do SETRANGE^xider
	. . ;
	. . ; and ack the caller with the response
	. . if xiderBulk set xiderBulkReq=xiderBulkReq_xider("ret")
	. . else  write xider("ret"),!
	;
	; ---------------------
	; RENAME
	; ---------------------
	else  if cmd="RENAME" do
	. if 3>nTuples write errorString1_cmd_errorString2_CRLF,! set:$get(xiderMulti) xiderMulti=-1
	. else  do
	. . set xider("key")=command(2)
	. . set xider("newkey")=command(3)
	. . ;
	. . ; call the data layer
	. . do RENAME^xider
	. . ;
	. . ; and ack the caller with the response
	. . if xiderBulk set xiderBulkReq=xiderBulkReq_xider("ret")
	. . else  write xider("ret"),!
	;
	; ---------------------
	; RENAMENX
	; ---------------------
	else  if cmd="RENAMENX" do
	. if 3>nTuples write errorString1_cmd_errorString2_CRLF,! set:$get(xiderMulti) xiderMulti=-1
	. else  do
	. . set xider("key")=command(2)
	. . set xider("newkey")=command(3)
	. . ;
	. . ; call the data layer
	. . do RENAMENX^xider
	. . ;
	. . ; and ack the caller with the response
	. . if xiderBulk set xiderBulkReq=xiderBulkReq_xider("ret")
	. . else  write xider("ret"),!
	;
	; ---------------------
	; GETDEL
	; ---------------------
	else  if cmd="GETDEL" do
	. if 2>nTuples write errorString1_cmd_errorString2_CRLF,! set:$get(xiderMulti) xiderMulti=-1
	. else  do
	. . set xider("key")=command(2)
	. . ;
	. . ; call the data layer
	. . do GETDEL^xider
	. . ;
	. . ; and ack the caller with the response
	. . if xiderBulk set xiderBulkReq=xiderBulkReq_xider("ret")
	. . else  write xider("ret"),!
	;
	; ---------------------
	; MSET
	; ---------------------
	else  if cmd="MSET" do
	. if 3>nTuples!(nTuples-1#2) write errorString1_cmd_errorString2_CRLF,! set:$get(xiderMulti) xiderMulti=-1
	. else  do
	. . for iy=2:2:nTuples set xider("keys",iy/2)=command(iy),xider("values",iy/2)=command(iy+1)
	. . ;
	. . ; call the data layer
	. . do MSET^xider
	. . ;
	. . ; and ack the caller with the response
	. . if xiderBulk set xiderBulkReq=xiderBulkReq_xider("ret")
	. . else  write xider("ret"),!
	;
	; ---------------------
	; MSETNX
	; ---------------------
	else  if cmd="MSETNX" do
	. if 3>nTuples!(nTuples-1#2) write errorString1_cmd_errorString2_CRLF,! set:$get(xiderMulti) xiderMulti=-1
	. else  do
	. . for iy=2:2:nTuples set xider("keys",iy/2)=command(iy),xider("values",iy/2)=command(iy+1)
	. . ;
	. . ; call the data layer
	. . do MSETNX^xider
	. . ;
	. . ; and ack the caller with the response
	. . if xiderBulk set xiderBulkReq=xiderBulkReq_xider("ret")
	. . else  write xider("ret"),!
	;
	; ---------------------
	; MGET
	; ---------------------
	else  if cmd="MGET" do
	. if 2>nTuples write errorString1_cmd_errorString2_CRLF,! set:$get(xiderMulti) xiderMulti=-1
	. else  do
	. . for iy=2:1:nTuples set xider("keys",iy-1)=command(iy)
	. . ;
	. . ; call the data layer
	. . do MGET^xider
	. . ;
	. . ; and ack the caller with the response
	. . if xiderBulk set xiderBulkReq=xiderBulkReq_xider("ret")
	. . else  write xider("ret"),!
	;
	; ---------------------
	; INCR
	; ---------------------
	else  if cmd="INCR" do
	. if 2>nTuples write errorString1_cmd_errorString2_CRLF,! set:$get(xiderMulti) xiderMulti=-1
	. else  do
	. . set xider("key")=command(2)
	. . ;
	. . ; call the data layer
	. . do INCR^xider
	. . ;
	. . ; and ack the caller with the response
	. . if xiderBulk set xiderBulkReq=xiderBulkReq_xider("ret")
	. . else  write xider("ret"),!
	;
	; ---------------------
	; INCRBY
	; ---------------------
	else  if cmd="INCRBY" do
	. if 3>nTuples write errorString1_cmd_errorString2_CRLF,! set:$get(xiderMulti) xiderMulti=-1
	. else  do
	. . set xider("key")=command(2)
	. . set xider("increment")=command(3)
	. . ;
	. . ; call the data layer
	. . do INCRBY^xider
	. . ;
	. . ; and ack the caller with the response
	. . if xiderBulk set xiderBulkReq=xiderBulkReq_xider("ret")
	. . else  write xider("ret"),!
	;
	; ---------------------
	; INCRBYFLOAT
	; ---------------------
	else  if cmd="INCRBYFLOAT" do
	. if 3>nTuples write errorString1_cmd_errorString2_CRLF,! set:$get(xiderMulti) xiderMulti=-1
	. else  do
	. . set xider("key")=command(2)
	. . set xider("increment")=command(3)
	. . ;
	. . ; call the data layer
	. . do INCRBYFLOAT^xider
	. . ;
	. . ; and ack the caller with the response
	. . if xiderBulk set xiderBulkReq=xiderBulkReq_xider("ret")
	. . else  write xider("ret"),!
	;
	; ---------------------
	; DECR
	; ---------------------
	else  if cmd="DECR" do
	. if 2>nTuples write errorString1_cmd_errorString2_CRLF,! set:$get(xiderMulti) xiderMulti=-1
	. else  do
	. . set xider("key")=command(2)
	. . ;
	. . ; call the data layer
	. . do DECR^xider
	. . ;
	. . ; and ack the caller with the response
	. . if xiderBulk set xiderBulkReq=xiderBulkReq_xider("ret")
	. . else  write xider("ret"),!
	;
	; ---------------------
	; DECRBY
	; ---------------------
	else  if cmd="DECRBY" do
	. if 3>nTuples write errorString1_cmd_errorString2_CRLF,! set:$get(xiderMulti) xiderMulti=-1
	. else  do
	. . set xider("key")=command(2)
	. . set xider("decrement")=command(3)
	. . ;
	. . ; call the data layer
	. . do DECRBY^xider
	. . ;
	. . ; and ack the caller with the response
	. . if xiderBulk set xiderBulkReq=xiderBulkReq_xider("ret")
	. . else  write xider("ret"),!
	;
	; ---------------------
	; HSET
	; ---------------------
	else  if cmd="HSET"!(cmd="HMSET") do
	. if 4>nTuples!(nTuples#2) write errorString1_cmd_errorString2_CRLF,! set:$get(xiderMulti) xiderMulti=-1
	. else  do
	. . ;
	. . set xider("key")=command(2)
	. . for iy=3:2:nTuples set xider("data",(iy-1)/2,"field")=command(iy),xider("data",(iy-1)/2,"value")=command(iy+1)
	. . ;
	. . ; call the data layer
	. . do HSET^xider
	. . ;
	. . ; and ack the caller with the response
	. . if xiderBulk set xiderBulkReq=xiderBulkReq_xider("ret")
	. . else  write xider("ret"),!
	;
	; ---------------------
	; HSETNX
	; ---------------------
	else  if cmd="HSETNX" do
	. if 4>nTuples write errorString1_cmd_errorString2_CRLF,! set:$get(xiderMulti) xiderMulti=-1
	. else  do
	. . ;
	. . set xider("key")=command(2)
	. . set xider("field")=command(3)
	. . set xider("value")=command(4)
	. . ;
	. . ; call the data layer
	. . do HSETNX^xider
	. . ;
	. . ; and ack the caller with the response
	. . if xiderBulk set xiderBulkReq=xiderBulkReq_xider("ret")
	. . else  write xider("ret"),!
	;
	; ---------------------
	; HGET
	; ---------------------
	else  if cmd="HGET" do
	. if 3>nTuples write errorString1_cmd_errorString2_CRLF,! set:$get(xiderMulti) xiderMulti=-1
	. else  do
	. . set xider("key")=command(2)
	. . set xider("field")=command(3)
	. . ;
	. . ; call the data layer
	. . do HGET^xider
	. . ;
	. . ; and ack the caller with the response
	. . if xiderBulk set xiderBulkReq=xiderBulkReq_xider("ret")
	. . else  write xider("ret"),!
	;
	; ---------------------
	; HRANDFIELD - Get one or multiple random fields from a hash
	; ---------------------
	else  if cmd="HRANDFIELD" do
	. if 2>nTuples!(nTuples>4) write errorString1_$zconvert(cmd,"l")_errorString2_CRLF,! set:$get(xiderMulti) xiderMulti=-1
	. else  do
	. . set xider("key")=command(2)
	. . set:$data(command(3)) xider("count")=command(3)
	. . if $data(command(4)),"withvalues"'=$zconvert(command(4),"l") write errorString3_CRLF,! quit
	. . set:$data(command(4)) xider("withValues")=""
	. . ;
	. . ; call the data layer
	. . do HRANDFIELD^xider
	. . ;
	. . ; and ack the caller with the response
	. . if xiderBulk set xiderBulkReq=xiderBulkReq_xider("ret")
	. . else  write xider("ret"),!
	;
	; ---------------------
	; HDEL
	; ---------------------
	else  if cmd="HDEL" do
	. if 3>nTuples write errorString1_cmd_errorString2_CRLF,! set:$get(xiderMulti) xiderMulti=-1
	. else  do
	. . set xider("key")=command(2)
	. . for iy=3:1:nTuples set xider("fields",iy-2)=command(iy)
	. . ;
	. . ; call the data layer
	. . do HDEL^xider
	. . ;
	. . ; and ack the caller with the response
	. . if xiderBulk set xiderBulkReq=xiderBulkReq_xider("ret")
	. . else  write xider("ret"),!
	;
	; ---------------------
	; HLEN
	; ---------------------
	else  if cmd="HLEN" do
	. if 2>nTuples write errorString1_cmd_errorString2_CRLF,! set:$get(xiderMulti) xiderMulti=-1
	. else  do
	. . set xider("key")=command(2)
	. . ;
	. . ; call the data layer
	. . do HLEN^xider
	. . ;
	. . ; and ack the caller with the response
	. . if xiderBulk set xiderBulkReq=xiderBulkReq_xider("ret")
	. . else  write xider("ret"),!
	;
	; ---------------------
	; HSTRLEN
	; ---------------------
	else  if cmd="HSTRLEN" do
	. if 3>nTuples write errorString1_cmd_errorString2_CRLF,! set:$get(xiderMulti) xiderMulti=-1
	. else  do
	. . set xider("key")=command(2)
	. . set xider("field")=command(3)
	. . ;
	. . ; call the data layer
	. . do HSTRLEN^xider
	. . ;
	. . ; and ack the caller with the response
	. . if xiderBulk set xiderBulkReq=xiderBulkReq_xider("ret")
	. . else  write xider("ret"),!
	;
	; ---------------------
	; HKEYS
	; ---------------------
	else  if cmd="HKEYS" do
	. if 2>nTuples write errorString1_cmd_errorString2_CRLF,! set:$get(xiderMulti) xiderMulti=-1
	. else  do
	. . set xider("key")=command(2)
	. . ;
	. . ; call the data layer
	. . do HKEYS^xider
	. . ;
	. . ; and ack the caller with the response
	. . if xiderBulk set xiderBulkReq=xiderBulkReq_xider("ret")
	. . else  write xider("ret"),!
	;
	; ---------------------
	; HVALS
	; ---------------------
	else  if cmd="HVALS" do
	. if 2>nTuples write errorString1_cmd_errorString2_CRLF,! set:$get(xiderMulti) xiderMulti=-1
	. else  do
	. . set xider("key")=command(2)
	. . ;
	. . ; call the data layer
	. . do HVALS^xider
	. . ;
	. . ; and ack the caller with the response
	. . if xiderBulk set xiderBulkReq=xiderBulkReq_xider("ret")
	. . else  write xider("ret"),!
	;
	; ---------------------
	; HEXISTS
	; ---------------------
	else  if cmd="HEXISTS" do
	. if 3>nTuples write errorString1_cmd_errorString2_CRLF,! set:$get(xiderMulti) xiderMulti=-1
	. else  do
	. . set xider("key")=command(2)
	. . set xider("field")=command(3)
	. . ;
	. . ; call the data layer
	. . do HEXISTS^xider
	. . ;
	. . ; and ack the caller with the response
	. . if xiderBulk set xiderBulkReq=xiderBulkReq_xider("ret")
	. . else  write xider("ret"),!
	;
	; ---------------------
	; HMGET
	; ---------------------
	else  if cmd="HMGET" do
	. if 3>nTuples write errorString1_cmd_errorString2_CRLF,! set:$get(xiderMulti) xiderMulti=-1
	. else  do
	. . set xider("key")=command(2)
	. . for iy=3:1:nTuples set xider("fields",iy-2)=command(iy)
	. . ;
	. . ; call the data layer
	. . do HMGET^xider
	. . ;
	. . ; and ack the caller with the response
	. . if xiderBulk set xiderBulkReq=xiderBulkReq_xider("ret")
	. . else  write xider("ret"),!
	;
	; ---------------------
	; HGETALL
	; ---------------------
	else  if cmd="HGETALL" do
	. if 2>nTuples write errorString1_cmd_errorString2_CRLF,! set:$get(xiderMulti) xiderMulti=-1
	. else  do
	. . set xider("key")=command(2)
	. . ;
	. . ; call the data layer
	. . do HGETALL^xider
	. . ;
	. . ; and ack the caller with the response
	. . if xiderBulk set xiderBulkReq=xiderBulkReq_xider("ret")
	. . else  write xider("ret"),!
	;
	; ---------------------
	; HINCRBY
	; ---------------------
	else  if cmd="HINCRBY" do
	. if 4>nTuples write errorString1_cmd_errorString2_CRLF,! set:$get(xiderMulti) xiderMulti=-1
	. else  do
	. . set xider("key")=command(2)
	. . set xider("field")=command(3)
	. . set xider("increment")=command(4)
	. . ;
	. . ; call the data layer
	. . do HINCRBY^xider
	. . ;
	. . ; and ack the caller with the response
	. . if xiderBulk set xiderBulkReq=xiderBulkReq_xider("ret")
	. . else  write xider("ret"),!
	;
	; ---------------------
	; HINCRBYFLOAT
	; ---------------------
	else  if cmd="HINCRBYFLOAT" do
	. if 4>nTuples write errorString1_cmd_errorString2_CRLF,! set:$get(xiderMulti) xiderMulti=-1
	. else  do
	. . set xider("key")=command(2)
	. . set xider("field")=command(3)
	. . set xider("increment")=command(4)
	. . ;
	. . ; call the data layer
	. . do HINCRBYFLOAT^xider
	. . ;
	. . ; and ack the caller with the response
	. . if xiderBulk set xiderBulkReq=xiderBulkReq_xider("ret")
	. . else  write xider("ret"),!
	;
	; ---------------------
	; COMMAND
	; ---------------------
	else  if cmd="COMMAND" do
	. do COMMAND^xider
	. ;
	. write "+OK"_CRLF,!
	;
	; ---------------------
	; WATCH - Watch the given keys to determine execution of the MULTI/EXEC block
	; ---------------------
	else  if cmd="WATCH" do
	. if 2>nTuples write errorString1_$zconvert(cmd,"l")_errorString2_CRLF,! set:$get(xiderMulti) xiderMulti=-1
	. else  do
	. . for iy=2:1:nTuples set xider("keys",iy-1)=command(iy)
	. . ;
	. . ; call the data layer
	. . do WATCH^xider
	. . ;
	. . ; and ack the caller with the response
	. . if xiderBulk set xiderBulkReq=xiderBulkReq_xider("ret")
	. . else  write xider("ret"),!
	;
	; ---------------------
	; UNWATCH - Forget about all watched keys
	; ---------------------
	else  if cmd="UNWATCH" do
	. if 1<nTuples write errorString1_$zconvert(cmd,"l")_errorString2_CRLF,! set:$get(xiderMulti) xiderMulti=-1
	. else  do
	. . ; call the data layer
	. . do UNWATCH^xider
	. . ;
	. . ; and ack the caller with the response
	. . if xiderBulk set xiderBulkReq=xiderBulkReq_xider("ret")
	. . else  write xider("ret"),!
	;
	;
	; ---------------------
	; MULTI - Mark the start of a transaction block
	; ---------------------
	else  if cmd="MULTI" do
	. if 1<nTuples write errorString1_$zconvert(cmd,"l")_errorString2_CRLF,! set:$get(xiderMulti) xiderMulti=-1
	. else  do
	. . ; call the data layer
	. . do MULTI^xider
	. . ;
	. . ; and ack the caller with the response
	. . if xiderBulk set xiderBulkReq=xiderBulkReq_xider("ret")
	. . else  write xider("ret"),!
	;
	; ---------------------
	; EXEC - Execute all commands issued after MULTI
	; ---------------------
	else  if cmd="EXEC" do
	. if 1<nTuples write errorString1_$zconvert(cmd,"l")_errorString2_CRLF,! set:$get(xiderMulti) xiderMulti=-1
	. else  do
	. . new xiderRet,xiderStatus
	. . ;
	. . ; call the data layer
	. . do EXEC^xider
	. . ;
	. . ; and ack the caller with the response
	. . write xiderRet,!
	;
	; ---------------------
	; DISCARD - Discard all commands issued after MULTI
	; ---------------------
	else  if cmd="DISCARD" do
	. if 1<nTuples write errorString1_$zconvert(cmd,"l")_errorString2_CRLF,! set:$get(xiderMulti) xiderMulti=-1
	. else  do
	. . ; call the data layer
	. . do DISCARD^xider
	. . ;
	. . ; and ack the caller with the response
	. . if xiderBulk set xiderBulkReq=xiderBulkReq_xider("ret")
	. . else  write xider("ret"),!
	;
	; --------------------------------
	; Not supported or unknown command
	; --------------------------------
	else  write "-Xider unsupported command: "_cmd_CRLF,!
	;
	; get ready for next command
	kill command,xider
	;
	quit
	;
	;
mainErrorHandler ;
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
