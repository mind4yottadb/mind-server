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
	new %appVersion,%mindParams
	new %logNONE,%logSESSIONS,%logCOMMANDS,%logRESPONSES
	new %TESTMODE,ret
	;
	; store $principal
	set zpout=$principal
	;
	; init terminal
	do set^%mindTerminal
	;
	; init logger
	do initialize^%mindLogger
	;
	; set current version
	set %appVersion=$$getVersionNumber^%mindSocketServer
	;
	; init %mindParams defaults
	set %mindParams("port")=10000
	set %mindParams("min")=1024
	set %mindParams("max")=49151
	set %mindParams("logLevel")=$$convertLevel^%mindLogger("sessions")
	set %mindParams("userCommandsDir")="$ydb_dist/plugin/etc/mind/usercommands"
	set %mindParams("usersFile")="$ydb_dist/plugin/etc/mind/users.json"
	set %mindParams("users")=""
	set %mindParams("commandTimeout")=3000
	set %mindParams("sessionIdleTimeout")=360000
	set %mindParams("zio")=$principal
	set %mindParams("testMode")=0
	;
	; display splash screen
	write !,%mindTrm("bgnd_black"),!
	write %mindTrm("yellow"),"MIND for YottaDB:   ",?30,%mindTrm("light_cyan"),%appVersion,!
	write %mindTrm("yellow"),"YottaDB:   ",?30,%mindTrm("light_cyan"),$zpiece($ZYRELEASE," ",2),!
	write %mindTrm("yellow"),"OS:   ",?30,%mindTrm("light_cyan"),$zpiece($ZYRELEASE," ",3),!
	write %mindTrm("yellow"),"Platform:   ",?30,%mindTrm("light_cyan"),$zpiece($ZYRELEASE," ",4),!
	;
	do drawLine^%mindTerminal(%mindTrm("red"))
	;
	write %mindTrm("green")
	; parse config file
	do parse^%mindConfigFileParser
	;
	; parse params, if any (so, command line params will overwrite defaults AND config file settings)
	do:$get(params)'="" parse^%mindCmdLineParser(params)
	;
	;
	set ret=$$getUsers^%mindUsersParser
	if 'ret  write ! zhalt 1
	zwr %mindParams
	;
	; reset terminal
	write %mindTrm("tty_reset"),!
	;
	; ----------------------------------
	; initiaize socket server
	; ----------------------------------
	goto start^%mindSocketServer
