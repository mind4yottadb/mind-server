;#################################################################
;#                                                               #
;# Copyright (c) 2025 DnaSoft B.V. and/or its subsidiaries.      #
;# All rights reserved.                                          #
;#                                                               #
;#   This source code contains the intellectual property         #
;#   of its copyright holder(s), and is made available           #
;#   under a license.  If you do not know the terms of           #
;#   the license, please stop and do not read further.           #
;#                                                               #
;#################################################################
;
;   writeFile
;   readFile
;   openFile
;   closeFile
;   read
;   write
;   dir
;   tree
;   fileAttr
;
;

readFile
    new file,line,zio,buffer
    ;
    if $get(command(2))="" set %mindRes="*2"_CRLF_"-missing filename"_CRLF_"-the filename has not been provided"_CRLF,%mindRes("status")=0 quit
    ;
    set zio=$zio
    set file=command(2)
    set buffer=""
    open file:(readonly:exception="goto readFileOpenError")
    use file:(exception="goto readFileUse")
    for  read line set buffer=buffer_line_LF
    ;
readFileOpenError
    new err
    ;
    set err=$zpiece($zstatus,",",1)
    if err=150379354 do
    . set %mindRes="*2"_CRLF_"- error opening: "_file_CRLF_"-"_$zpiece($zstatus,",",6)_CRLF,%mindRes("status")=0
    ;
    use zio
    ;
    quit
    ;
readFileUse
    close file
    ;
    set buffer=$extract(buffer,1,$zlength(buffer)-1)
    set %mindRes=$$RESP3getBlob^%mindUtils(buffer),%mindRes("status")=1
    ;
    use zio
    ;
    quit

