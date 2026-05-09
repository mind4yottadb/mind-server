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
; buildString(str)
; returns a fully formatted RESP3 blob
; ****************************************************************
buildString(str) goto buildBlobString
buildBlob(str)
buildBlobString
    quit "$"_$zlength(str)_%mindCRLF_str_%mindCRLF
    ;
    ;
; ****************************************************************
; buildErrorBlob(str)
; returns a fully formatted RESP3 blobError
; ****************************************************************
buildErrorBlob(str)
    quit "!"_$zlength(str)_%mindCRLF_str_%mindCRLF
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
    . set buffer=buffer_"+"_ix_%mindCRLF_"+"_buffer(ix)_%mindCRLF
    . set cnt=cnt+1
	;
    set buffer="%"_cnt_%mindCRLF_buffer
    ;
    quit
    ;
    ;
; ****************************************************************
; buildSimpleString(str)
; returns a fully formatted RESP3 string
; ****************************************************************
buildSimpleString(str)
    quit "+"_str_%mindCRLF
    ;
    ;
; ****************************************************************
; buildErrorString(str)
; returns a fully formatted RESP3 string
; ****************************************************************
buildErrorString(str)
    quit "-"_str_%mindCRLF
    ;
    ;
; ****************************************************************
; buildInt(str)
; returns a fully formatted RESP3 int
; ****************************************************************
buildInt(str)
    quit ":"_str_%mindCRLF
    ;
    ;
; ****************************************************************
; buildFloat(str)
; returns a fully formatted RESP3 float
; ****************************************************************
buildFloat(str)
    quit ","_str_%mindCRLF
    ;
    ;
; ****************************************************************
; buildBoolean(val)
; returns a fully formatted RESP3 boolean
; ****************************************************************
buildBoolean(val)
    quit "#"_$select(val:"t",1:"f")_%mindCRLF
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
    quit "|"_($zlength(ret)+4)_%mindCRLF_"obj:"_ret_%mindCRLF
    ;
    ;
; ****************************************************************
; buildNull()
; returns a fully formatted RESP3 boolean
; ****************************************************************
buildNull()
    ;
    quit "_"_%mindCRLF
    ;
    ;
; ****************************************************************
; buildJsonBoolean(val)
; returns a JDOM boolean value
; ****************************************************************
buildJsonBoolean(val)
    quit $zchar(0)_$select(val:"true",1:"false")
    ;
    ;
; ****************************************************************
; buildJsonNull()
; returns a JDOM null value
; ****************************************************************
buildJsonNull()
    quit $zchar(0)_"null"
    ;
    ;
; ****************************************************************
; buildVoid()
; returns a fully formatted RESP3 boolean
; ****************************************************************
buildVoid()
    quit "+ok"_%mindCRLF
    ;
    ;
; ****************************************************************
; ****************************************************************
; ****************************************************************
; These procedures set the %mindRes
; ****************************************************************
; ****************************************************************
; ****************************************************************
;
; ****************************************************************
; returnBlob(str)
; returnString(str)
; returns a fully formatted RESP3 blob
; ****************************************************************
returnString(str) goto returnBlobString
returnBlob(str)
returnBlobString
    set %mindRes="$"_$zlength(str)_%mindCRLF_str_%mindCRLF
    ;
    quit
    ;
    ;
; ****************************************************************
; returnErrorBlob(str)
; returns a fully formatted RESP3 blobError
; ****************************************************************
returnErrorBlob(str)
    set %mindRes="!"_$zlength(str)_%mindCRLF_str_%mindCRLF
    ;
    quit
    ;
    ;
; ****************************************************************
; returnMap(*buffer)
; returns a fully formatted RESP3 map
; ****************************************************************
returnMap(buffer)
    new cnt,ix
    ;
    set cnt=0,(buffer,ix)=""
    ;
    for  set ix=$order(buffer(ix)) quit:ix=""  do
    . set buffer=buffer_"+"_ix_%mindCRLF_"+"_buffer(ix)_%mindCRLF
    . set cnt=cnt+1
	;
    set buffer="%"_cnt_%mindCRLF_buffer
    ;
    quit
    ;
    ;
; ****************************************************************
; returnSimpleString(str)
; returns a fully formatted RESP3 string
; ****************************************************************
returnSimpleString(str)
    set %mindRes="+"_str_%mindCRLF
    ;
    quit
    ;
    ;
; ****************************************************************
; returnErrorString(str)
; returns a fully formatted RESP3 string
; ****************************************************************
returnErrorString(str)
    set %mindRes="-"_str_%mindCRLF
    ;
    quit
    ;
    ;
; ****************************************************************
; returnInt(str)
; returns a fully formatted RESP3 int
; ****************************************************************
returnInt(str)
    set %mindRes=":"_str_%mindCRLF
    ;
    quit
    ;
    ;
; ****************************************************************
; returnFloat(str)
; returns a fully formatted RESP3 float
; ****************************************************************
returnFloat(str)
    set %mindRes=","_str_%mindCRLF
    ;
    quit
    ;
    ;
; ****************************************************************
; returnBoolean(val)
; returns a fully formatted RESP3 boolean
; ****************************************************************
returnBoolean(val)
    set %mindRes="#"_$select(val:"t",1:"f")_%mindCRLF
    ;
    quit
    ;
    ;
; ****************************************************************
; returnObject($namebuffer))
; returns a fully formatted RESP3 blob filled with JSON string
; ****************************************************************
returnObject(buffer)
    new JDOM,JERR,ix,ret
    ;
    do stringify^%mindJSON($name(buffer),"JDOM","JERR")
    if $data(JERR) set %mindRes="-JSON error: "_$get(JERR(0))_" "_$get(JERR(1)) quit
    ;
    set (ix,ret)="" for  set ix=$order(JDOM(ix)) quit:ix=""  set ret=ret_JDOM(ix)
    ;
    set %mindRes="|"_($zlength(ret)+4)_%mindCRLF_"obj:"_ret_%mindCRLF
    ;
    quit
    ;
    ;
; ****************************************************************
; returnNull()
; returns a fully formatted RESP3 boolean
; ****************************************************************
returnNull()
    ;
    set %mindRes="_"_%mindCRLF
    ;
    quit
    ;
    ;
; ****************************************************************
; returnVoid()
; returns a fully formatted RESP3 boolean
; ****************************************************************
returnVoid()
    set %mindRes="+ok"_%mindCRLF
    ;
    quit
    ;
    ;
