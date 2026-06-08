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
;
; ************************************************************
; register
; ************************************************************
; parameters:
;
; Returns:
; <RESP3 SIMPLE STRING> {path}
;
; ************************************************************
register
    if $get(%mindArgs(1))="" set %mindRes="-"_$$noJson^%mindErrors()_"No JSON provided"_%mindCRLF quit
    ;
    new JSONerr,buffer,ix,guid
    ;
    do parse^%mindJSON("%mindArgs(1)",$name(buffer),"JSONerr")
    if $data(JSONerr) set %mindRes="-"_$$jsonParseError^%mindErrors()_"Error parsing JSON: "_$get(JSONerr(1))_" "_$get(JSONerr(2))_%mindCRLF quit
    ;
    set ix="" for  set ix=$order(buffer(ix)) quit:ix=""  set %mindParams("pool","pids",buffer(ix))=""
    ;
    ; generates a GUID
    set guid=$zyhash($zut,$zut),guid="f"_$zextract(guid,3,$zlength(guid)-1)
    set guid=$zextract(guid,1,8)_"-"_$zextract(guid,9,12)_"-"_$zextract(guid,13,16)_"-"_$zextract(guid,17,20)_"-"_$zextract(guid,21,50)
    ;
    ; register it on the %mindParams
    set %mindParams("pool","guid")=guid
    ;
    ; register it on the global for deferred calls
    merge ^%mindPools(guid)=%mindParams("pool","pids")
    ;
    set %mindRes="+"_guid_%mindCRLF
    ;
    quit
    ;
    ;
