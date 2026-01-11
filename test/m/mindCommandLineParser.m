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
PORT0	;@test ------------------
	quit
	;
	;
PORT1	;@test --port
	quit
	;
	;
PORT2	;@test ------------------
	quit
	;
	;
PORT001	;@test with no parameters
	new ret
	;
	;
	; verify response
	do eq^%ut(ret,NoKey,"no key was supplied")
	;
	quit
	;
	;
