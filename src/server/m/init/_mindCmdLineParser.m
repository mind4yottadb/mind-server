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
; --log-level level
; --log-file filename
; --help
; --dump-request value
; --init-only
; --statistics value
; --error-dump value
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
	. ; --log-level
	. ; ******************************
	. if paramsA(ix)="--log-level" set param="--log-level" quit
	. ;
	. ; ******************************
	. ; --log-file
	. ; ******************************
	. if paramsA(ix)="--log-file" set param="--log-file" quit
	. ;
	. ; ******************************
	. ; --dump-request
	. ; ******************************
	. if paramsA(ix)="--dump-request" set param="",%mindParams("dumpRequest")=1 quit
	. ;
	. ; ******************************
	. ; --init-only
	. ; ******************************
	. if paramsA(ix)="--init-only" set param="",%mindParams("initOnly")=1 quit
	. ;
	. ; ******************************
	. ; --statistics
	. ; ******************************
	. if paramsA(ix)="--statistics" set param="--statistics" quit
	. ;
	. ; ******************************
	. ; --error-dump
	. ; ******************************
	. if paramsA(ix)="--error-dump" set param="--error-dump" quit
	. ;
	. ; ******************************
	. ; BAD PARAM
	. ; ******************************
	. if '$zlength(param) set ret=0,param="" write !,"Parameter: ",paramsA(ix)," not supported.",!!,"Quitting",!! zhalt 1
	. ;
	. ; ******************************
	. ; --port value
	. ; ******************************
	. if +paramsA(ix)>(%mindParams("min")-1),+paramsA(ix)<(%mindParams("max")+1),(param="--port") set %mindParams("port")=paramsA(ix),param=""
	. ;
	. ; ******************************
	. ; --log-level value
	. ; ******************************
	. if param="--log-level" do  set param=""
	. . set found=0 set:$find(%mindParams("logLevels"),paramsA(ix)) found=1
	. . if 'found set ret=0 write !,"Parameter: ",paramsA(ix)," not supported.",!!,"Quitting",!! zhalt 1
	. . set %mindParams("logLevel")=$$convertLevel^%mindLogger(paramsA(ix))
	. ;
	. ; ******************************
	. ; --log-file value
	. ; ******************************
	. if param="--log-file" do  set param=""
	. . if $$testFile^%mindLogger(paramsA(ix))=0 write !!,"WARNING: Log file could not be opened, defaulting to console.",!! quit
	. . set %mindParams("logFile")=paramsA(ix)
	. ;
	. ; ******************************
	. ; --statistics value
	. ; ******************************
	. if param="--statistics" do  set param=""
	. . set paramsA(ix)=$zconvert(paramsA(ix),"L")
	. . if paramsA(ix)'="off",paramsA(ix)'="grand",paramsA(ix)'="details" write !,"Parameter: ",paramsA(ix)," not supported.",!!,"Quitting",!! zhalt 1
	. . set %mindParams("stats")=$select(paramsA(ix)="off":0,paramsA(ix)="grand":1,1:2)
	. ;
	. ; ******************************
	. ; --error-dump value
	. ; ******************************
	. if param="--error-dump" do  set param=""
	. . set paramsA(ix)=$zconvert(paramsA(ix),"L")
	. . if paramsA(ix)'="none",paramsA(ix)'="brief",paramsA(ix)'="extended" write !,"Parameter: ",paramsA(ix)," not supported.",!!,"Quitting",!! zhalt 1
	. . set %mindParams("errorDump")=$select(paramsA(ix)="none":0,paramsA(ix)="brief":1,1:2)
	;
	if $zlength(param) set ret=0 write !,"Parameter for "_param_" not specified or invalid.",!!,"Quitting",!!
	;
	zhalt:ret=0 0
	;
	quit
	;
	;
dumpHelp
	write !,"MIND for YottaDB version "_%mindVersion,!
	write !,"Available parameters:"
	write !,"--version)",?25,"Display the software version"
	write !,"--port {nnn}",?25,"Changes the default socket number (3000)"
	write !,"--log-level {level}",?25,"Select out of: "_%mindParams("logLevels")
	write !,"--log-file {file}",?25,"Sets the file to be used for logging"
	write !,"--dump-request",?25,"Dumps the request command and parameters in the log"
	write !,"--statistics {level}",?25,"Select out of off, grand, details"
	write !,"--error-dump {level}",?25,"Select out of none, brief, extended"
	write !,"--help",?25,"Display this text"
	write !!
	;
	quit
	;
	;
dumpVersion
	write !,%trm("bgnd_black"),!
	write %trm("yellow"),"MIND for YottaDB:   ",?30,%trm("light_cyan"),%mindVersion,!!
	;
	quit
	;
