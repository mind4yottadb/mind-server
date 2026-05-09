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
	new parLeft,parRight,quitFlag
	;
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
	. ; --help -- version
	. ; ******************************
	. set quitFlag=0
	. if checkHelpOnly do  if quitFlag goto terminate else  quit
	. . if parLeft="--help" do dumpHelp set quitFlag=1
	. . if parLeft="--version" do dumpVersion set quitFlag=1
	. ;
	. if checkHelpOnly set ret=0 quit
	. ; ******************************
	. ; --port
	. ; ******************************
	. ; ******************************
	. ; port=value
	. ; ******************************
	. if parLeft="--port" do  quit
	. . if parRight="" write !,%mindTrm("red"),"--port: no port number specified..." goto terminate
	. . if (parRight<%mindParams("min"))!(parRight>%mindParams("max")) write !,%mindTrm("red"),"--port: port number not valid..." goto terminate
	. . set %mindParams("port")=parRight
	. ;
	. ; ******************************
	. ; --log-level value
	. ; ******************************
	. if parLeft="--log-level" do  quit
	. . set found=0
	. . if parRight="" write !,%mindTrm("red"),"--log-level: no log level specified..." goto terminate
	. . set parRight=$zconvert(parRight,"L")
	. . set:$find(%mindParams("logLevels"),","_parRight_",") found=1
	. . if found=0 write !,%mindTrm("red"),"--log-level: invalid log level specified..." goto terminate
	. . set %mindParams("logLevel")=$$convertLevel^%mindLogger(parRight)
	. ;
	. ; ******************************
	. ; --log-file
	. ; ******************************
	. if parLeft="--log-file" do  quit
	. . if parRight="" write !,%mindTrm("red"),"--log-file: no path specified..." goto terminate
	. . if $$openFile^%mindLogger(parRight)=0 write !!,%mindTrm("red"),"--log-file: log file could not be opened, defaulting to console.",!!
	. . else  set %mindParams("logFile")=parRight
	. ;
	. ; ******************************
	. ; --dump-request
	. ; ******************************
	. if parLeft="--dump-request" do  quit
	. . if parRight="" write !,"--dump-request requires yes or no..." goto terminate
	. . set parRight=$zconvert(parRight,"U")
	. . if parRight'="YES",parRight'="NO" write !,%mindTrm("red"),"--dump-request: only yes and no supported..." goto terminate
	. . set %mindParams("dumpRequest")=$select(parRight="YES":1,1:0)
	. ;
	. ; ******************************
	. ; --dump-response
	. ; ******************************
	. if parLeft="--dump-response" do  quit
	. . if parRight="" write !,"--dump-request requires yes or no..." goto terminate
	. . set parRight=$zconvert(parRight,"U")
	. . if parRight'="YES",parRight'="NO" write !,%mindTrm("red"),"--dump-response: only yes and no supported..." goto terminate
	. . set %mindParams("dumpResponse")=$select(parRight="YES":1,1:0)
	. ;
	. ; ******************************
	. ; --use-tls
	. ; ******************************
	. if parLeft="--use-tls" do  quit
	. . if parRight="" write !,"--dump-request requires yes or no..." goto terminate
	. . set parRight=$zconvert(parRight,"U")
	. . if parRight'="YES",parRight'="NO" write !,%mindTrm("red"),"--use-tls: only yes and no supported..." goto terminate
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
	. . if parRight="" write !,%mindTrm("red"),"--statistics requires either off, grand or details..." goto terminate
	. . set parRight=$zconvert(parRight,"U")
	. . if parRight'="OFF",parRight'="GRAND",parRight'="DETAILS" write !,%mindTrm("red"),"--statistics: only off, grand and details supported..." goto terminate
	. . set %mindParams("stats")=$select(parRight="OFF":0,parRight="GRAND":1,1:2)
	. ;
	. ; ******************************
	. ; --error-dump
	. ; ******************************
	. if parLeft="--error-dump" do  quit
	. . if parRight="" write !,%mindTrm("red"),"--error-dump: missing parameter value" goto terminate
	. . set parRight=$zconvert(parRight,"U")
	. . if parRight'="NONE",parRight'="BRIEF",parRight'="EXTENDED" write !,%mindTrm("red"),"--error-dump: only none, brief and extended supported..." goto terminate
	. . set %mindParams("errorDump")=$select(parRight="NONE":0,parRight="BRIEF":1,1:2)
	. ;
	. ; ******************************
	. ; userApiDir=/path/to/dir
	. ; ******************************
	. if parLeft="--uapi-dir" do  quit
	. . if parRight="" write !,"  Warning on line ",ix,": No path specified..." goto terminate
	. . if $zsearch(parRight,-1)="" write !,%mindTrm("red"),"--uapi-dir: Path not found..." goto terminate
	. . if $$isDir^%mindUtils(parRight)=0 write !,%mindTrm("red"),"--uapi-dir: Path is not a directory..." goto terminate
	. . set %mindParams("userApiDir")=parRight
	. ;
	. ; ******************************
	. ; --protocol=value
	. ; ******************************
	. if parLeft="--protocol" do  quit
	. . if parRight="" write !,"--protocol requires TCP or UDS..." goto terminate
	. . set parRight=$zconvert(parRight,"U")
	. . if parRight'="TCP",parRight'="UDS" write !,%mindTrm("red"),"--protocol: only TCP and UDS supported..." goto terminate
	. . set %mindParams("protocol")=parRight
	. ;
	. ; ******************************
	. ; --uds-file=filename
	. ; ******************************
	. if parLeft="--uds-file" do  quit
	. . if parRight="" write !,"--uds-file must have a filename..." goto terminate
	. . if $zlength(parRight)<3 write !,%mindTrm("red"),"--uds-file: filename must be longer than 2 character..." goto terminate
	. . set %mindParams("udsFile")=parRight
	. ;
	. ; ******************************
	. ; --show-app-details
	. ; ******************************
	. if parLeft="--show-app-details" set %mindParams("uApiShowFull")=1 quit
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
	write !,"--version)",?30,"Display the software version"
	write !,"--protocol={TCP || UDS})",?30,"Select the transport protocol. Default is TCP"
	write !,"--port={nnn}",?30,"Changes the default socket number (3000)"
	write !,"--uds-file={filename}",?30,"The name of the uds file. Default is mind4yottadb"
	write !,"--log-level={level}",?30,"Select out of: "_%mindParams("logLevels")
	write !,"--log-file={file}",?30,"Sets the file to be used for logging"
	write !,"--dump-request={yes || no}",?30,"Dumps the request command and parameters in the log"
	write !,"--dump-response={yes || no}",?30,"Dumps the response in the log"
	write !,"--use-tls={yes || no}",?30,"Turns on or off the TLS encryption"
	write !,"--statistics={level}",?30,"Select out of off, grand, details"
	write !,"--error-dump={level}",?30,"Select out of none, brief, extended"
	write !,"--uapi-dir=/dir",?30,"override the default uApi dir"
	write !,"--show-app-details",?30,"Display detailed information about the uAPI apps found"
	write !,"--init-only",?30,"Perform initialization ONLY: for debug purposes!!!"
	write !,"--help",?30,"Display this text"
	write !!
	;
	quit
	;
	;
dumpVersion
	write %mindTrm("bgnd_black")
	write %mindTrm("yellow"),"MIND for YottaDB:   ",?30,%mindTrm("light_cyan"),"V"_%mindVersion,!!
	;
	quit
	;
terminate
    write %mindTrm("tty_reset"),!
    ;
    zhalt 22