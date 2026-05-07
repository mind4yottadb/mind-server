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
; ************************************************************
; stats
; ************************************************************
; parameters:
;
; Returns:
; <RESP3 BLOB> {json}
;
; ************************************************************
stats
    if $data(%mindParams("lstats"))<9 set %mindRes="+no data"_%mindCRLF quit
    ;
    new buffer,ix,JDOM
    ;
    ; grand totals first
    set buffer("grand_total","total_received")=$get(%mindParams("lstats","_grand","rec"),0)-1
    set buffer("grand_total","total_ok")=$get(%mindParams("lstats","_grand","ok"),0)
    set buffer("grand_total","total_nok")=$get(%mindParams("lstats","_grand","nok"),0)
    set buffer("grand_total","total_invalid_cmd")=$get(%mindParams("lstats","_grand","invalid_cmd"),0)
    ;
    ; then details, if available
    set ix="" for  set ix=$order(%mindParams("lstats",ix)) quit:ix=""  do
    . quit:$extract(ix,1,1)="_"!(ix="session.stats")
    . set buffer(ix,"total_received")=$get(%mindParams("lstats",ix,"rec"),0)
    . set buffer(ix,"total_ok")=$get(%mindParams("lstats",ix,"ok"),0)
    . set buffer(ix,"total_nok")=$get(%mindParams("lstats",ix,"nok"),0)
    . set buffer(ix,"total_invalid_cmd")=$get(%mindParams("lstats",ix,"invalid_cmd"),0)
    ;
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
; ************************************************************
; resetStats
; ************************************************************
; parameters:
;
; Returns:
; <RESP3 SIMPLE STRING> ok
;
; ************************************************************
resetStats
    kill %mindParams("lstats")
	;
	set:%mindParams("stats") ret=$increment(%mindParams("lstats","_grand","rec"))
    set:%mindParams("stats")=2 ret=$increment(%mindParams("lstats",%mindArgs(0),"rec"))
    ;
    set %mindRes="+ok"_%mindCRLF
    ;
    quit
    ;
    ;
; ************************************************************
; timeSinceConnect
; ************************************************************
; parameters:
;
; Returns:
; <RESP3 SIMPLE STRING> {duration}
;
; ************************************************************
timeSinceConnect
    set time=$get(^%mindSessions($job,"connectTime"),0)
    ;
    set %mindRes=","_(($zut-time)/1E6)_%mindCRLF
    ;
    quit
    ;
    ;
