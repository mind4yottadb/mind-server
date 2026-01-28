;#################################################################
;#                                                               #
;# Copyright (c) 2026 DnaSoft B.V. and/or its subsidiaries.      #
;# All rights reserved.                                          #
;#                                                               #
;#   This source code contains the intellectual property         #
;#   of its copyright holder(s), and is made available           #
;#   under a license.  If you do not know the terms of           #
;#   the license, please stop and do not read further.           #
;#                                                               #
;#################################################################
;
mindUsersFile
	; Requires M-Unit
	;
test if $text(^%ut)="" quit
	do en^%ut($text(+0),3)
	;
	write !
	;
	quit
	;
STARTUP
	do backupUsersFile^%mindTestUtils
	write !,"Backup created..."
	;
	quit
	;
	;
SHUTDOWN
	do restoreUsersFile^%mindTestUtils
	write !!,"Backup restored..."
	;
	quit
	;
	;
NOTEX0	;@test
    quit
NOTEX1	;@test -----------------  Users file
	quit
NOTEX2	;@test
	quit
NOTEX3 	;@test when file doesn't exists
    zsystem "mv $ydb_dist/plugin/etc/mind/users.json  $ydb_dist/plugin/etc/mind/users.json.tmp"
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Processing users configuration file",.ret)
    ;
    do eq^%ut(ret(foundIx+1),"FATAL: users file: $ydb_dist/plugin/etc/mind/users.json not found! Aborting...","should detect missing file")
    ;
	quit
	;
	;
NOTEX4 	;@test when file is empty
    new file
    ;
    set file="$ydb_dist/plugin/etc/mind/users.json"
    open file
    use file
    close file
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Processing users configuration file",.ret)
    ;
    do eq^%ut(ret(foundIx+1),"FATAL: users file is empty!","should detect missing file")
    ;
	quit
	;
	;
NOTEX5 	;@test when file has bad json
    new file
    ;
    set file="$ydb_dist/plugin/etc/mind/users.json"
    open file
    use file
    write "[{""username"": ""admin"",""password"": ""admin""}]"
    close file
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Processing users configuration file",.ret)
    ;
    do eq^%ut(ret(foundIx+1),"Users configuration file processed...")
    ;
	quit
	;
	;
