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
    ; generates a GUID if needed
    if %mindParams("pool","guid")="" do
    . set guid=$zyhash($zut,$zut),guid="f"_$zextract(guid,3,$zlength(guid)-1)
    . set guid=$zextract(guid,1,8)_"-"_$zextract(guid,9,12)_"-"_$zextract(guid,13,16)_"-"_$zextract(guid,17,20)_"-"_$zextract(guid,21,50)
    . ;
    . ; register it on the %mindParams
    . set %mindParams("pool","guid")=guid
    ;
    ; register it on the global for deferred calls
    kill ^%mindPools(guid,"pids")
    merge ^%mindPools(guid,"pids")=%mindParams("pool","pids")
    ;
    set %mindRes="+"_guid_%mindCRLF
    ;
    quit
    ;
    ;
; ************************************************************
; getPoolStats
; ************************************************************
; parameters:
;
; Returns:
; <RESP3 SIMPLE STRING> {path}
;
; ************************************************************
getPoolStats
    if $data(%mindParams("pool","pids"))<10 set %mindRes="-"_$$poolNotRegistered^%mindErrors()_"The pool has not been registered or this process in not a devOps process"_%mindCRLF quit
    ;
    new pid,buffer,JDOM,JSONerr,ix
    new fileBuffer,procFile
    ;
    set pid="" for  set pid=$order(%mindParams("pool","pids",pid)) quit:pid=""  do
    . ; check if process is alive, otherwise mark it as K (killed) and proceed
    . if $zgetjpi(pid,"ISPROCALIVE")=0 set buffer(pid,"state")="K",buffer(pid,"pid")=pid quit
    . ; get /proc/ files
    . set procFile="/proc/"_pid_"/stat"
    . open procFile:(readonly:exception="set buffer(pid,""state"")=""K"",buffer(pid,""pid"")=pid quit ")
    . use procFile
    . read fileBuffer
    . close procFile
    . ;
    . set buffer(pid,"pid")=pid
    . set buffer(pid,"state")=$zpiece(fileBuffer," ",3)
    . set buffer(pid,"state")=$zpiece(fileBuffer," ",3)
    . set buffer(pid,"cpu","utime")=$zpiece(fileBuffer," ",14)
    . set buffer(pid,"cpu","stime")=$zpiece(fileBuffer," ",15)
    . set buffer(pid,"cpu","cutime")=$zpiece(fileBuffer," ",16)
    . set buffer(pid,"cpu","cstime")=$zpiece(fileBuffer," ",17)
    . ;
    . kill fileBuffer
    . set procFile="/proc/"_pid_"/status"
    . if $zsearch(procFile)="" set buffer(pid,"state")="K",buffer(pid,"pid")=pid quit
    . ;
    . open procFile:readonly
    . use procFile
    . for row=1:1 quit:$zeof  read fileBuffer(row)
    . close procFile
    . ;
    . set buffer(pid,"memory","VmPeak")=$zpiece($$FUNC^%TRIM($zextract(fileBuffer(18),10,20))," ")
    . set buffer(pid,"memory","VmSize")=$zpiece($$FUNC^%TRIM($zextract(fileBuffer(19),10,20))," ")
    . set buffer(pid,"memory","VmLck")=$zpiece($$FUNC^%TRIM($zextract(fileBuffer(20),10,20))," ")
    . set buffer(pid,"memory","VmRss")=$zpiece($$FUNC^%TRIM($zextract(fileBuffer(23),10,20))," ")
    . set buffer(pid,"memory","VmHWM")=$zpiece($$FUNC^%TRIM($zextract(fileBuffer(22),10,20))," ")
    ;
    ; create json
    do stringify^%mindJSON("buffer","JDOM","JSONerr")
    if $data(JSONerr) set %mindRes="-Error serializing JSON: "_$get(JSONerr(1))_" "_$get(JSONerr(2))_%mindCRLF quit
    ;
    set ix="" for  set ix=$order(JDOM(ix)) quit:ix=""  set %mindRes=%mindRes_JDOM(ix)
    ;
    set %mindRes=$$buildBlob^%mindRESP3(%mindRes)
    ;
    quit
    ;
    ;
