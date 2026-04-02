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
; hasValue
; ************************************************************
; parameters:
; 1 glvn
;
; Returns:
; <RESP3 BOOL>
;
hasValue
    new res
    ;
    set res=+$data(@%args(1)),%res=$select(res=1!(res=11):"#t",1:"#f")_CRLF
    ;
    quit
    ;
    ;
; ************************************************************
; hasNodes
; ************************************************************
; parameters:
; 1 glvn
;
; Returns:
; <RESP3 BOOL>
;
hasNodes
    new res
    ;
    set res=+$data(@%args(1)),%res=$select(res>9:"#t",1:"#f")_CRLF
    ;
    quit
    ;
    ;
; ************************************************************
; getValue
; ************************************************************
; parameters:
; 1 glvn
;
; Returns:
; <RESP3 BLOB> string
; or
; <RESP3 BLOB> (number
;
getValue
    new res
    ;
    set res=$get(@%args(1)),%res=$select($$isNumber^%mindUtils(res):"("_res_CRLF,1:$$buildBlob^%mindRESP3(res))
    ;
    quit
    ;
    ;
; ************************************************************
; readValue
; ************************************************************
; parameters:
; 1 glvn
;
; Returns:
; <RESP3 BLOB> string
; or
; <RESP3 BLOB> (number
;
readValue
    new res
    new $etrap
    ;
    set $etrap="goto readValueError"
    ;
    set res=@%args(1),%res=$select($$isNumber^%mindUtils(res):"("_res_CRLF,1:$$buildBlob^%mindRESP3(res))
    ;
    quit
    ;
readValueError
    set %res="-"_%args(1)_": path not found"_CRLF,$ecode=""
    quit
    ;
    ;
; ************************************************************
; getTree
; ************************************************************
; parameters:
; 1 filename
;
; Returns:
; <RESP3 BLOB> {file content}
;
getTree
    ;
    quit
    ;
    ;
; ************************************************************
; setTree
; ************************************************************
; parameters:
; 1 filename
;
; Returns:
; <RESP3 BLOB> {file content}
;
setTree
    ;
    quit
    ;
    ;
; ************************************************************
; killValue
; ************************************************************
; parameters:
; 1 glvn
;
; Returns:
; <RESP3 SIMPLE STRING> +ok
;
killValue
    zkill @%args(1)
    ;
    set %res="+ok"_CRLF
    ;
    quit
    ;
    ;
; ************************************************************
; killTree
; ************************************************************
; parameters:
; 1 glvn
;
; Returns:
; <RESP3 SIMPLE STRING> +ok
;
killTree
    kill @%args(1)
    ;
    set %res="+ok"_CRLF
    ;
    quit
    ;
    ;
; ************************************************************
; getPiece
; ************************************************************
; parameters:
; 1 glvn
; 2 pieceChar
; 3 start
; 4 end
;
; Returns:
; <RESP3 BLOB> {pieced data}
; or
; <RESP3 BIGNUMBER> {number}
;
getPiece
    new res
    ;
    set %args(2)=$get(%args(2),"^"),%args(3)=$get(%args(3),1),%args(4)=$get(%args(4),%args(3))
    set res=$piece($get(@%args(1)),%args(2),%args(3),%args(4))
    set %res=$select($$isNumber^%mindUtils(res):"("_res_CRLF,1:$$buildBlob^%mindRESP3(res))
    ;
    quit
    ;
    ;
; ************************************************************
; setPiece
; ************************************************************
; parameters:
; 1 glvn
; 2 data
; 3 pieceChar
; 4 start
; 5 end
;
; Returns:
; <RESP3 SIMPLE STRING> {+ok}
;
setPiece
    ;
    set %args(3)=$get(%args(3),"^"),%args(4)=$get(%args(4),1),%args(5)=$get(%args(5),%args(4))
    set $piece(@%args(1),%args(3),%args(4),%args(5))=%args(2)
    ;
    set %res="+ok"_CRLF
    ;
    quit
    ;
    ;
; ************************************************************
; setValue
; ************************************************************
; parameters:
; 1 glvn
; 2 RESP3 data (BLOB or NUMBER)
;
; Returns:
; <RESP3 SIMPLE STRING> {ok}
;
setValue
    new start
    ;
    if $zextract(%args(2),1,1)="$" do
    . set start=$zfind(%args(2),LF),%args(2)=$zextract(%args(2),start,$zlength(%args(2))-2)
    else  set %args(2)=+$zextract(%args(2),2,$zlength(%args(2))-2)
    ;
    set @%args(1)=%args(2),%res="+ok"_CRLF
    ;
    quit
    ;
    ;
; ************************************************************
; setJSON
; ************************************************************
; parameters:
; 1 glvn
; 2 RESP3 JSON (BLOB)
;
; Returns:
; <RESP3 SIMPLE STRING> {ok}
;
setJSON
    if $get(%args(2))="" set %res="-No JSON provided"_CRLF quit
    ;
    new JSONerr
    ;
    do parse^%mindJSON("%args(2)",$name(@%args(1)),"JSONerr")
    if $data(JSONerr) set %res="-Error parsing JSON: "_$get(JSONerr(1))_" "_$get(JSONerr(2))_CRLF quit
    ;
    set %res="+ok"_CRLF
    ;
    quit
    ;
    ;
; ************************************************************
; getJSON
; ************************************************************
; parameters:
; 1 glvn
;
; Returns:
; <RESP3 BLOB> {json}
;
getJSON
    new JDOM,ix
    ;
    do stringify^%mindJSON($name(@%args(1)),"JDOM","JSONerr")
    if $data(JSONerr) set %res="-Error serializing JSON: "_$get(JSONerr(1))_" "_$get(JSONerr(2))_CRLF quit
    ;
    set ix="" for  set ix=$order(JDOM(ix)) quit:ix=""  set %res=%res_JDOM(ix)
    ;
    set %res=$$buildBlob^%mindRESP3(%res)
    ;
    quit
    ;
    ;
; ************************************************************
; increment
; ************************************************************
; parameters:
; 1 glvn
; 2 incrementValue
;
; Returns:
; <RESP3 BLOB> {json}
;
increment
    new ret
    ;
    set %args(2)=$get(%args(2),1)
    set ret=$increment(@%args(1),%args(2))
    ;
    set %res=$select($find(ret,"."):",",1:":")_ret_CRLF
    ;
    quit
    ;
    ;
; ************************************************************
; decrement
; ************************************************************
; parameters:
; 1 glvn
; 2 decrementValue
;
; Returns:
; <RESP3 BLOB> {json}
;
decrement
    new ret
    ;
    set %args(2)=$get(%args(2),1)
    set ret=$increment(@%args(1),-%args(2))
    ;
    set %res=$select($find(ret,"."):",",1:":")_ret_CRLF
    ;
    quit
    ;
    ;
; ************************************************************
; merge
; ************************************************************
; parameters:
; 1 filename
;
; Returns:
; <RESP3 BLOB> {file content}
;
merge
    quit
    ;
    ;
; ************************************************************
; addLock
; ************************************************************
; parameters:
; 1 glvn
; 2 timeout
;
; Returns:
; <RESP3 SIMPLE STRING>
;
; ************************************************************
addLock
    if $get(%args(2),0)=0 lock +@%args(1) goto addLockQuit
    if +%args(2)<0 set %res="-timeout can not be negative" quit
    lock +@%args(1):%args(2)
    ;
addLockQuit
    set %res=$select($test:"+ok",1:"-timeout elapsed")_CRLF
    ;
    quit
    ;
    ;
; ************************************************************
; removeLock
; ************************************************************
; parameters:
; 1 glvn
;
; Returns:
; <RESP3 SIMPLE STRING>
;
; ************************************************************
removeLock
    lock -@%args(1)
    ;
    set %res="+ok"_CRLF
    ;
    quit
    ;
    ;
; ************************************************************
; findNext
; ************************************************************
; parameters:
; 1 glvn
; 2 value
;
; Returns:
; <RESP3 SIMPLE STRING>
;
; ************************************************************
findNext
    new char
    ;
    set %args(2)=""""_%args(2)_""""
    ;
    set char=$zextract(%args(1),$zlength(%args(1)),$zlength(%args(1)))
    if char=")" do
    . set %args(1)=$zextract(%args(1),1,$zlength(%args(1))-1)
    . do log^%mindLogger(%args(1))
    . set:$zextract(%args(1),$zlength(%args(1)),$zlength(%args(1)))'="(" %args(1)=%args(1)_","
    . set %args(1)=%args(1)_%args(2)_")"
    else  set %args(1)=%args(1)_"("_%args(2)_")"
    ;
    do log^%mindLogger(%args(1))
    set res=$order(@%args(1)),%res=$select($$isNumber^%mindUtils(res):"("_res_CRLF,1:$$buildBlob^%mindRESP3(res))
    ;
    quit
    ;
    ;
; ************************************************************
; findPrev
; ************************************************************
; parameters:
; 1 glvn
; 2 value
;
; Returns:
; <RESP3 SIMPLE STRING>
;
; ************************************************************
findPrev
    new char
    ;
    set %args(2)=""""_%args(2)_""""
    ;
    set char=$zextract(%args(1),$zlength(%args(1)),$zlength(%args(1)))
    if char=")" do
    . set %args(1)=$zextract(%args(1),1,$zlength(%args(1))-1)
    . do log^%mindLogger(%args(1))
    . set:$zextract(%args(1),$zlength(%args(1)),$zlength(%args(1)))'="(" %args(1)=%args(1)_","
    . set %args(1)=%args(1)_%args(2)_")"
    else  set %args(1)=%args(1)_"("_%args(2)_")"
    ;
    do log^%mindLogger(%args(1))
    set res=$order(@%args(1),-1),%res=$select($$isNumber^%mindUtils(res):"("_res_CRLF,1:$$buildBlob^%mindRESP3(res))
    ;
    quit
    ;
    ;