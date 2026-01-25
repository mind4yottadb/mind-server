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
    set res=+$data(@%params(1)),%res=$select(res=1!(res=11):"#t",1:"#f")_CRLF
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
    set res=+$data(@%params(1)),%res=$select(res>9:"#t",1:"#f")_CRLF
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
    set res=$get(@%params(1)),%res=$select($$isNumber^%mindUtils(res):"("_res_CRLF,1:$$buildBlob^%mindRESP3(res))
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
    set res=@%params(1),%res=$select($$isNumber^%mindUtils(res):"("_res_CRLF,1:$$buildBlob^%mindRESP3(res))
    ;
    quit
    ;
readValueError
    set %res="-"_%params(1)_": path not found"_CRLF,$ecode=""
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
    zkill @%params(1)
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
    kill @%params(1)
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
    set %params(2)=$get(%params(2),"^"),%params(3)=$get(%params(3),1),%params(4)=$get(%params(4),%params(3))
    set res=$piece($get(@%params(1)),%params(2),%params(3),%params(4))
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
    set %params(3)=$get(%params(3),"^"),%params(4)=$get(%params(4),1),%params(5)=$get(%params(5),%params(4))
    set $piece(@%params(1),%params(3),%params(4),%params(5))=%params(2)
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
    if $zextract(%params(2),1,1)="$" do
    . set start=$zfind(%params(2),LF),%params(2)=$zextract(%params(2),start,$zlength(%params(2))-2)
    else  set %params(2)=+$zextract(%params(2),2,$zlength(%params(2))-2)
    ;
    set @%params(1)=%params(2),%res="+ok"_CRLF
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
    if $get(%params(2))="" set %res="-No JSON provided"_CRLF quit
    ;
    new JSONerr
    ;
    do parse^%mindJSON("%params(2)",$name(@%params(1)),"JSONerr")
    if $data(JSONerr) set %res="-Error parsing JSON: "_$get(JSONerr(1))_" "_$get(JSONerr(2))_CRLF quit
    ;
    set %res="+ok"_CRLF
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