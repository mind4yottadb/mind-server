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
parse
    new level,userApiFile
    new counter,buffer

	set level=$zlevel
	;
	; look for config file
	set configFile="$ydb_dist/plugin/etc/mind/user-api.json"
	set userApiFile=$zsearch(configFile)
	if userApiFile="" write !,"User API file: "_configFile_" not found..." quit
	open userApiFile:(read:EXCEPTION="goto userApiError")
	use userApiFile
	;
	for  quit:$zeof  read string set buffer($increment(counter))=string
	;
closeFile
	close userApiFile
	;
	write !,"Processing user-api file: "_configFile
    ;
    ; parse the json








	write !,"user-api file processed..."

continueAfterUserApiFileError
    quit
    ;
userApiError
	new errorNumber
	;
	set errorNumber=$zpiece($zstatus,",",1)
	zgoto:errorNumber=150373082 level:closeFile
	use zpout
	write !,%trm("red"),"WARNING: Error opening userApi file...",!
	write "Filename: ",configFile,!,$zstatus ;"Error:",$zpiece($zstatus,",",6),%trm("white"),!
	zgoto level:continueAfterUserApiFileError
    ;
    ;





