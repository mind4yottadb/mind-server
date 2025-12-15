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
	new %appVersion,%appParams
	new %logNONE,%logSESSIONS,%logCOMMANDS,%logRESPONSES
	new zpout
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
	; init %appParams defaults
	set %appParams("port")=10000
	set %appParams("min")=1024
	set %appParams("max")=49151
	set %appParams("logLevel")=$$convertLevel^%mindLogger("sessions")
	set %appParams("userCommandsDir")="$ydb_dist/plugin/etc/mind/usercommands"
	set %appParams("commandTimeout")=3000
	set %appParams("sessionIdleTimeout")=360000
	set %appParams("zio")=$principal
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
	zwr %appParams
	;
	; ----------------------------------
	; initiaize socket
	; ----------------------------------
	;
	write %mindTrm("tty_reset"),!
	;
	goto start^%mindSocketServer
	;
	;
	;
	;
	;
	;
	;
	;
	;
	;
	;
