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
    new buffer,command,ret
    ;
    ; perform the installation
    set command="rm -fr /tmp/mind-server && echo ""Using branch: $test_branch"" && cd /tmp && git clone -b $test_branch --single-branch https://github.com/mind4yottadb/mind-server.git && cd mind-server && mkdir build && cd build && cmake .. && make && make install"
    set ret=$$runShell^%mindTestUtils(command,.buffer)
    ;
    do eq^%ut(ret,0,"sub-process returned exitCode="_ret)



    ;
	quit
	;
	;
