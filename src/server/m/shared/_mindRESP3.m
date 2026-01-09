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
