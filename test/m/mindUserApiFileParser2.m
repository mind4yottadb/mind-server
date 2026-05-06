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
