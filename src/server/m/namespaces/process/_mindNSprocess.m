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
;
; ************************************************************
; cwdGet
; ************************************************************
cwdGet

    set %mindRes="+"_$zdirectory_CRLF,%mindRes("status")=1
    ;
    quit
    ;
    ;
; ************************************************************
; cwdSet
; ************************************************************
cwdSet
    if $get(command(2))="" set %mindRes="-the path has not been provided"_CRLF,%mindRes("status")=0 quit
    if $zsearch(command(2))="" set %mindRes="-the provided path does not exists or it is not accessible"_CRLF,%mindRes("status")=0 quit
    ;
    set $zdirectory=command(2)
    set %mindRes="+ok"
    set %mindRes("status")=1
    ;
    quit
    ;
    ;
