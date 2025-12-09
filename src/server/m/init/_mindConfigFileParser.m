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
    new level,string,buffer,counter,ix,line
    ;
    set level=$zlevel
    ;
	; look for config file
	set configFile="$ydb_dist/plugin/etc/mind/mind.config"
	write !,"opening file: "_configFile
	open configFile:(read:EXCEPTION="goto configFileError")
	use configFile
    ;
	for  quit:$zeof  read string set buffer($increment(counter))=string
    ;
closeFile
	close configFile
	;
	write !,"Processing file"
	set ix=0 for  set ix=$order(buffer(ix)) quit:ix=""  do
	. set line=buffer(ix)
	. ;write !,"-"_line_"-"
	. quit:$ztranslate($translate(line," ",""),$char(13),"")=""
	. quit:$zextract(line,1,1)="#"
	. write !,line
    ;
	write !,"File processed",!
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
    write !,trm("red"),"WARNING: Error reading configuration file...",!
    write "Filename: ",configFile,!,$zstatus ;"Error:",$zpiece($zstatus,",",6),trm("white"),!
    zgoto level:continueAfterConfigFileError