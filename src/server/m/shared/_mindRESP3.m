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
; buildErrorBlob(str)
; returns a fully formatted RESP3 blobError
; ****************************************************************
buildErrorBlob(str)
    quit "!"_$zlength(str)_CRLF_str_CRLF
    ;
    ;
; ****************************************************************
; buildMap(*buffer)
; returns a fully formatted RESP3 map
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
; ****************************************************************
; buildString(str)
; returns a fully formatted RESP3 string
; ****************************************************************
buildString(str)
    quit "+"_str_CRLF
    ;
    ;
; ****************************************************************
; buildErrorString(str)
; returns a fully formatted RESP3 string
; ****************************************************************
buildErrorString(str)
    quit "-"_str_CRLF
    ;
    ;
; ****************************************************************
; buildInt(str)
; returns a fully formatted RESP3 int
; ****************************************************************
buildInt(str)
    quit ":"_str_CRLF
    ;
    ;
; ****************************************************************
; buildFloat(str)
; returns a fully formatted RESP3 float
; ****************************************************************
buildFloat(str)
    quit ","_str_CRLF
    ;
    ;
; ****************************************************************
; buildBoolean(val)
; returns a fully formatted RESP3 boolean
; ****************************************************************
buildBoolean(val)
    quit "#"_$select(val:"t",1:"f")_CRLF
    ;
    ;
; ****************************************************************
; buildObject($namebuffer))
; returns a fully formatted RESP3 blob filled with JSON string
; ****************************************************************
buildObject(buffer)
    new JDOM,JERR,ix,ret
    ;
    do stringify^%mindJSON($name(buffer),"JDOM","JERR")
    if $data(JERR) quit "-JSON error: "_JERR(0)_" "_$get(JERR(1))
    ;
    set (ix,ret)="" for  set ix=$order(JDOM(ix)) quit:ix=""  set ret=ret_JDOM(ix)
    ;
    quit "="_($zlength(ret)+4)_CRLF_"obj:"_ret_CRLF
    ;
    ;
; ****************************************************************
; buildNull()
; returns a fully formatted RESP3 boolean
; ****************************************************************
buildNull()
    ;
    quit "_"_CRLF
    ;
    ;
; ****************************************************************
; valToBoolean(val)
; returns a JDOM boolean value
; ****************************************************************
valToBoolean(val)
    quit $select(val:"true",1:"false")
    ;
    ;

