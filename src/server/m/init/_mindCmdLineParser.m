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
; --port=nnn
; --log-level=level
; --log-file=filename
; --help
; --dump-request=value
; --dump-response=value
; --use-tls=value
; --init-only
; --statistics=value
; --error-dump=value
; --uapi-dir=path
; --protocol=value
; --uds-file=filename
;
parse(params,checkHelpOnly) ;
	new paramsA,param,ix,ret,debugMode,found
	new parLeft,parRight
	set checkHelpOnly=$get(checkHelpOnly,0)
	;
	write !
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
	. if parLeft="--version" do dumpVersion goto terminate
	. ; ******************************
	. ; --help
	. ; ******************************
	. if parLeft="--help" do dumpHelp goto terminate
	. ;
	. if checkHelpOnly set ret=0 quit
	. ; ******************************
	. ; --port
	. ; ******************************
	. ; ******************************
	. ; port=value
	. ; ******************************
	. if parLeft="--port" do  quit
	. . if parRight="" write !,%trm("red"),"--port: no port number specified..." goto terminate
	. . if (parRight<%mindParams("min"))!(parRight>%mindParams("max")) write !,%trm("red"),"--port: port number not valid..." goto terminate
	. . set %mindParams("port")=parRight
	. ;
	. ; ******************************
	. ; --log-level value
	. ; ******************************
	. if parLeft="--log-level" do  quit
	. . set found=0
	. . if parRight="" write !,%trm("red"),"--log-level: no log level specified..." goto terminate
	. . set parRight=$zconvert(parRight,"L")
	. . set:$find(%mindParams("logLevels"),parRight) found=1
	. . if found=0 write !,%trm("red"),"--log-level: invalid log level specified..." goto terminate
	. . set %mindParams("logLevel")=$$convertLevel^%mindLogger(parRight)
	. ;
	. ; ******************************
	. ; --log-file
	. ; ******************************
	. if parLeft="--log-file" do  quit
	. . if parRight="" write !,%trm("red"),"--log-file: no path specified..." goto terminate
	. . if $$testFile^%mindLogger(parRight)=0 write !!,%trm("red"),"--log-file: log file could not be opened, defaulting to console.",!! goto terminate
	. . else  set %mindParams("logFile")=parRight
	. ;
	. ; ******************************
	. ; --dump-request
	. ; ******************************
	. if parLeft="--dump-request" do  quit
	. . if parRight="" write !,"--dump-request requires yes or no..." goto terminate
	. . set parRight=$zconvert(parRight,"U")
	. . if parRight'="YES",parRight'="NO" write !,%trm("red"),"--dump-request: only yes and no supported..." goto terminate
	. . set %mindParams("dumpRequest")=$select(parRight="YES":1,1:0)
	. ;
	. ; ******************************
	. ; --dump-response
	. ; ******************************
	. if parLeft="--dump-response" do  quit
	. . if parRight="" write !,"--dump-request requires yes or no..." goto terminate
	. . set parRight=$zconvert(parRight,"U")
	. . if parRight'="YES",parRight'="NO" write !,%trm("red"),"--dump-response: only yes and no supported..." goto terminate
	. . set %mindParams("dumpResponse")=$select(parRight="YES":1,1:0)
	. ;
	. ; ******************************
	. ; --use-tls
	. ; ******************************
	. if parLeft="--use-tls" do  quit
	. . if parRight="" write !,"--dump-request requires yes or no..." goto terminate
	. . set parRight=$zconvert(parRight,"U")
	. . if parRight'="YES",parRight'="NO" write !,%trm("red"),"--use-tls: only yes and no supported..." goto terminate
	. . set %mindParams("useTls")=$select(parRight="YES":1,1:0)
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
	. . if parRight="" write !,%trm("red"),"--statistics requires either off, grand or details..." goto terminate
	. . set parRight=$zconvert(parRight,"U")
	. . if parRight'="OFF",parRight'="GRAND",parRight'="DETAILS" write !,%trm("red"),"--statistics: only off, grand and details supported..." goto terminate
	. . set %mindParams("stats")=$select(parRight="OFF":0,parRight="GRAND":1,1:2)
	. ;
	. ; ******************************
	. ; --error-dump
	. ; ******************************
	. if parLeft="--error-dump" do  quit
	. . if parRight="" write !,%trm("red"),"--error-dump: missing parameter value" goto terminate
	. . set parRight=$zconvert(parRight,"U")
	. . if parRight'="NONE",parRight'="BRIEF",parRight'="EXTENDED" write !,%trm("red"),"--error-dump: only none, brief and extended supported..." goto terminate
	. . set %mindParams("errorDump")=$select(parRight="NONE":0,parRight="BRIEF":1,1:2)
	. ;
	. ; ******************************
	. ; userApiDir=/path/to/dir
	. ; ******************************
	. if parLeft="--uapi-dir" do  quit
	. . if parRight="" write !,"  Warning on line ",ix,": No path specified..." quit
	. . if $zsearch(parRight)="" write !,%trm("red"),"--uapi-dir: Path not found..." goto terminate
	. . set %mindParams("userApiDir")=parRight
	. ;
	. ; ******************************
	. ; --protocol=value
	. ; ******************************
	. if parLeft="--protocol" do  quit
	. . if parRight="" write !,"--protocol requires TCP or UDS..." goto terminate
	. . set parRight=$zconvert(parRight,"U")
	. . if parRight'="TCP",parRight'="UDS" write !,%trm("red"),"--protocol: only TCP and UDS supported..." goto terminate
	. . set %mindParams("protocol")=parRight
	. ;
	. ; ******************************
	. ; --uds-file=filename
	. ; ******************************
	. if parLeft="--uds-file" do  quit
	. . if parRight="" write !,"--uds-file must have a filename..." goto terminate
	. . if $zlength(parRight)<3 write !,%trm("red"),"--uds-file: filename must be longer than 2 character..." goto terminate
	. . set %mindParams("udsFile")=parRight
	. ;
	. ; ******************************
	. ; BAD PARAM
	. ; ******************************
	. if '$zlength(param) set ret=0,param="" write !,"Parameter: ",paramsA(ix)," not supported.",!!,"Quitting",!! goto terminate
	;
	quit
	;
dumpHelp
	write !,"MIND for YottaDB version "_%mindVersion,!
	write !,"Available parameters:"
	write !,"--version)",?25,"Display the software version"
	write !,"--protocol={TCP || UDS})",?25,"Select the transport protocol. Default is TCP"
	write !,"--port={nnn}",?25,"Changes the default socket number (3000)"
	write !,"--uds-file={filename}",?25,"The name of the uds file. Default is mind4yottadb"
	write !,"--log-level={level}",?25,"Select out of: "_%mindParams("logLevels")
	write !,"--log-file={file}",?25,"Sets the file to be used for logging"
	write !,"--dump-request",?25,"Dumps the request command and parameters in the log"
	write !,"--dump-response",?25,"Dumps the response in the log"
	write !,"--use-tls",?25,"Turns on or off the TLS encryption"
	write !,"--statistics={level}",?25,"Select out of off, grand, details"
	write !,"--error-dump={level}",?25,"Select out of none, brief, extended"
	write !,"--uapi-dir=/dir",?25,"override the default uApi dir"
	write !,"--init-only",?25,"Perform initialization ONLY: for debug purposes!!!"
	write !,"--help",?25,"Display this text"
	write !!
	;
	quit
	;
	;
dumpVersion
	write %trm("bgnd_black")
	write %trm("yellow"),"MIND for YottaDB:   ",?30,%trm("light_cyan"),"V"_%mindVersion,!!
	;
	quit
	;
terminate
    write %trm("tty_reset"),!
    ;
    zhalt 22