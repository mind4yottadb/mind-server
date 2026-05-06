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
UAPI300	;@test
    quit
UAPI301	;@test -----------------  Server code
	quit
UAPI302	;@test
	quit
UAPI303 	;@test code, with bad value
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="{""server"":{""code"":""testaa""}}"
    do writeToUserApiLast^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("testaa does not exists or it is not accessible",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
    quit
    ;
    ;
UAPI304 	;@test code, with bad value
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="{""server"":{""code"":""#$#$@#%testaa""}}"
    do writeToUserApiLast^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("testaa does not exists or it is not accessible",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
    quit
    ;
    ;
UAPI305 	;@test code, with valid dir
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="{""server"":{""code"":""/opt""}}"
    do writeToUserApiLast^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("JSON client root must be an array and/or not",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
    quit
    ;
    ;
UAPI306 	;@test code, with valid dir
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="{""server"":{""code"":""$ydb_dist/plugin/etc/mind/uApi/so""}}"
    do writeToUserApiLast^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("JSON client root must be an array and/or not",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
    quit
    ;
    ;
UAPI307 	;@test code, with valid so
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="{""server"":{""code"":""$ydb_dist/plugin/etc/mind/uApi/so/_mindAppTest.so""}}"
    do writeToUserApiLast^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("JSON client root must be an array and/or not",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
    quit
    ;
    ;
UAPI308 	;@test code, with bad so
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="{""server"":{""code"":""$ydb_dist/plugin/etc/mind/uApi/so/_mindAppTestBad.so""}}"
    do writeToUserApiLast^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("$ydb_dist/plugin/etc/mind/uApi/so/_mindAppTestBad.so is not a valid .so file",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
    quit
    ;
    ;
UAPI309 	;@test code,
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="{""server"":{""code"":""$ydb_dist/plugin/etc/mind/uApi/so/_mindAppTestBad.so""}}"
    do writeToUserApiLast^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    zwr ret
    set foundIx=$$findIndexInArray^%mindTestUtils("$ydb_dist/plugin/etc/mind/uApi/so/_mindAppTestBad.so is not a valid .so file",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
    quit
    ;
    ;
UAPI350	;@test
    quit
UAPI351	;@test -----------------  Server hooks
	quit
UAPI352	;@test
	quit
UAPI353 	;@test code, with bad entry
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="{""server"":{""hooks"":""testaa""}}"
    do writeToUserApiLast^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("JSON client root must be an array and/or not be empty OR must",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
    quit
    ;
    ;
UAPI354 	;@test code, with correct entry, bad value
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="{""server"":{""hooks"":{""onInit"":""aa""}}}"
    do writeToUserApiLast^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("server/hooks/onInit: aa is not a valid entry point name",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
    quit
    ;
    ;
UAPI355 	;@test code, with correct entry, good value
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="{""server"":{""hooks"":{""onInit"":""isDir^%mindUtils""}}}"
    do writeToUserApiLast^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    zwr ret
    set foundIx=$$findIndexInArray^%mindTestUtils("JSON client root must be an array and/or not be empty",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
    quit
    ;
    ;
