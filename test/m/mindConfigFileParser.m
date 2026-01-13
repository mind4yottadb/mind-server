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
STARTUP
	do backupConfigFile^%mindTestUtils
	write !,"Backup created..."
	;
	quit
	;
	;
SHUTDOWN
	do restoreConfigFile^%mindTestUtils
	write !!,"Backup restored..."
	;
	quit
	;
	;
COMM0	;@test
    quit
COMM1	;@test -----------------  comments and empty lines
	quit
COMM2	;@test
	quit
COMM3 	;@test comments and empty lines
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
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
COMM4 	;@test line with tabs
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="# comment"_LF_"   "_$char(9)_LF_"#extra comment"
    do writeToConfig^%mindTestUtils(.string)

    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Processing conf file",.ret)
    ;
    do eq^%ut(ret(foundIx+2),"conf file processed","should have no dump inbetween")
    ;
	quit
	;
	;
PORT0	;@test
    quit
PORT1	;@test -----------------  port
	quit
PORT2	;@test
	quit
PORT3 	;@test port only
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="port"
    do writeToConfig^%mindTestUtils(.string)

    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Warning on line 1: No port number specified",.ret)
    ;
    do eq^%ut(found,1,"error not found")
    ;
	quit
	;
	;
PORT4 	;@test port with string
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="port test"
    do writeToConfig^%mindTestUtils(.string)

    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Warning on line 1: Invalid switch",.ret)
    ;
    do eq^%ut(found,1,"error not found")
    ;
	quit
	;
	;
PORT5 	;@test port with value outside range 1024-49151
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="port 1023"
    do writeToConfig^%mindTestUtils(.string)

    set *ret=$$runMind^%mindTestUtils()
    zwr ret
    set found=$$findStringInArray^%mindTestUtils("Warning on line 1: Invalid switch",.ret)
    ;
    do eq^%ut(found,1,"error not found")
    ;
	quit
	;
	;
PORT6 	;@test port with value outside range 1024-49151
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="port 49152"
    do writeToConfig^%mindTestUtils(.string)

    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Warning on line 1: Invalid switch",.ret)
    ;
    do eq^%ut(found,1,"error not found")
    ;
	quit
	;
	;
PORT7 	;@test port with valid value inside range 1024-49151, but with space separator
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="port 49152"
    do writeToConfig^%mindTestUtils(.string)

    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Warning on line 1: Invalid switch",.ret)
    ;
    do eq^%ut(found,1,"error not found")
    ;
	quit
	;
	;
PORT8 	;@test port with valid value inside range 1024-49151
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="port=1024"
    do writeToConfig^%mindTestUtils(.string)

    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Processing conf file",.ret)
    ;
    do eq^%ut(ret(foundIx+1),"conf file processed","should have no dump inbetween")
    ;
	quit
	;
	;
PORT9 	;@test port with valid value inside range 1024-49151
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="port=49151"
    do writeToConfig^%mindTestUtils(.string)

    set *ret=$$runMind^%mindTestUtils()
    zwr ret
    set foundIx=$$findIndexInArray^%mindTestUtils("Processing conf file",.ret)
    ;
    do eq^%ut(ret(foundIx+1),"conf file processed","should have no dump inbetween")
    ;
	quit
	;
	;
