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
; ****************************************************************
; RESP3getBlob(str)
; returns a fully formatted RESP3 blob
; ****************************************************************
RESP3getBlob(str)
    quit "$"_$zlength(str)_CRLF_str_CRLF
    ;
    ;
; ****************************************************************
; runShell
; ****************************************************************
runShell(command,return,shell)
	; The shell parameter is used to use an alternative shell (like bash)
	new device,counter,string,currentdevice
	;
	set shell=$get(shell,"/bin/sh")
	set counter=0
	set currentdevice=$io
	set device="runshellcommmandpipe"_$job
	;
	open device:(shell=shell:command=command:readonly):5:"pipe"
	use device
	for  quit:$zeof=1  read string set return($increment(counter))=string
	close device if $get(return(counter))="" kill return(counter)
	use currentdevice
	quit $zclose
	;
	;
