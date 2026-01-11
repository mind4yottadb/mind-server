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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;								                                ;
; Copyright (c) 2024-2025 YottaDB LLC and/or its subsidiaries.	;
; All rights reserved.                                          ;
;								                                ;
;	This source code contains the intellectual property	        ;
;	of its copyright holder(s), and is made available	        ;
;	under a license.  If you do not know the terms of	        ;
;	the license, please stop and do not read further.	        ;
;								                                ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;
; This routine process the socket connection and dispatcher
;
	;
start
	; ****************************************
	; mount root error handler
	; ****************************************
	new $etrap
	set $etrap="goto rootErrorHandler^%mindSocketServer"
	;
	;
	; if true, ignores $principal device
	set %ydbxiderParams("dumpRequest")=0
	;
	; -------------
	; Enable CTRL-C
	; -------------
	use $principal:(ctrap=$zchar(3):exception="use $principal write !,""Caught Ctrl-C..."",! do rundown^%mindSocketServer(252)")
	;
	; ----------------------
	; Initialize the sessions
	; ----------------------
	; Initialize session global
	do initialize^%mindSessions()
	;
	; --------------------------------
	; --------------------------------
	; --------------------------------
	; Initialize the Socket server
	; --------------------------------
	; --------------------------------
	; --------------------------------
	new tcpio,childsock,jobCommandErrorFile,arg,job,quote
	;
	set jobCommandErrorFile="/tmp/mind"_$job_".stderr"
	set tcpio="SCK$"_%mindParams("port")
	set quote=""""
	;
	; Open socket
	open tcpio:(listen=%mindParams("port")_":TCP":delim=$zchar(13,10):attach="server"):0:"socket"
	else  use $principal write !!,"Fatal: Cannot open port "_%mindParams("port"),!! do rundown(253)
	;
	; set up listen mode
	use tcpio:(chset="M")
	write /listen(5)
	;
	; dump messages
	use $principal
	do log^%mindLogger("Socket Server initialized on port "_%mindParams("port")),log^%mindLogger("Ready to accept connections"),log^%mindLogger("CTRL-C will gracefully terminate the server...")
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
	. new (%mindParams,job,%logNONE,%logSESSIONS,%logCOMMANDS,%logRESPONSES,%TESTMODE,%mindVersion,%trm)
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
	write !,"Gracefully running down..."
	;
	set pid="" for  set pid=$order(^%mindSessions(pid)) quit:'$zlength(pid)  do
	. do:^%mindSessions(pid,"type")="S"!(^%mindSessions(pid,"type")="H")
	. . set ret=$zsigproc(pid,"SIGTERM")
	. . write !,?2,"Terminating "_$get(^%mindSessions(pid,"description"))_" PID ",pid,"...",?44,"Terminated with code: ",ret
	;
	write !,"Rundown successful, exiting...",!!
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
	; the description in $zstatus can contain many commas, so just find where we left off and extract to the max $zstatus length
	write !,"Description",?18,$zextract($zstatus,$zfind($zstatus,$zpiece($zstatus,",",3))+1,2048)
	write !
	;
	; execute a rundown and exit with exit code 5
	do:$ZSYSLOG("Fatal: "_$zstatus) rundown(255)
	;
	;
getVersionNumber() quit "0.1.0"
	;
	;
	;
	;
	;
	;
	;
	;
