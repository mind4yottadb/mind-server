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
	new ret,iy
	new %mindCRLF,LF
	;
	; store $principal
	set zpout=$principal
	use $principal:width=132
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
	set %mindParams("logLevel")=$$convertLevel^%mindLogger("commands")  ; current log level
	set %mindParams("logFile")=""                                       ; log file, if present
	set %mindParams("logDevice")=""                                     ; Linux device to be used for logging
	set %mindParams("userApiDir")="$ydb_dist/plugin/etc/mind/uApi"      ; uApi directory (where json and, optionally, m files are)
	set %mindParams("uApiShowFull")=0                                   ; true of display full uApi info on startup
	set %mindParams("uApi")=""                                          ; JDOM of uApi file. AFTER LOGIN get re-merged to current file
	set %mindParams("uApiJson")=""                                      ; JSON of uApi file (to be sent to clients)
	set %mindParams("uApiServer")=""                                    ; uApi server configuration sub-leg "vars", "code" and "hooks",then file,
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
	set %mindParams("serverInfo")=""                                    ; get later pre-populated, to speed up login
	set %mindParams("zroutines")=""                                     ; original $zroutines, to restore after testing .so and M files
	set %mindParams("serverPid")=""                                     ; process Id of the MIND server
	;
	set %mindCRLF=$zchar(13,10),LF=$zchar(10)
	set %mindParams("zroutines")=$zroutines
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
	write %mindTrm("yellow"),"MIND for YottaDB:   ",?30,%mindTrm("light_cyan"),%mindVersion,!
	write %mindTrm("yellow"),"YottaDB:   ",?30,%mindTrm("light_cyan"),$zpiece($ZYRELEASE," ",2),!
	write %mindTrm("yellow"),"OS:   ",?30,%mindTrm("light_cyan"),$zpiece($ZYRELEASE," ",3),!
	write %mindTrm("yellow"),"Platform:   ",?30,%mindTrm("light_cyan"),$zpiece($ZYRELEASE," ",4),!
	;
	;write !!,%mindTrm("white")_"Using the following parameters:",!
	write %mindTrm("yellow")_"PID:",?30,%mindTrm("cyan")_$job,!
	write %mindTrm("yellow")_"Transport protocol:",?30,%mindTrm("cyan")_%mindParams("protocol"),!
	if %mindParams("protocol")="TCP" write %mindTrm("yellow")_"Listen port:",?30,%mindTrm("cyan")_%mindParams("port"),!
	else  write %mindTrm("yellow")_"UDS file:",?30,%mindTrm("cyan")_%mindParams("udsBasePath")_%mindParams("udsFile"),!
	write %mindTrm("yellow")_"Max sockets:",?30,%mindTrm("cyan")_$VIEW("MAX_SOCKETS"),!
	write %mindTrm("yellow")_"Char set:",?30,%mindTrm("cyan")_$zchset,!
	write %mindTrm("yellow")_"Use TLS:",?30,%mindTrm("cyan")_$select(%mindParams("useTls"):"YES",1:"NO"),!
	write %mindTrm("yellow")_"Log level:",?30,%mindTrm("cyan")_$$convertLevelNumber^%mindLogger(%mindParams("logLevel")),!
	write %mindTrm("yellow")_"Log to:",?30,%mindTrm("cyan")_$select(%mindParams("logFile")="":"CONSOLE",1:%mindParams("logFile")),!
	write %mindTrm("yellow")_"Dump requests:",?30,%mindTrm("cyan")_$select(%mindParams("dumpRequest"):"Yes",1:"No"),!
	write %mindTrm("yellow")_"Dump responses:",?30,%mindTrm("cyan")_$select(%mindParams("dumpResponse"):"Yes",1:"No"),!
	write %mindTrm("yellow")_"Statistics:",?30,%mindTrm("cyan")_$select(%mindParams("stats")=1:"Only grand totals",%mindParams("stats")=2:"Detailed",1:"Off"),!
	write %mindTrm("yellow")_"Errors dump:",?30,%mindTrm("cyan")_$select(%mindParams("errorDump")=0:"None",%mindParams("errorDump")=1:"Brief",1:"Extended"),!
	write:%mindParams("initOnly") %mindTrm("yellow")_"Init only:",?30,%mindParams("initOnly"),!
	write %mindTrm("yellow")_"User API dir:",?30,%mindTrm("cyan")_%mindParams("userApiDir"),!
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
