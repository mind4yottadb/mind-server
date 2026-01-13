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
mindConfigFileParser
	; Requires M-Unit
	;
test if $text(^%ut)="" quit
	do en^%ut($text(+0),3)
	;
	write !
	;
	quit
	;
PORT0	;@test
    quit
PORT1	;@test -----------------  --port     -
	quit
PORT2	;@test
	quit
PORT3 	;@test comments and empty lines
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    do backupConfigFile^%mindTestUtils
    ;
    ; create a new one
    set string="# comment"_LF_"   "_LF_"#extra comment with no space"
    do writeToConfig^%mindTestUtils(.string)

    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Processing conf file",.ret)
    ;
    do eq^%ut(ret(foundIx+1),"conf file processed","should have no dump inbetween")
    ;
	quit
	;
	;
PORT4 	;@test line with tabs
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    do backupConfigFile^%mindTestUtils
    ;
    ; create a new one
    set string="# comment"_LF_"   "_$char(9)_LF_"#extra comment"
    do writeToConfig^%mindTestUtils(.string)

    set *ret=$$runMind^%mindTestUtils()
    zwr ret
    set foundIx=$$findIndexInArray^%mindTestUtils("Processing conf file",.ret)
    w !,foundIx
    ;
    do eq^%ut(ret(foundIx+2),"conf file processed","should have no dump inbetween")
    ;
	quit
	;
	;
