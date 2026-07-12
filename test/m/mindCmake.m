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
mindCmake
	; Requires M-Unit
	;
test if $text(^%ut)="" quit
	do en^%ut($text(+0),3)
	;
	write !
	;
	quit
	;
CMAKE0	;@test
    quit
CMAKE1	;@test -----------------  default, no params     -
	quit
CMAKE2	;@test
	quit
CMAKE3 	;@test with no params
    new buffer
    ;
    do runShell^%mindTestUtils("export",.buffer)
    write !,$zpiece(buffer(40),"=",2)
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
