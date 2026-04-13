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
DEFAULT0	;@test
    quit
DEFAULT1	;@test -----------------  default values
	quit
DEFAULT2	;@test
	quit
DEFAULT3 	;@test Transport protocol
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string=""
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("3mTransport protocol:  "_$C(27)_"[38;5;6mTCP",.ret)
    ;
    do eq^%ut(foundIx>0,1,"looking for TCP")
    ;
	quit
	;
	;
DEFAULT4 	;@test Listen port
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string=""
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("3mListen port:         "_$C(27)_"[38;5;6m10000",.ret)
    ;
    do eq^%ut(foundIx>0,1,"looking for port")
    ;
	quit
	;
	;
DEFAULT5 	;@test use tls
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string=""
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Use TLS:             "_$C(27)_"[38;5;6mNO",.ret)
    ;
    do eq^%ut(foundIx>0,1,"looking for tls")
    ;
	quit
	;
	;
DEFAULT6 	;@test log level
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string=""
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Log level:           "_$C(27)_"[38;5;6mcommands",.ret)
    ;
    do eq^%ut(foundIx>0,1,"looking for log level")
    ;
	quit
	;
	;
DEFAULT7 	;@test log to
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string=""
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Log to:              "_$C(27)_"[38;5;6mCONSOLE",.ret)
    ;
    do eq^%ut(foundIx>0,1,"looking for log to")
    ;
	quit
	;
	;
DEFAULT8 	;@test dump request
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string=""
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Dump requests:       "_$C(27)_"[38;5;6mNo",.ret)
    ;
    do eq^%ut(foundIx>0,1,"looking for dum request")
    ;
	quit
	;
	;
DEFAULT9 	;@test dump response
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string=""
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("3mDump responses:      "_$C(27)_"[38;5;6mNo",.ret)
    ;
    do eq^%ut(foundIx>0,1,"looking for dum request")
    ;
	quit
	;
	;
DEFAULT10 	;@test statistics
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string=""
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Statistics:          "_$C(27)_"[38;5;6mOff",.ret)
    ;
    do eq^%ut(foundIx>0,1,"looking for dum response")
    ;
	quit
	;
	;
DEFAULT11 	;@test error dump
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string=""
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("3mErrors dump:         "_$C(27)_"[38;5;6mBrief",.ret)
    ;
    do eq^%ut(foundIx>0,1,"looking for error dump")
    ;
	quit
	;
	;
DEFAULT12 	;@test user API dir
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string=""
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("3mUser API dir:        "_$C(27)_"[38;5;6m$ydb_dist/plugin/etc/mind/uApi/",.ret)
    ;
    do eq^%ut(foundIx>0,1,"looking for user api")
    ;
	quit
	;
	;
