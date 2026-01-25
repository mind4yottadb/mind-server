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
; ****************************************************************
; buildBlob(str)
; returns a fully formatted RESP3 blob
; ****************************************************************
buildBlob(str)
    quit "$"_$zlength(str)_CRLF_str_CRLF
    ;
    ;
; ****************************************************************
; buildBlobError(str)
; returns a fully formatted RESP3 blob
; ****************************************************************
buildBlobError(str)
    quit "!"_$zlength(str)_CRLF_str_CRLF
    ;
    ;
; ****************************************************************
; buildMap(*buffer)
; returns a fully formatted RESP3 blob
; ****************************************************************
buildMap(buffer)
    new cnt,ix
    ;
    set cnt=0,(buffer,ix)=""
    ;
    for  set ix=$order(buffer(ix)) quit:ix=""  do
    . set buffer=buffer_"+"_ix_CRLF_"+"_buffer(ix)_CRLF
    . set cnt=cnt+1
	;
    set buffer="%"_cnt_CRLF_buffer
    ;
    quit
    ;
    ;
