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
	new appVersion
	new appParams
	new level
	set level=$zlevel
	;
	; init terminal
	do set^%mindTerminal
	;
	; set current version
	set appVersion="1.0"
	;
	; ----------------------------------
	; process parameters
	; ----------------------------------
	;
	; init appParams
    set appParams("port")=10000
    set appParams("loglevel")="verbose"
    ;
	; look for config file
	set configFile="$ydb_dist/plugin/etc/mind/mind.config"
	open configFile:(read:EXCEPTION="goto configFileError")
	use configFile
	close configFile
    ;
continueAfterConfigFileError
	; parse params, if any (so, command line params will overwrite defaults AND config file settings)
    do:$get(params)'="" parse^%mindCmdLineParser(params)
    ;

    zwr appParams
    ;
	; ----------------------------------
	; process custom commands
	; ----------------------------------
	;


	;	
	;
	; display splash screen
	write !,trm("bgnd_black"),!
	write trm("yellow"),"MIND for YottaDB:   ",?30,trm("light_cyan"),appVersion,!
	write trm("yellow"),"YottaDB:   ",?30,trm("light_cyan"),$zpiece($ZYRELEASE," ",2),!
	write trm("yellow"),"OS:   ",?30,trm("light_cyan"),$zpiece($ZYRELEASE," ",3),!
	write trm("yellow"),"Platform:   ",?30,trm("light_cyan"),$zpiece($ZYRELEASE," ",4),!
	;
	;
	;
	;
	;
	;
	;
	quit
	;
configFileError
    ;
    use $io
    write !,$zstatus,!
    zgoto level:continueAfterConfigFileError