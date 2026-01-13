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
