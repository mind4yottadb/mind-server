;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;								;
; Copyright (c) 2024-2025 YottaDB LLC and/or its subsidiaries.	;
; All rights reserved.						;
;								;
;	This source code contains the intellectual property	;
;	of its copyright holder(s), and is made available	;
;	under a license.  If you do not know the terms of	;
;	the license, please stop and do not read further.	;
;								;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;
mindCommandLineParser
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
	;do STARTUP^%ydbxiderTestUtils
	;
	quit
	;
	;
SHUTDOWN
	;do SHUTDOWN^%ydbxiderTestUtils
	;
	quit
	;
	;
PORT0	;@test
    quit
PORT1	;@test -----------------  --port
	quit
PORT2	;@test
	quit
PORT3 	;@test --port with bad syntax
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--porta")
    set found=$$findStringInArray^%mindTestUtils("--porta not supported",.ret)
    ;
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
PORT4 	;@test --port with no value
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--port")
    set found=$$findStringInArray^%mindTestUtils("Parameter for --port not specified or invalid",.ret)
    ;
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
PORT5 	;@test --port with string value
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--port testingstring")
    set found=$$findStringInArray^%mindTestUtils("Parameter for --port not specified or invalid",.ret)
    ;
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
PORT6 	;@test --port with value outside range 1024-49151
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--port 1023")
    set found=$$findStringInArray^%mindTestUtils("Parameter for --port not specified or invalid",.ret)
    ;
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
PORT7 	;@test --port with value outside range 1024-49151
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--port 49152")
    set found=$$findStringInArray^%mindTestUtils("Parameter for --port not specified or invalid",.ret)
    ;
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
PORT8 	;@test --port with value just inside range 1024-49151
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--port 1024")
    set found=$$findStringInArray^%mindTestUtils("Parameter for --port not specified or invalid",.ret)
    ;
    do eq^%ut(found,0,"nope")
    ;
	quit
	;
	;
PORT9 	;@test --port with value just inside range 1024-49151
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--port 49151")
    ;zwr:$data(ret) ret
    set found=$$findStringInArray^%mindTestUtils("Parameter for --port not specified or invalid",.ret)
    ;
    do eq^%ut(found,0,"nope")
    ;
	quit
	;
	;
