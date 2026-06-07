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
; Copyright (c) 2024-2025 YottaDB LLC and/or its subsidiaries.	;
	;
; This routine process the socket connection and dispatcher
;
	;
start
    new %mindIx,onInit,onInitCounter,onInitCode,onInitCodeCounter,newZroutines
	; ****************************************
	; mount root error handler
	; ****************************************
	new $etrap
	set $etrap="goto rootErrorHandler^%mindSocketServer"
	;
	; ****************************************
	; mount signal handler
	; ****************************************
	set $zinterrupt="do log^%mindLogger(""Signal SIGUSR1 received, gracefully exiting...""),rundown^%mindSocketServer(252)"
	;
	; -------------
	; Enable CTRL-C
	; -------------
	use $principal:(ctrap=$zchar(3):exception="use %mindParams(""logDevice"") write ! do log^%mindLogger(""Control-C received, gracefully exiting..."") do rundown^%mindSocketServer(252)")
	;
	; ----------------------
	; Initialize the sessions
	; ----------------------
	; Initialize session global
	do initialize^%mindSessions()
	;
	; ---------------------------------------------------------
	; Executes the onInit() callbacks for the registered apps
	; ---------------------------------------------------------
	if $data(%mindParams("uApiServer","hooks")) do
	. ; collect the data
	. set %mindIx="" for  set %mindIx=$order(%mindParams("uApiServer","hooks",%mindIx)) quit:%mindIx=""  do
	. . if $data(%mindParams("uApiServer","hooks",%mindIx,"onInit")),$get(%mindParams("uApiServer","hooks",%mindIx,"onInit"))'="" do
	. . . set onInit($increment(onInitCounter))=%mindParams("uApiServer","hooks",%mindIx,"onInit")
	. . . if $data(%mindParams("uApiServer","code",%mindIx)),$get(%mindParams("uApiServer","code",%mindIx))'="" set onInitCode($increment(onInitCodeCounter))=%mindParams("uApiServer","code",%mindIx)
	. ;
	. ; change the $zroutines to ensure code is reachable
	. set (newZroutines,onInitCodeCounter)=""
	. for  set onInitCodeCounter=$order(onInitCode(onInitCodeCounter)) quit:onInitCodeCounter=""  do
	. . set newZroutines=newZroutines_onInitCode(onInitCodeCounter)_" "
	. set $zroutines=newZroutines_" "_%mindParams("userApiDir")_" "_$zroutines
	. ;
	. ; and execute the onInit code
	. set onInitCounter="" for  set onInitCounter=$order(onInit(onInitCounter)) quit:onInitCounter=""  do
	. . do @onInit(onInitCounter),log^%mindLogger("onInit(): "_onInit(onInitCounter)_" executed.")
	. ;
	. ; reset the $zroutines
    . set $zroutines=%mindParams("zroutines")
    ;
	; clear up the %mindTrm if we are logging to file
	do:%mindParams("logDevice")'=$principal resetTerminal^%mindTerminal
	;
	; ---------------------------
	; pre-compile the server info
	; ---------------------------
	set %mindParams("serverInfo")=$$compileServerInfo^%mindNSserver()
	;
	; --------------------------------
	; --------------------------------
	; --------------------------------
	; Initialize the Socket server
	; --------------------------------
	; --------------------------------
	; --------------------------------
	new tcpio,childsock,jobCommandErrorFile,arg,job,quote,%mindPpid
	;
	set jobCommandErrorFile="/tmp/mind"_$job_".stderr"
	set tcpio="SCK$"_%mindParams("port")
	set quote=""""
	set %mindParams("serverPid")=$job
	;
	; Open socket
	new %mindDevice,%mindProtocol
	set %mindDevice=$select(%mindParams("protocol")="TCP":%mindParams("port"),1:$zsearch(%mindParams("udsBasePath"))_"/"_%mindParams("udsFile"))
	set %mindProtocol=$select(%mindParams("protocol")="TCP":%mindParams("protocol"),1:"LOCAL")
	;
	open tcpio:(listen=%mindDevice_":"_%mindProtocol:NEWVERSION:delim=$zchar(13,10):attach="server"):0:"socket"
	else  do
	. ; ERROR OPENING SERVER!!!
	. use $principal
	. if %mindParams("protocol")="TCP" write !!,"Fatal: Cannot open port: "_%mindParams("port"),!!
	. else  write !!,"Fatal: Cannot open file: "_%mindDevice,!!
	. do rundown(253)
	;
	kill %mindDevice,%mindProtocol
	;
	; set up listen mode
	use tcpio:(chset="M")
	write /listen(5)
	;
	; dump messages
	use $principal
	if %mindParams("protocol")="TCP" do log^%mindLogger("TCP Socket Server initialized on port "_%mindParams("port")),log^%mindLogger("Ready to accept connections"),log^%mindLogger("CTRL-C or SIGUSR1 will gracefully terminate the server...")
	if %mindParams("protocol")'="TCP" do log^%mindLogger("UDS Server initialized using file "_%mindParams("udsBasePath")_"/"_%mindParams("udsFile")),log^%mindLogger("Ready to accept connections"),log^%mindLogger("CTRL-C or SIGUSR1 will gracefully terminate the server...")
	;
	use tcpio
	;
loop ; Wait until we have a connection (infinite wait). ;
	for  write /wait(10) quit:$key]""
	;
	; detach the socket and job off, passing the socket
	do:$zpiece($key,"|")="CONNECT"
	. set childsock=$zpiece($key,"|",2)
	. use tcpio:(detach=childsock)
	. set arg="""SOCKET:"_childsock_""""
	. set job="start^%mindServerSession:(input="_arg_":output="_arg_":error="_quote_jobCommandErrorFile_quote_":pass:cmd=""start^%mindServerSession"")"
	. new (%mindParams,job,%mindLogNONE,%mindLogSESSIONS,%mindLogCOMMANDS,%mindLogTIMINGS,%mindVersion,%mindTrm,tcpio)
	. job @job
	;
	;
	goto loop
	;
	;
rundown(exitCode) ; This is supposed to send SIGUSR1 to children for appropriate rundown, at the moment, it just sends a SIGTERM
	new pid,ret
	;
	use %mindParams("zio")
	;
	write %mindTrm("tty_reset")
	;
	set pid="" for  set pid=$order(^%mindSessions(pid)) quit:'$zlength(pid)!(+pid=0)  do
	. do:^%mindSessions(pid,"type")="S"!(^%mindSessions(pid,"type")="H")
	. . quit:$zgetjpi(pid,"isprocalive")=-1
	. . set ret=$zsigproc(pid,"SIGUSR1")
	. . do log^%mindLogger("Terminating "_$get(^%mindSessions(pid,"description"))_" PID "_pid)
	;
	hang 1
	do log^%mindLogger("Rundown successful, exiting...")
	;
	zhalt exitCode
	;
	;
rootErrorHandler ;
	use %mindParams("zio")
	;
	; if error is user defined it represents the exit code
	zhalt:$zextract($ecode,2)="U" $zpiece($ecode,",",2)
	;
	write !!,"**********************************"
	write !,"*** An internal error occurred ***"
	write !,"**********************************",!
	write !,"Location",?19,$zpiece($zstatus,",",2)
	write !,"Error code",?19,$zpiece($zstatus,",",1)
	write !,"Mnemonic",?19,$zpiece($zstatus,",",3)
	write !,"Description",?18,$zextract($zstatus,$zfind($zstatus,$zpiece($zstatus,",",3))+1,2048)
	write !
	;
	; execute a rundown and exit with exit code 255
	do:$ZSYSLOG("Fatal: "_$zstatus) rundown(255)
	;
	;
