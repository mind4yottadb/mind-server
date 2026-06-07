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
start(params)
	; global variables
	new %mindVersion,%mindParams
	new %mindLogNONE,%mindLogSESSIONS,%mindLogCOMMANDS,%mindLogTIMINGS
	new ret,iy,tlsStatus
	new %mindCRLF,LF
	;
	; store $principal
	set zpout=$principal
	;
	write !
	;
	; init terminal
	do set^%mindTerminal
	;
	; init logger
	do initialize^%mindLogger
	;
	; set current version
	set %mindVersion=$$getVersion^%mindVersion()
	;
	; init %mindParams defaults
	set %mindParams("protocol")="TCP"                                   ; current transport protocol in action
	set %mindParams("port")=10000                                       ; TCP port
	set %mindParams("min")=80                                           ; TCP port min value
	set %mindParams("max")=49151                                        ; TCP port max value
	set %mindParams("udsBasePath")="$ydb_dist/plugin/etc/mind/"         ; default base path for UDS
	set %mindParams("udsFile")="mind4yottadb"                           ; default file for UDS
	set %mindParams("useTls")=0                                         ; TLS flag
	set %mindParams("tlsInstalled")=0                                   ; true if tls is installed
	set %mindParams("consoleWidth")=132                                ; the width of the log console line. Does NOT apply to log files
	set %mindParams("logLevel")=$$convertLevel^%mindLogger("commands")  ; current log level
	set %mindParams("logFile")=""                                       ; log file, if present
	set %mindParams("logDevice")=""                                     ; Linux device to be used for logging
	set %mindParams("userApiDir")="$ydb_dist/plugin/etc/mind/uApi"      ; uApi directory (where json and, optionally, m files are)
	set %mindParams("uApiShowFull")=0                                   ; true of display full uApi info on startup
	set %mindParams("uApi")=""                                          ; JDOM of uApi file. AFTER LOGIN get re-merged to current file
	set %mindParams("uApiJson")=""                                      ; JSON of uApi file (to be sent to clients)
	set %mindParams("uApiServer")=""                                    ; uApi server configuration sub-leg "vars", "map","code" and "hooks",then file,
	set %mindParams("uApiDataTypes")=",string,int,float,boolean,object,null,varByRef,json,"
	set %mindParams("uApiPropsDataTypes")=",string,int,float,boolean,"
	set %mindParams("usersFile")="$ydb_dist/plugin/etc/mind/users.json" ; the file that contains users
	set %mindParams("zio")=$principal                                   ; $principal
	set %mindParams("dumpRequest")=0                                    ; option dumpRequest
    set %mindParams("dumpResponse")=0                                   ; option dumpResponse
	set %mindParams("stats")=0                                          ; 0: off 1: only commands totals 2: break down commands stats
	set %mindParams("lstats")=""                                        ; holds the local statistics
	set %mindParams("errorDump")=1                                      ; 0: none 1: only $Zstatus, 2: full
	set %mindParams("initOnly")=0                                       ; if true, it will quit after login
	set %mindParams("serverInfo")=""                                    ; get infos pre-populated, to speed up login
	set %mindParams("zroutines")=""                                     ; original $zroutines, to restore after testing .so and M files
	set %mindParams("serverPid")=""                                     ; process Id of the MIND server
	set %mindParams("idleTimeout")=30                                   ; number of MINUTES of inactivity on the socket before to suicide
	set %mindParams("idleTimeout","ut")=0                               ; $zut/1E6, internally used by idleTimeout
	set %mindParams("idleTimeout","socketTimeout")=60                   ; number of SECONDS to timeout and trigger the ticker
	set %mindParams("SIGUSR2")=00                                       ; true if SIGUSR2 can be processed
	;
	set %mindCRLF=$zchar(13,10),LF=$zchar(10)
	set %mindParams("zroutines")=$zroutines
    ;
	use $principal:width=%mindParams("consoleWidth")
	;
	; if command line switch is --help or --version, process it right away...
    do:$get(params)'="" parse^%mindCmdLineParser(params,1)
    ;
	write %mindTrm("light_magenta"),"Initialization started...",!
    ;
	write %mindTrm("green")
	;
	; -------------------------------
	; parse config file
	; -------------------------------
	do parse^%mindConfigFileParser
	;
	; -------------------------------
	; parse params, if any (so, command line params will overwrite defaults AND config file settings)
	; -------------------------------
	do:$get(params)'="" parse^%mindCmdLineParser(params)
	;
	use $principal:width=%mindParams("consoleWidth")
	;
	; -------------------------------
	; process tls installation
	; -------------------------------
	set tlsStatus("libs")=$zsearch("$ydb_dist/plugin/libgtmcrypt.so",-1)'=""
	set tlsStatus("config")=$zsearch("$ydb_dist/plugin/etc/mind/mind.ydbcrypt",-1)'=""
	if tlsStatus("libs"),tlsStatus("config") set %mindParams("tlsInstalled")=1
	;
    if %mindParams("useTls"),%mindParams("tlsInstalled")=0 do  write %mindTrm("tty_reset"),!! zhalt 32
    . write !,%mindTrm("red")
    . if tlsStatus("libs")=0,tlsStatus("config")=0 write "tls NOT installed" quit
    . write "tls configuration file not found"
    ;
	; -------------------------------
	; parse users file
	; -------------------------------
	if $$getUsers^%mindUsersParser=0  write ! zhalt 1
    ;
	; -------------------------------
	; parse userApi file
	; -------------------------------
	if $$parse^%mindUserApiParser() do  zhalt 1
	. ;reset terminal
    . write %mindTrm("tty_reset"),!!
    ;
	; -------------------------------
	; detect SIGUSR2 and set flag
	; -------------------------------
	set $zinterrupt="set:$zyintrsig=""SIGUSR2"" %mindParams(""SIGUSR2"")=1"
    if $ZSIGPROC($job,"USR2")
    ;
    ; setup the log device
    set %mindParams("logDevice")=$select(%mindParams("logFile")="":$principal,1:%mindParams("logFile"))
    ;
   	write !!,%mindTrm("light_magenta"),"Initialization completed ok"
    ;
	; -------------------------------
    ; display uAPI result
	; -------------------------------
    if $order(%mindParams("uApi",""))'="" do dumpShort^%mindUserApiViewer:%mindParams("uApiShowFull")=0,dumpFull^%mindUserApiViewer:%mindParams("uApiShowFull")=1
    else  write !
    ;
	; -------------------------------
	; display splash screen
	; -------------------------------
	write %mindTrm("bgnd_black"),!
	write %mindTrm("yellow"),"MIND for YottaDB:   ",?35,%mindTrm("light_cyan"),%mindVersion,!
	write %mindTrm("yellow"),"YottaDB:   ",?35,%mindTrm("light_cyan"),$zpiece($ZYRELEASE," ",2),!
	write %mindTrm("yellow"),"OS:   ",?35,%mindTrm("light_cyan"),$zpiece($ZYRELEASE," ",3),!
	write %mindTrm("yellow"),"Platform:   ",?35,%mindTrm("light_cyan"),$zpiece($ZYRELEASE," ",4),!
	;
	;write !!,%mindTrm("white")_"Using the following parameters:",!
	write %mindTrm("yellow")_"PID:",?35,%mindTrm("cyan")_$job,!
	write %mindTrm("yellow")_"Transport protocol:",?35,%mindTrm("cyan")_%mindParams("protocol"),!
	if %mindParams("protocol")="TCP" write %mindTrm("yellow")_"Listen port:",?35,%mindTrm("cyan")_%mindParams("port"),!
	else  write %mindTrm("yellow")_"UDS file:",?35,%mindTrm("cyan")_%mindParams("udsBasePath")_%mindParams("udsFile"),!
	write %mindTrm("yellow")_"Max sockets:",?35,%mindTrm("cyan")_$VIEW("MAX_SOCKETS"),!
	write %mindTrm("yellow")_"Session idle timeout:",?35,%mindTrm("cyan")_$select(%mindParams("idleTimeout")=0:"unlimited",1:%mindParams("idleTimeout")_" mins"),!
	write %mindTrm("yellow")_"Char set:",?35,%mindTrm("cyan")_$zchset,!
	write %mindTrm("yellow")_"Use TLS:",?35,%mindTrm("cyan")_$select(%mindParams("useTls"):"YES",1:$select(%mindParams("tlsInstalled"):"NO",1:"Not installed or configured")),!
	write %mindTrm("yellow")_"Log level:",?35,%mindTrm("cyan")_$$convertLevelNumber^%mindLogger(%mindParams("logLevel")),!
	write %mindTrm("yellow")_"Log to:",?35,%mindTrm("cyan")_$select(%mindParams("logFile")="":"CONSOLE",1:%mindParams("logFile")),!
	if %mindParams("logFile")="" write %mindTrm("yellow")_"Console width:",?35,%mindTrm("cyan")_%mindParams("consoleWidth"),!
	write %mindTrm("yellow")_"Dump requests:",?35,%mindTrm("cyan")_$select(%mindParams("dumpRequest"):"Yes",1:"No"),!
	write %mindTrm("yellow")_"Dump responses:",?35,%mindTrm("cyan")_$select(%mindParams("dumpResponse"):"Yes",1:"No"),!
	write %mindTrm("yellow")_"Statistics:",?35,%mindTrm("cyan")_$select(%mindParams("stats")=1:"Only grand totals",%mindParams("stats")=2:"Detailed",1:"Off"),!
	write %mindTrm("yellow")_"Errors dump:",?35,%mindTrm("cyan")_$select(%mindParams("errorDump")=0:"None",%mindParams("errorDump")=1:"Brief",1:"Extended"),!
	write:%mindParams("initOnly") %mindTrm("yellow")_"Init only:",?35,%mindParams("initOnly"),!
	write %mindTrm("yellow")_"User API dir:",?35,%mindTrm("cyan")_%mindParams("userApiDir"),!
	write %mindTrm("yellow")_"SIGUSR2 available:",?35,%mindTrm("cyan")_$select(%mindParams("SIGUSR2"):"YES",1:"NO"),!
	;
	; reset terminal
	write %mindTrm("tty_reset"),!
	;
	; ----------------------------------
	; initiaize socket server
	; ----------------------------------
	goto:%mindParams("initOnly")=0 start^%mindSocketServer
	;
	halt
