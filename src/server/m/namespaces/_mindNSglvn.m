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
    set res=+$data(@%mindArgs(1)),%mindRes=$select(res=1!(res=11):"#t",1:"#f")_%mindCRLF
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
    set res=+$data(@%mindArgs(1)),%mindRes=$select(res>9:"#t",1:"#f")_%mindCRLF
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
    set res=$get(@%mindArgs(1)),%mindRes=$select($$isNumber^%mindUtils(res):"("_res_%mindCRLF,1:$$buildBlob^%mindRESP3(res))
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
    set res=@%mindArgs(1),%mindRes=$select($$isNumber^%mindUtils(res):"("_res_%mindCRLF,1:$$buildBlob^%mindRESP3(res))
    ;
    quit
    ;
readValueError
    set %mindRes="-"_%mindArgs(1)_": path not found"_%mindCRLF,$ecode=""
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
    zkill @%mindArgs(1)
    ;
    set %mindRes="+ok"_%mindCRLF
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
    kill @%mindArgs(1)
    ;
    set %mindRes="+ok"_%mindCRLF
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
    set %mindArgs(2)=$get(%mindArgs(2),"^"),%mindArgs(3)=$get(%mindArgs(3),1),%mindArgs(4)=$get(%mindArgs(4),%mindArgs(3))
    set res=$piece($get(@%mindArgs(1)),%mindArgs(2),%mindArgs(3),%mindArgs(4))
    set %mindRes=$select($$isNumber^%mindUtils(res):"("_res_%mindCRLF,1:$$buildBlob^%mindRESP3(res))
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
    set %mindArgs(3)=$get(%mindArgs(3),"^"),%mindArgs(4)=$get(%mindArgs(4),1),%mindArgs(5)=$get(%mindArgs(5),%mindArgs(4))
    set $piece(@%mindArgs(1),%mindArgs(3),%mindArgs(4),%mindArgs(5))=%mindArgs(2)
    ;
    set %mindRes="+ok"_%mindCRLF
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
    if $zextract(%mindArgs(2),1,1)="$" do
    . set start=$zfind(%mindArgs(2),LF),%mindArgs(2)=$zextract(%mindArgs(2),start,$zlength(%mindArgs(2))-2)
    else  set %mindArgs(2)=+$zextract(%mindArgs(2),2,$zlength(%mindArgs(2))-2)
    ;
    set @%mindArgs(1)=%mindArgs(2),%mindRes="+ok"_%mindCRLF
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
    if $get(%mindArgs(2))="" set %mindRes="-No JSON provided"_%mindCRLF quit
    ;
    new JSONerr
    ;
    do parse^%mindJSON("%mindArgs(2)",$name(@%mindArgs(1)),"JSONerr")
    if $data(JSONerr) set %mindRes="-Error parsing JSON: "_$get(JSONerr(1))_" "_$get(JSONerr(2))_%mindCRLF quit
    ;
    set %mindRes="+ok"_%mindCRLF
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
    do stringify^%mindJSON($name(@%mindArgs(1)),"JDOM","JSONerr")
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
    set %mindArgs(2)=$get(%mindArgs(2),1)
    set ret=$increment(@%mindArgs(1),%mindArgs(2))
    ;
    set %mindRes=$select($find(ret,"."):",",1:":")_ret_%mindCRLF
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
    set %mindArgs(2)=$get(%mindArgs(2),1)
    set ret=$increment(@%mindArgs(1),-%mindArgs(2))
    ;
    set %mindRes=$select($find(ret,"."):",",1:":")_ret_%mindCRLF
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
    if $get(%mindArgs(2),0)=0 lock +@%mindArgs(1) goto addLockQuit
    if +%mindArgs(2)<0 set %mindRes="-timeout can not be negative" quit
    lock +@%mindArgs(1):%mindArgs(2)
    ;
addLockQuit
    set %mindRes=$select($test:"+ok",1:"-timeout elapsed")_%mindCRLF
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
    lock -@%mindArgs(1)
    ;
    set %mindRes="+ok"_%mindCRLF
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
    set %mindArgs(2)=""""_%mindArgs(2)_""""
    ;
    set char=$zextract(%mindArgs(1),$zlength(%mindArgs(1)),$zlength(%mindArgs(1)))
    if char=")" do
    . set %mindArgs(1)=$zextract(%mindArgs(1),1,$zlength(%mindArgs(1))-1)
    . set:$zextract(%mindArgs(1),$zlength(%mindArgs(1)),$zlength(%mindArgs(1)))'="(" %mindArgs(1)=%mindArgs(1)_","
    . set %mindArgs(1)=%mindArgs(1)_%mindArgs(2)_")"
    else  set %mindArgs(1)=%mindArgs(1)_"("_%mindArgs(2)_")"
    ;
    set res=$order(@%mindArgs(1)),%mindRes=$select($$isNumber^%mindUtils(res):"("_res_%mindCRLF,1:$$buildBlob^%mindRESP3(res))
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
    set %mindArgs(2)=""""_%mindArgs(2)_""""
    ;
    set char=$zextract(%mindArgs(1),$zlength(%mindArgs(1)),$zlength(%mindArgs(1)))
    if char=")" do
    . set %mindArgs(1)=$zextract(%mindArgs(1),1,$zlength(%mindArgs(1))-1)
    . set:$zextract(%mindArgs(1),$zlength(%mindArgs(1)),$zlength(%mindArgs(1)))'="(" %mindArgs(1)=%mindArgs(1)_","
    . set %mindArgs(1)=%mindArgs(1)_%mindArgs(2)_")"
    else  set %mindArgs(1)=%mindArgs(1)_"("_%mindArgs(2)_")"
    ;
    set res=$order(@%mindArgs(1),-1),%mindRes=$select($$isNumber^%mindUtils(res):"("_res_%mindCRLF,1:$$buildBlob^%mindRESP3(res))
    ;
    quit
    ;
    ;
; ************************************************************
; query
; ************************************************************
; parameters:
; 1 glvn
; 2 glvn as string
;
; Returns:
; <RESP3 SIMPLE STRING>
;
; ************************************************************
query
    set res=$query(@$select(%mindArgs(2)="":%mindArgs(1),1:%mindArgs(2))),%mindRes=$$buildBlob^%mindRESP3(res)
    ;
    quit
    ;
    ;
; ************************************************************
; datatype
; ************************************************************
; parameters:
; 1 glvn
;
; Returns:
; <RESP3 SIMPLE STRING>
;
; ************************************************************
datatype
    new res
    new $etrap
    ;
    set $etrap="goto datatypeError"
    ;
    set res=@%mindArgs(1),%mindRes=$select($$isNumber^%mindUtils(res):$select($find(res,"."):"+float",1:"+int"),1:"+string")
    set %mindRes=%mindRes_%mindCRLF
    ;
    quit
    ;
datatypeError
    set %mindRes="+undefined"_%mindCRLF,$ecode=""
    quit
    ;
    ;
