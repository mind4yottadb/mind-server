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
; This routine process the command line switches
;
; SUPPORTED PARAMETERS:
; --version
; --port nnn
; --loglevel level
; --help
;
parse(params) ;
	new paramsA,param,ix,ret,debugMode,found
	;
	; sanitize the string and split it
	set *paramsA=$$SPLIT^%MPIECE($$^%MPIECE(params))
	;
	set (param,ix)="",ret=1
	for  set ix=$order(paramsA(ix)) quit:'$zlength(ix)  do  quit:'ret
	. ; ******************************
	. ; --version
	. ; ******************************
	. if paramsA(ix)="--version" do dumpVersion zhalt 0
	. ; ******************************
	. ; --help
	. ; ******************************
	. if paramsA(ix)="--help" do dumpHelp zhalt 0
	. ;
	. ; ******************************
	. ; --port
	. ; ******************************
	. if paramsA(ix)="--port" set param="--port" quit
	. ;
	. ; ******************************
	. ; --loglevel
	. ; ******************************
	. if paramsA(ix)="--loglevel" set param="--loglevel" quit
	. ;
	. ; ******************************
	. ; BAD PARAM
	. ; ******************************
	. if '$zlength(param) set ret=0,param="" write !,"Parameter: ",paramsA(ix)," not supported.",!!,"Quitting",!! quit
	. ;
	. ; ******************************
	. ; --port value
	. ; ******************************
	. set:+paramsA(ix)>0&(param="--port") appParams("port")=paramsA(ix),param=""
	. ;
	. ; ******************************
	. ; --loglevel value
	. ; ******************************
	. if param="--loglevel" do  set param=""
	. . set found=0 for debugMode="none","sessions","commands","responses" set:paramsA(ix)=debugMode found=1 quit:found
	. . if 'found set ret=0 write !,"Parameter: ",paramsA(ix)," not supported.",!!,"Quitting",!! quit
	. . set appParams("logLevel")=paramsA(ix)
	;
	if $zlength(param) set ret=0 write !,"Parameter for "_param_" not specified or invalid.",!!,"Quitting",!!
	;
	zhalt:ret=0 0
	;
	quit
	;
	;
dumpHelp
	write !,"MIND for YottaDB version "_appVersion,!
	write !,"Available parameters:"
	write !,"--version)",?25,"Display the software version"
	write !,"--port {nnn}",?25,"Changes the default socket number (3000)"
	write !,"--loglevel {level}",?25,"Select out of: none, sessions, commands, responses"
	write !,"--help",?25,"Display this text"
	write !!
	;
	quit
	;
	;
dumpVersion
	write !,trm("bgnd_black"),!
	write trm("yellow"),"MIND for YottaDB:   ",?30,trm("light_cyan"),appVersion,!!
    ;
    quit
