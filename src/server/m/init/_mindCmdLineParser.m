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
	new parLeft,parRight
	;
	; sanitize the string and split it
	set *paramsA=$$SPLIT^%MPIECE($$^%MPIECE(params))
	;
	set (param,ix)="",ret=1
	for  set ix=$order(paramsA(ix)) quit:'$zlength(ix)  do  quit:'ret
	. set parLeft=$zconvert($piece(paramsA(ix),"=",1),"L")
	. set parRight=$ztranslate($piece(paramsA(ix),"=",2)," ","")
	. ;
	. ; ******************************
	. ; --version
	. ; ******************************
	. if parLeft="--version" do dumpVersion zhalt 22
	. ; ******************************
	. ; --help
	. ; ******************************
	. if parLeft="--help" do dumpHelp zhalt 22
	. ;
	. ; ******************************
	. ; --port
	. ; ******************************
	. ; ******************************
	. ; port=value
	. ; ******************************
	. if parLeft="--port" do  quit
	. . if parRight="" write !,"--port: no port number specified..." zhalt 22
	. . if (parRight<%mindParams("min"))!(parRight>%mindParams("max")) write !,"--port: port number not valid..." zhalt 22
	. . set %mindParams("port")=parRight
	. ;
	. ; ******************************
	. ; --log-level value
	. ; ******************************
	. if parLeft="--log-level" do  quit
	. . set found=0
	. . if parRight="" write !,"--log-level: no log level specified..." zhalt 22
	. . set parRight=$zconvert(parRight,"L")
	. . set:$find(%mindParams("logLevels"),parRight) found=1
	. . if found=0 write !,"--log-level: invalid log level specified..." zhalt 22
	. . set %mindParams("logLevel")=$$convertLevel^%mindLogger(parRight)
	. ;
	. ; ******************************
	. ; --log-file
	. ; ******************************
	. if parLeft="--log-file" do  quit
	. . if parRight="" write !,"--log-file: no path specified..." zhalt 22
	. . if $$testFile^%mindLogger(parRight)=0 write !!,"--log-file: log file could not be opened, defaulting to console.",!! zhalt 22
	. . else  set %mindParams("logFile")=parRight
	. ;
	. ; ******************************
	. ; --dump-request
	. ; ******************************
	. if parLeft="--dump-request" do  quit
	. . if parRight="" write !,"--dump-request requires yes or no..." zhalt 22
	. . set parRight=$zconvert(parRight,"U")
	. . if parRight'="YES",parRight'="NO" write !,"--dump-request: only yes and no supported..." zhalt 22
	. . set %mindParams("dumpRequest")=$select(parRight="YES":1,1:0)
	. ;
	. ; ******************************
	. ; --init-only
	. ; ******************************
	. if paramsA(ix)="--init-only" set param="",%mindParams("initOnly")=1 quit
	. ;
	. ; ******************************
	. ; --statistics
	. ; ******************************
	. if parLeft="--statistics" do  quit
	. . if parRight="" write !,"--statistics requires either off, grand or details..." zhalt 22
	. . set parRight=$zconvert(parRight,"U")
	. . if parRight'="OFF",parRight'="GRAND",parRight'="DETAILS" write !,"--statistics: only off, grand and details supported..." zhalt 22
	. . set %mindParams("stats")=$select(parRight="OFF":0,parRight="GRAND":1,1:2)
	. ;
	. ; ******************************
	. ; --error-dump
	. ; ******************************
	. if parLeft="--error-dump" do  quit
	. . if parRight="" write !,"--error-dump: missing parameter value" zhalt 22
	. . set parRight=$zconvert(parRight,"U")
	. . if parRight'="NONE",parRight'="BRIEF",parRight'="EXTENDED" write !,"--error-dump: only none, brief and extended supported..." zhalt 22
	. . set %mindParams("errorDump")=$select(parRight="NONE":0,parRight="BRIEF":1,1:2)
	. ;
	. ; ******************************
	. ; BAD PARAM
	. ; ******************************
	. if '$zlength(param) set ret=0,param="" write !,"Parameter: ",paramsA(ix)," not supported.",!!,"Quitting",!! goto terminate
	;
	;
dumpHelp
	write !,"MIND for YottaDB version "_%mindVersion,!
	write !,"Available parameters:"
	write !,"--version)",?25,"Display the software version"
	write !,"--port={nnn}",?25,"Changes the default socket number (3000)"
	write !,"--log-level={level}",?25,"Select out of: "_%mindParams("logLevels")
	write !,"--log-file={file}",?25,"Sets the file to be used for logging"
	write !,"--dump-request",?25,"Dumps the request command and parameters in the log"
	write !,"--statistics={level}",?25,"Select out of off, grand, details"
	write !,"--error-dump={level}",?25,"Select out of none, brief, extended"
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
terminate
    write %trm("tty_reset"),!
    zhalt 1