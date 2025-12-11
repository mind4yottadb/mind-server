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
; This routine process the socket connection and dispatcher
;
    new zpout
    ;
	set zpout=$principal
	;




start(params)
	new %ydbxiderParams,%ydbxiderTracker,logger,zpout,oneMib
	new logDEBUG,logVERBOSE,logNOTICE,logWARNING,dbg
	;
	; ****************************************
	; mount root error handler
	; ****************************************
	new $etrap
	set $etrap="goto rootErrorHandler^%ydbxiderServer"
	; ****************************************
	; init default parameters
	; ****************************************
	; true if initialize the API layer only, no socket server (can be overridden by the command line of config file)
	set %ydbxiderParams("apiOnly")=0
	;
	; the default port (can be overridden by the command line of config file)
	set %ydbxiderParams("port")=3000
	;
	; the default TLS port
	set %ydbxiderParams("tlsPort")=1302
	;
	; true if TLS is used
	set %ydbxiderParams("tls")=0
	;
	; (can be overridden by the command line of config file)
	; NOTE: these are standard log levels. See file %ydbxiderLogger for details about WHAT is being logged and how
	; debug (a lot of information, useful for development/testing)
	; verbose (many rarely useful info, but not a mess like the debug level)
	; notice (moderately verbose, what you want in production probably)
	; warning (only very important / critical messages are logged)
	; nothing (nothing is logged)
	set %ydbxiderParams("logging")="notice"
	;
	; this will re-initialize the database at startup (before accepting connections) Command line only
	set %ydbxiderParams("resetDb")=0
	;
	; this will start the server without the TTL processor (for debug reasons) (can be overridden by the command line)
	set %ydbxiderParams("noTtl")=0
	;
	; the pool time, in milliseconds, fo the TTL processor
	set %ydbxiderParams("ttlPoolTime")=500
	;
	; this will start the server without the Journal processor (for debug reasons) (can be overridden by the command line)
	set %ydbxiderParams("noJournalSwitch")=0
	;
	; the pool time, in seconds, for the TTL Journal Switch
	; this is NOT the actual switching, which is set in Journaling characteristics
	set %ydbxiderParams("journalSwitchPoolTime")=360
	;
	; the pool time, in seconds, for the Helper process to validate the registered processed and discard them if they died
	set %ydbxiderParams("validateSessionPoolTime")=5
	;
	; socket timeout in microseconds. Value between 1 and 10 us
	set %ydbxiderParams("socketTimeout")=.000003
	;
	; if true, ignores $principal device
	set %ydbxiderParams("testMode")=0
	;
	; if true, session statistics will be collected (affects the overall speed)
	set %ydbxiderParams("sessionStatistics")=0
	;
	;
	; the current version
	set %ydbxiderParams("version")=$$getVersionNumber
	;
	set zpout=$principal
	;
	; ****************************************
	; proceeding with initialization
	; ****************************************
	;
	; -------------------------------------
	; validate parameters and quit if fails
	; -------------------------------------
	; Exit with code 0
	if $zfind(params,"--version")!($zfind(params,"-v")) write !,"YottaDB Xider version "_%ydbxiderParams("version"),!! halt
	; Exit with code 22: Invalid argument
	set:$zlength($get(params))&('$$parse^%ydbxiderServerCmdParser(params)) $ecode=",U254,"
	;
	; ----------------------
	; start dumping messages
	; ----------------------
	write !,"Xider version "_%ydbxiderParams("version")_", pid="_$job_", started"
	write !,"Warning: no config file specified, using the default settings."
	write !,"Running mode=",$select(%ydbxiderParams("apiOnly"):"API only",1:"Socket server + API")
	write !,"Logging="_%ydbxiderParams("logging")
	write:%ydbxiderParams("resetDb") !,"WARNING: the database will be re-initialized !!!"
	write:'%ydbxiderParams("apiOnly") !,"Port=",%ydbxiderParams("port"),!
	write:%ydbxiderParams("testMode")=1 !,">>>TEST MODE",!
	;
	; ****************************************
	; Prepare log constants
	; ****************************************
	set logWARNING=1,logNOTICE=2,logVERBOSE=3,logDEBUG=4
	;
	; and convert the current setting into a number for fast typing / processing
	set dbg=%ydbxiderParams("logging")
	set %ydbxiderParams("logging")=$select(dbg="debug":4,dbg="verbose":3,dbg="notice":2,dbg="warning":1,1:0)
	;
	; -------------
	; Enable CTRL-C
	; -------------
	use $principal:(ctrap=$zchar(3):exception="use $principal write !,""Caught Ctrl-C..."",! do rundown(252)")
	;
	; ----------------------
	; Reset the db if needed
	; ----------------------
	kill:%ydbxiderParams("resetDb") ^%ydbxider,^%ydbxiderK,^%ydbxiderKDT,^%ydbxiderKT
	;
	; ----------------------
	; Initialize the sessions
	; ----------------------
	do initialize^%ydbxiderSessions()
	;
	; ------------------------------------
	; Startup the helper process if needed
	; ------------------------------------
	if '%ydbxiderParams("noTtl")!('%ydbxiderParams("noJournalSwitch")) do
	. ;
	. ; run the Helper process locally, as we don't need a socket server
	. if %ydbxiderParams("apiOnly") do start^%ydbxiderHelper
	. ;
	. else  do
	. . ; spawn a job, as this process is used to listen to socket connection and redirection
	. . job @($select('%ydbxiderParams("testMode"):"start^%ydbxiderHelper:(OUTPUT="""_zpout_""":PASS)",1:"start^%ydbxiderHelper:(PASS)"))
	. . ;
	. . new params
	. . ;
	. . set params("type")="H",params("description")="Helper process"
	. . set params("pid")=$zjob
	. . ; and register its PID for rundown
	. . do add^%ydbxiderSessions(.params)
	else  write !,"Helper process is NOT running"
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
	set jobCommandErrorFile="/tmp/YDBXider"_$job_".stderr"
	set tcpio="SCK$"_%ydbxiderParams("port")
	set quote=""""
	;
	; Open socket
	open tcpio:(listen=%ydbxiderParams("port")_":TCP":delim=$zchar(13,10):attach="server"):0:"socket"
	else  use 0 write !!,"Fatal: Cannot open port "_%ydbxiderParams("port"),!! do rundown(253)
	;
	; set up listen mode
	use tcpio:(chset="M")
	write /listen(5)
	;
	; dump messages
	use $principal
	do:%ydbxiderParams("logging")>=logNOTICE&'%ydbxiderParams("testMode") log^%ydbxiderLogger("Socket Server initialized on port "_%ydbxiderParams("port")),log^%ydbxiderLogger("Ready to accept connections"),log^%ydbxiderLogger("CTRL-C will gracefully terminate the server...")
	;
	use tcpio
	;
loop ; Wait until we have a connection (infinite wait).
	for  write /wait(10) quit:$key]""
	;
	; detach the socket and job off, passing the socket
	do:$zpiece($key,"|")="CONNECT"
	. set childsock=$zpiece($key,"|",2)
	. use tcpio:(detach=childsock)
	. set arg="""SOCKET:"_childsock_""""
	. set job="start^%ydbxiderServerSession:(input="_arg_":output="_arg_":error="_quote_jobCommandErrorFile_quote_":pass:cmd=""start^%ydbxiderSession"")"
	. job @job
	;
	;
	goto loop
	;
	;
rundown(exitCode) ; This is supposed to send SIGUSR1 to children for appropriate rundown, at the moment, it just sends a SIGTERM
	new pid,ret
	;
	use zpout
	;
	write !,"Gracefully running down..."
	;
	set pid="" for  set pid=$order(^%ydbxider("S",pid)) quit:'$zlength(pid)  do
	. do:^%ydbxider("S",pid,"type")="S"!(^%ydbxider("S",pid,"type")="H")
	. . set ret=$zsigproc(pid,"SIGTERM")
	. . write !,?2,"Terminating "_$get(^%ydbxider("S",pid,"description"))_" PID ",pid,"...",?44,"Terminated with code: ",ret
	;
	write !,"Rundown successful, exiting...",!!
	;
	zhalt exitCode
	;
	;
rootErrorHandler ;
	use zpout
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
getVersionNumber() quit "0.4.4"
	;
	;
