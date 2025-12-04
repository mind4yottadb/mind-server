	;#################################################################
	;#                                                               #
	;# Copyright (c) 2025 DnaSoft B.V. and/or its subsidiaries.      #
	;# All rights reserved.                                          #
	;#                                                               #
	;#   This source code contains the intellectual property         #
	;#   of its copyright holder(s), and is made available           #
	;#   under a license.  If you do not know the terms of           #
	;#   the license, please stop and do not read further.           #
	;#                                                               #
	;#################################################################
	;
start(params)


	; ----------------------------------
	; init terminal
	; ----------------------------------
	do set^terminal
	;
	write trm("bgnd_black"),!
	;
	write trm("yellow"),"YottaDB:   ",?30,trm("light_cyan"),$zpiece($ZYRELEASE," ",2),!
	write trm("yellow"),"OS:   ",?30,trm("light_cyan"),$zpiece($ZYRELEASE," ",3),!
	write trm("yellow"),"Platform:   ",?30,trm("light_cyan"),$zpiece($ZYRELEASE," ",4),!






    ;
    quit
    ;