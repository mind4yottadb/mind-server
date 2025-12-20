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
; This routine process the users
;
getUsers()
    ; returning 0 will abort the init procedure and exit the process
    ;
    new usersFile,string,buffer,level
    ;
	set level=$zlevel
	;
    set usersFile=%mindParams("usersFile")
    if $zsearch(usersFile)="" write !,"FATAL: users file: "_usersFile_" not found! Aborting..." quit 0
    ;
	open usersFile:(read:EXCEPTION="goto usersFileError")
	use usersFile
	;
	for  quit:$zeof  read string set buffer($increment(counter))=string
	;
closeFile
	close usersFile
	;
    do parse^%mindJSON("buffer","jdom","jerr")
    zwr jdom





continueAfterUsersFileError
    quit 1



usersFileError
	new errorNumber
	;
	set errorNumber=$zpiece($zstatus,",",1)
	zgoto:errorNumber=150373082 level:closeFile
	use zpout
	write !,%mindTrm("red"),"WARNING: Error reading configuration file...",!
	write "Filename: ",configFile,!,$zstatus ;"Error:",$zpiece($zstatus,",",6),%mindTrm("white"),!
	zgoto level:continueAfterUsersFileError
    ;
    ;
