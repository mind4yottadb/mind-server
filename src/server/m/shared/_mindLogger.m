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
;----------------------------------------------
; log(message)
;
; message	A stringto be dumped
; level		The log level to display the message. A value of 0 (none) to 3 (responses)
; 			or use the contants: %logNONE,%logSESSIONS,%logCOMMANDS,%logRESPONSES
;
; Note: it will automatically switch and restore the device
;
;----------------------------------------------
log(message)
	new io,zh
	;
	set zh=$zhorolog,io=$zio
	;
	; use current terminal
	use %appParams("zio")
	;
	write !,$zdate(zh,"YYYY-MM-DD 24:60:SS."),$translate($justify($zpiece(zh,",",3)\1000,3)," ","0")," ",message
	;
	; restores the io
	use io
	;
	quit
	;
	;
	;
