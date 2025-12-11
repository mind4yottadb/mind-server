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
; This file contains the terminal init routine that sets the trm() array with ANSI commands
set() ;
	new P,S,IX
	;
	set P="[",S="m"
	;
	set trm("esc")=$C(27)
	set trm("cursor_on")=trm("esc")_P_"25h"
	set trm("cursor_off")=trm("esc")_P_"25l"
	set trm("blink_on")=trm("esc")_P_"12h"
	set trm("blink_off")=trm("esc")_P_"12l"
	set trm("cursor_bar")=""
	set trm("cursor_block")=""
	set trm("graphics_on")=trm("esc")_"(0"
	set trm("graphics_off")=trm("esc")_"(B"
	set trm("negative")=trm("esc")_"[7"_S
	set trm("positive")=trm("esc")_"[27"_S
	set trm("tty_reset")=$C(27)_"[0m"
	set trm("degree")=trm("graphics_on")_$C(102)_trm("graphics_off")
	set trm("plus_min")=trm("graphics_on")_"g"_trm("graphics_off")
	set trm("leq")=trm("graphics_on")_"y"_trm("graphics_off")
	set trm("gew")=trm("graphics_on")_"z"_trm("graphics_off")
	set trm("pi")=trm("graphics_on")_$C(123)_trm("graphics_off")
	set trm("neq")=trm("graphics_on")_$C(124)_trm("graphics_off")
	set trm("british_pound")=trm("graphics_on")_$C(125)_trm("graphics_off")
	set trm("bell")=$C(7)
	;
	set trm("CLPBKON")=trm("esc")_"[?2004h"  ;27-91-50-48-48-126   / 27-90-50-48-49-126			; TODO: ??? clipboard?  Not sure anymore, need to look into
	set trm("CLPBKOFF")=trm("esc")_"[?2004l"
	set trm("mouse_on")=trm("esc")_"[?1002h"
	set trm("mouse_off")=trm("esc")_"[?1002l"
	;
	set trm("black")=trm("esc")_P_"38;5;0"_S
	set trm("red")=trm("esc")_P_"38;5;1"_S
	set trm("green")=trm("esc")_P_"38;5;2"_S
	set trm("yellow")=trm("esc")_P_"38;5;3"_S
	set trm("blue")=trm("esc")_P_"38;5;4"_S
	set trm("magenta")=trm("esc")_P_"38;5;5"_S
	set trm("cyan")=trm("esc")_P_"38;5;6"_S
	set trm("white")=trm("esc")_P_"38;5;7"_S
	;
	set trm("light_black")=trm("esc")_P_"38;5;8"_S
	set trm("light_red")=trm("esc")_P_"38;5;9"_S
	set trm("light_green")=trm("esc")_P_"38;5;10"_S
	set trm("light_yellow")=trm("esc")_P_"38;5;11"_S
	set trm("light_blue")=trm("esc")_P_"38;5;12"_S
	set trm("light_magenta")=trm("esc")_P_"38;5;13"_S
	set trm("light_cyan")=trm("esc")_P_"38;5;14"_S
	set trm("light_white")=trm("esc")_P_"38;5;15"_S
	;
	set trm("bgnd_black")=trm("esc")_P_"48;5;0"_S
	set trm("bgnd_red")=trm("esc")_P_"48;5;1"_S
	set trm("bgnd_green")=trm("esc")_P_"48;5;2"_S
	set trm("bgnd_yellow")=trm("esc")_P_"48;5;3"_S
	set trm("bgnd_blue")=trm("esc")_P_"48;5;4"_S
	set trm("bgnd_magenta")=trm("esc")_P_"48;5;5"_S
	set trm("bgnd_cyan")=trm("esc")_P_"48;5;6"_S
	set trm("bgnd_white")=trm("esc")_P_"48;5;7"_S
	;
	set trm("bgnd_light_black")=trm("esc")_P_"48;5;8"_S
	set trm("bgnd_light_red")=trm("esc")_P_"48;5;9"_S
	set trm("bgnd_light_green")=trm("esc")_P_"48;5;10"_S
	set trm("bgnd_light_yellow")=trm("esc")_P_"48;5;11"_S
	set trm("bgnd_light_blue")=trm("esc")_P_"48;5;12"_S
	set trm("bgnd_light_magenta")=trm("esc")_P_"48;5;13"_S
	set trm("bgnd_light_cyan")=trm("esc")_P_"48;5;14"_S
	set trm("bgnd_light_white")=trm("esc")_P_"48;5;15"_S
	;
	for IX=0:1:255 set trm("F"_IX)=trm("esc")_P_"38;5;"_IX_S,trm("B"_IX)=trm("esc")_P_"48;5;"_IX_S
	;
	quit
	;
drawLine
	new ix
	;
	write !,trm("F25"),trm("bgnd_black")
	for ix=1:1:86 write "-"
	write trm("bgnd_black"),!
	;
	quit
	;
