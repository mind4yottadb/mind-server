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
; This file contains the terminal init routine that sets the %mindTrm() array with ANSI commands
set() ;
	new P,S,IX
	;
	set P="[",S="m"
	;
	set %mindTrm("esc")=$C(27)
	set %mindTrm("cursor_on")=%mindTrm("esc")_P_"25h"
	set %mindTrm("cursor_off")=%mindTrm("esc")_P_"25l"
	set %mindTrm("blink_on")=%mindTrm("esc")_P_"12h"
	set %mindTrm("blink_off")=%mindTrm("esc")_P_"12l"
	set %mindTrm("cursor_bar")=""
	set %mindTrm("cursor_block")=""
	set %mindTrm("graphics_on")=%mindTrm("esc")_"(0"
	set %mindTrm("graphics_off")=%mindTrm("esc")_"(B"
	set %mindTrm("negative")=%mindTrm("esc")_"[7"_S
	set %mindTrm("positive")=%mindTrm("esc")_"[27"_S
	set %mindTrm("tty_reset")=$C(27)_"[0m"
	set %mindTrm("degree")=%mindTrm("graphics_on")_$C(102)_%mindTrm("graphics_off")
	set %mindTrm("plus_min")=%mindTrm("graphics_on")_"g"_%mindTrm("graphics_off")
	set %mindTrm("leq")=%mindTrm("graphics_on")_"y"_%mindTrm("graphics_off")
	set %mindTrm("geq")=%mindTrm("graphics_on")_"z"_%mindTrm("graphics_off")
	set %mindTrm("pi")=%mindTrm("graphics_on")_$C(123)_%mindTrm("graphics_off")
	set %mindTrm("neq")=%mindTrm("graphics_on")_$C(124)_%mindTrm("graphics_off")
	set %mindTrm("british_pound")=%mindTrm("graphics_on")_$C(125)_%mindTrm("graphics_off")
	set %mindTrm("bell")=$C(7)
	;
	set %mindTrm("CLPBKON")=%mindTrm("esc")_"[?2004h"  ;27-91-50-48-48-126   / 27-90-50-48-49-126			; TODO: ??? clipboard?  Not sure anymore, need to look into
	set %mindTrm("CLPBKOFF")=%mindTrm("esc")_"[?2004l"
	set %mindTrm("mouse_on")=%mindTrm("esc")_"[?1002h"
	set %mindTrm("mouse_off")=%mindTrm("esc")_"[?1002l"
	;
	set %mindTrm("black")=%mindTrm("esc")_P_"38;5;0"_S
	set %mindTrm("red")=%mindTrm("esc")_P_"38;5;1"_S
	set %mindTrm("green")=%mindTrm("esc")_P_"38;5;2"_S
	set %mindTrm("yellow")=%mindTrm("esc")_P_"38;5;3"_S
	set %mindTrm("blue")=%mindTrm("esc")_P_"38;5;4"_S
	set %mindTrm("magenta")=%mindTrm("esc")_P_"38;5;5"_S
	set %mindTrm("cyan")=%mindTrm("esc")_P_"38;5;6"_S
	set %mindTrm("white")=%mindTrm("esc")_P_"38;5;7"_S
	;
	set %mindTrm("light_black")=%mindTrm("esc")_P_"38;5;8"_S
	set %mindTrm("light_red")=%mindTrm("esc")_P_"38;5;9"_S
	set %mindTrm("light_green")=%mindTrm("esc")_P_"38;5;10"_S
	set %mindTrm("light_yellow")=%mindTrm("esc")_P_"38;5;11"_S
	set %mindTrm("light_blue")=%mindTrm("esc")_P_"38;5;12"_S
	set %mindTrm("light_magenta")=%mindTrm("esc")_P_"38;5;13"_S
	set %mindTrm("light_cyan")=%mindTrm("esc")_P_"38;5;14"_S
	set %mindTrm("light_white")=%mindTrm("esc")_P_"38;5;15"_S
	;
	set %mindTrm("bgnd_black")=%mindTrm("esc")_P_"48;5;0"_S
	set %mindTrm("bgnd_red")=%mindTrm("esc")_P_"48;5;1"_S
	set %mindTrm("bgnd_green")=%mindTrm("esc")_P_"48;5;2"_S
	set %mindTrm("bgnd_yellow")=%mindTrm("esc")_P_"48;5;3"_S
	set %mindTrm("bgnd_blue")=%mindTrm("esc")_P_"48;5;4"_S
	set %mindTrm("bgnd_magenta")=%mindTrm("esc")_P_"48;5;5"_S
	set %mindTrm("bgnd_cyan")=%mindTrm("esc")_P_"48;5;6"_S
	set %mindTrm("bgnd_white")=%mindTrm("esc")_P_"48;5;7"_S
	;
	set %mindTrm("bgnd_light_black")=%mindTrm("esc")_P_"48;5;8"_S
	set %mindTrm("bgnd_light_red")=%mindTrm("esc")_P_"48;5;9"_S
	set %mindTrm("bgnd_light_green")=%mindTrm("esc")_P_"48;5;10"_S
	set %mindTrm("bgnd_light_yellow")=%mindTrm("esc")_P_"48;5;11"_S
	set %mindTrm("bgnd_light_blue")=%mindTrm("esc")_P_"48;5;12"_S
	set %mindTrm("bgnd_light_magenta")=%mindTrm("esc")_P_"48;5;13"_S
	set %mindTrm("bgnd_light_cyan")=%mindTrm("esc")_P_"48;5;14"_S
	set %mindTrm("bgnd_light_white")=%mindTrm("esc")_P_"48;5;15"_S
	;
	for IX=0:1:255 set %mindTrm("F"_IX)=%mindTrm("esc")_P_"38;5;"_IX_S,%mindTrm("B"_IX)=%mindTrm("esc")_P_"48;5;"_IX_S
	;
	quit
	;
drawLine(color)
	new ix
	;
	set color=$get(color,%mindTrm("yellow"))

	write !,color,%mindTrm("bgnd_black")
	for ix=1:1:80 write "-"
	write %mindTrm("bgnd_black"),!
	;
	quit
	;
resetTerminal
    for node="esc","tty_reset","black","red","green","yellow","blue","magenta","cyan","white","light_black","light_red","light_green","light_yellow","light_blue","light_magenta","light_cyan","light_white" set %mindTrm(node)=""
    ;
    quit
    ;
    ;