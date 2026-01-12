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
	new %logNONE,%logSESSIONS,%logCOMMANDS,%logRESPONSES
	new %TESTMODE,ret
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
	set %mindVersion="0.7.0"
	;
	; init %mindParams defaults
	set %mindParams("port")=10000
	set %mindParams("min")=1024
	set %mindParams("max")=49151
	set %mindParams("logLevel")=$$convertLevel^%mindLogger("sessions")
	set %mindParams("logFile")=""
	set %mindParams("logDevice")=""
	set %mindParams("userCommandsDir")="$ydb_dist/plugin/etc/mind/usercommands"
	set %mindParams("usersFile")="$ydb_dist/plugin/etc/mind/users.json"
	set %mindParams("users")=""
	set %mindParams("zio")=$principal
	set %mindParams("dumpRequest")=0
	set %mindParams("stats")=0                          ; 0: off 1: only commands totals 2: break down commands stats
	;
	;do drawLine^%mindTerminal(%trm("red"))
	;
	write %trm("green")
	; parse config file
	do parse^%mindConfigFileParser
	;
	; parse params, if any (so, command line params will overwrite defaults AND config file settings)
	do:$get(params)'="" parse^%mindCmdLineParser(params)
	;
	if $$getUsers^%mindUsersParser=0  write ! zhalt 1
    ;
    ; setup the log device
    set %mindParams("logDevice")=$select(%mindParams("logFile")="":$principal,1:%mindParams("logFile"))
    ;
	;write !
	;zwr %mindParams
	;
	; display splash screen
	write !,%trm("bgnd_black"),!
	write %trm("yellow"),"MIND for YottaDB:   ",?30,%trm("light_cyan"),%mindVersion,!
	write %trm("yellow"),"YottaDB:   ",?30,%trm("light_cyan"),$zpiece($ZYRELEASE," ",2),!
	write %trm("yellow"),"OS:   ",?30,%trm("light_cyan"),$zpiece($ZYRELEASE," ",3),!
	write %trm("yellow"),"Platform:   ",?30,%trm("light_cyan"),$zpiece($ZYRELEASE," ",4),!
	write !
	;
	;write !!,%trm("white")_"Using the following parameters:",!
	write %trm("yellow")_"Listen port:",?30,%trm("cyan")_%mindParams("port"),!
	write %trm("yellow")_"Log level:",?30,%trm("cyan")_$$convertLevelNumber^%mindLogger(%mindParams("logLevel")),!
	write %trm("yellow")_"Log to:",?30,%trm("cyan")_$select(%mindParams("logFile")="":"CONSOLE",1:%mindParams("logFile")),!
	write %trm("yellow")_"Users command dir:",?30,%trm("cyan")_%mindParams("userCommandsDir"),!
	write %trm("yellow")_"Dump requests:",?30,%trm("cyan")_$select(%mindParams("dumpRequest"):"YES",1:"NO"),!
	write %trm("yellow")_"Statistics:",?30,%trm("cyan")_$select(%mindParams("stats")=1:"Only grand totals",%mindParams("stats")=2:"Detailed",1:"Off"),!
	write !
	;
	; reset terminal
	write %trm("tty_reset"),!
	;
	; ----------------------------------
	; initiaize socket server
	; ----------------------------------
	goto start^%mindSocketServer
