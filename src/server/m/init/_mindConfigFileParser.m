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
; This routine process the configuration file
;
parse
	new level,string,buffer,counter,ix,line,parLeft,parRight,configFile
	new found
	;
	set level=$zlevel
	;
	; look for config file
	set configFile="$ydb_dist/plugin/etc/mind/mind.conf"
	set configFile=$zsearch(configFile)
	if configFile="" write !,"Configuration file: "_configFile_" not found..." quit
	open configFile:(read:EXCEPTION="goto configFileError")
	use configFile
	;
	for  quit:$zeof  read string set buffer($increment(counter))=string
	;
closeFile
	close configFile
	;
	write !,"Processing conf file: "_configFile
	set ix=0 for  set ix=$order(buffer(ix)) quit:ix=""  do
	. set line=$ztranslate(buffer(ix),$char(13),"")
	. quit:$translate(line," ","")=""
	. quit:$zextract(line,1,1)="#"
	. ;
	. set parLeft=$zconvert($piece(line,"=",1),"L")
	. set parRight=$ztranslate($piece(line,"=",2)," ","")
	. ; ******************************
	. ; port=value
	. ; ******************************
	. if parLeft="port" do  quit
	. . if parRight="" write !,"  Warning on line ",ix,": No port number specified..." quit
	. . if (parRight<%mindParams("min"))!(parRight>%mindParams("max")) write !,"  Warning on line ",ix,": Port number not valid..." quit
	. . set %mindParams("port")=parRight
	. ;
	. ; ******************************
	. ; --log-level value
	. ; ******************************
	. if parLeft="log-level" do  quit
	. . set found=0
	. . if parRight="" write !,"  Warning on line ",ix,": No log level specified..." quit
	. . set parRight=$zconvert(parRight,"L")
	. . set:$find(%mindParams("logLevels"),parRight) found=1
	. . if found=0 write !,"  Warning on line ",ix,": Invalid log level specified..." quit
	. . set %mindParams("logLevel")=$$convertLevel^%mindLogger(parRight)
	. ;
	. ; ******************************
	. ; --logFile value
	. ; ******************************
	. if parLeft="log-file" do  quit
	. . if parRight="" write !,"  Warning on line ",ix,": No path specified..." quit
	. . if $$testFile^%mindLogger(parRight)=0 write !!,"WARNING: Log file could not be opened, defaulting to console.",!! quit
	. . else  set %mindParams("logFile")=parRight
	. ;
	. ; ******************************
	. ; userCommandsDir=/path/to/dir
	. ; ******************************
	. if parLeft="user-commands-dir" do  quit
	. . if parRight="" write !,"  Warning on line ",ix,": No path specified..." quit
	. . if $zsearch(parRight)="" write !,"  Warning on line ",ix,": Path not found..." quit
	. . set %mindParams("userCommandsDir")=parRight
	. ;
	. ; ******************************
	. ; dump-request=YES || NO
	. ; ******************************
	. if parLeft="dump-request" do  quit
	. . set parRight=$zconvert(parRight,"U")
	. . if parRight'="YES",parRight'="NO" write !,"  Warning on line ",ix,": Only YES and NO supported..." quit
	. . set %mindParams("dumpRequest")=$select(parRight="YES":1,1:0)
	. ;
	. ; ******************************
	. ; dump-response=YES || NO
	. ; ******************************
	. if parLeft="dump-response" do  quit
	. . set parRight=$zconvert(parRight,"U")
	. . if parRight'="YES",parRight'="NO" write !,"  Warning on line ",ix,": Only YES and NO supported..." quit
	. . set %mindParams("dumpResponse")=$select(parRight="YES":1,1:0)
	. ;
	. ; ******************************
	. ; statistics=OFF | GRAND | DETAILS
	. ; ******************************
	. if parLeft="statistics" do  quit
	. . set parRight=$zconvert(parRight,"U")
	. . if parRight'="OFF",parRight'="GRAND",parRight'="DETAILS" write !,"  Warning on line ",ix,": Only OFF, GRAND and DETAILS supported..." quit
	. . set %mindParams("stats")=$select(parRight="OFF":0,parRight="GRAND":1,1:2)
	. ;
	. ; ******************************
	. ; error-dump=NONE | BRIEF | EXTENDED
	. ; ******************************
	. if parLeft="error-dump" do  quit
	. . set parRight=$zconvert(parRight,"U")
	. . if parRight'="NONE",parRight'="BRIEF",parRight'="EXTENDED" write !,"  Warning on line ",ix,": Only NONE, BRIEF and EXTENDED supported..." quit
	. . set %mindParams("errorDump")=$select(parRight="NONE":0,parRight="BRIEF":1,1:2)
	. ;
	. ; ******************************
	. ; INVALID ENTRY
	. ; ******************************
	. write !,"  Warning on line ",ix,": Invalid switch..."
	;
	write !,"Conf file processed..."
continueAfterConfigFileError
	quit
	;
	;
configFileError
	new errorNumber
	;
	set errorNumber=$zpiece($zstatus,",",1)
	zgoto:errorNumber=150373082 level:closeFile
	use zpout
	write !,%trm("red"),"WARNING: Error opening configuration file...",!
	write "Filename: ",configFile,!,$zstatus ;"Error:",$zpiece($zstatus,",",6),%trm("white"),!
	zgoto level:continueAfterConfigFileError
    ;
    ;