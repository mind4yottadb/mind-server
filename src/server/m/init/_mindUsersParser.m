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
    new usersFile,string,buffer,level,JDOM,JERR
    ;
	set level=$zlevel
	;
    set usersFile=%mindParams("usersFile")
	;
	write !,"Processing users configuration file: "_%mindParams("usersFile")
	set usersFile=$zsearch(usersFile)
    if usersFile="" write !,"FATAL: users file: "_%mindParams("usersFile")_" not found! Aborting..." quit 0
    ;
	open usersFile:(read:EXCEPTION="goto usersFileError")
	use usersFile
	;
	for  quit:$zeof  read string set buffer($increment(counter))=$ztranslate(string,$char(13),"")
	;
closeFile
	close usersFile
	;
	if $data(buffer)=0 write !,"FATAL: users file is empty!",!,"Aborting..." quit 0
    do parse^%mindJSON("buffer","%mindParams(""users"")","JERR")
    if $data(JERR) do  quit 0
    . write !,"FATAL: users file: "_usersFile_" could not be parsed!"
    . write !,"Error is: ",JERR(1),!,$get(JERR(2))
    . write !,"Aborting..."
    ;
    if $data(%mindParams("users",1,"username"))=0!($data(%mindParams("users",1,"password"))=0) do  quit 0
    . write !,"FATAL: users file: "_usersFile_" has bad content!"
    . write !,"Aborting..."
    ;
    write !,"Users configuration file processed..."
    ;
continueAfterUsersFileError
    quit 1
    ;
    ;
usersFileError
	new errorNumber
	;
	set errorNumber=$zpiece($zstatus,",",1)
	zgoto:errorNumber=150373082 level:closeFile
	use zpout
	write !,%trm("red"),"WARNING: Error reading users configuration file...",!
	write "Filename: ",configFile,!,$zstatus ;"Error:",$zpiece($zstatus,",",6),%trm("white"),!
	zgoto level:continueAfterUsersFileError
    ;
    ;
