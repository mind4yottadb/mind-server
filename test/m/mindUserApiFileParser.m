;#################################################################
;#                                                               #
;# Copyright (c) 2025-2026 DnaSoft B.V. and/or its subsidiaries. #
;# All rights reserved.                                          #
;#                                                               #
;#   This source code contains the intellectual property         #
;#   of its copyright holder(s), and is made available           #
;#   under a license.  If you do not know the terms of           #
;#   the license, please stop and do not read further.           #
;#                                                               #
;#################################################################
;
File
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
	; init terminal
   	do set^%mindTerminal
   	;
    do backupUserApiFile^%mindTestUtils
	write !,"Backup created..."
	;
	quit
	;
	;
SHUTDOWN
	do restoreUserApiFile^%mindTestUtils
	write !!,"Backup restored..."
	;
	quit
	;
	;
UAPI0	;@test
    quit
UAPI1	;@test -----------------  Empty or bad JSON
	quit
UAPI2	;@test
	quit
UAPI3 	;@test bad json
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="{""test"":2}"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("WARNING: JSON root must be an array...",.ret)
    ;
    do eq^%ut(foundIx>0,1,"should have no dump inbetween")
    ;
	quit
	;
	;
UAPI4 	;@test empty json
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="{}"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("WARNING: File does not contain any JSON data",.ret)
    ;
    do eq^%ut(foundIx>0,1,"should have no dump inbetween")
    ;
	quit
	;
	;
UAPI5 	;@test empty file
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string=""
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("WARNING: File does not contain any JSON data",.ret)
    ;
    do eq^%ut(foundIx>0,1,"should have no dump inbetween")
    ;
	quit
	;
	;
UAPI6 	;@test missing file
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    zsystem "mv $ydb_dist/plugin/etc/mind/user-api.json $ydb_dist/plugin/etc/mind/user-api.json.old.2"
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("User API file: $ydb_dist/plugin/etc/mind/user-api.json not found",.ret)
    ;
    do eq^%ut(foundIx>0,1,"should have no dump inbetween")
    ;
    zsystem "mv $ydb_dist/plugin/etc/mind/user-api.json.old.2 $ydb_dist/plugin/etc/mind/user-api.json"
    ;
	quit
	;
	;
