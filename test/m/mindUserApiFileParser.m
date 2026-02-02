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
UAPI3 	;@test root as object instead of array
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
    do eq^%ut(foundIx>0,1,"")
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
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;
UAPI6 	;@test missing file
    new string,LF,ret,foundIx
    ;
    zsystem "mv $ydb_dist/plugin/etc/mind/user-api.json $ydb_dist/plugin/etc/mind/user-api.json.old.2"
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("User API file: $ydb_dist/plugin/etc/mind/user-api.json not found",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
    zsystem "mv $ydb_dist/plugin/etc/mind/user-api.json.old.2 $ydb_dist/plugin/etc/mind/user-api.json"
    ;
	quit
	;
	;
UAPI7	;@test
    quit
UAPI8	;@test -----------------  Namespace
	quit
UAPI9	;@test
	quit
UAPI10 	;@test name missing in root namespace
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""test"":12}]"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("in root has the following error: No name found",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;
UAPI11 	;@test missing either children, functions or methods
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":12}]"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("you need at least one of the following properties: methods, functions or namespaces",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;
UAPI12 	;@test children as not array
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":12,""children"":{""test"":3}}]"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("children node exists, but is not an array",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;
UAPI13 	;@test functions as not array
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":12,""functions"":{""test"":3}}]"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("function node exists, but is not an array",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;
UAPI14 	;@test methods as not array
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":12,""methods"":{""test"":3}}]"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("methods node exists, but is not an array",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;
UAPI15 	;@test children without a name
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":12,""children"":[{""test"":3}]}]"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("the following error: No name found",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;
UAPI16 	;@test too deeply nested namespaces
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":12,""children"":[{""name"":3,""children"":[{""name"":3,""children"":[{""name"":3}]}]}]}]"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("too many namespaces",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;
UAPI17	;@test
    quit
UAPI18	;@test -----------------  Function
	quit
UAPI19	;@test
	quit
UAPI20 	;@test missing either children, functions or methods
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""banking"",""functions"":["
    set string=string_"""test"":2"
    set string=string_"]}]"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("banking has no entry point",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;
