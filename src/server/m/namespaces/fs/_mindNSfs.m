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
; ************************************************************
; readFile
; ************************************************************
readFile
    new file,line,buffer
    ;
    if $get(command(2))="" set %mindRes="-the filename has not been provided"_CRLF,%mindRes("status")=0 quit
    ;
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
    . set %mindRes="-error opening: "_file_": "_$zpiece($zstatus,",",6)_CRLF,%mindRes("status")=0
    ;
    quit
    ;
readFileUse
    close file
    ;
    set buffer=$extract(buffer,1,$zlength(buffer)-1)
    set %mindRes=$$RESP3getBlob^%mindUtils(buffer),%mindRes("status")=1
    ;
    quit
    ;
    ;
; ************************************************************
; writeFile
; ************************************************************
writeFile
    new cursor
    ;
    set cursor="NEWVERSION"
    ;
    goto writeToFile
    ;
; ************************************************************
; appendFile
; ************************************************************
appendFile
    new cursor,cmd
    ;
    set cursor="APPEND"
    ;
    goto writeToFile
    ;
writeToFile
    new file,line,buffer
    ;
    if $get(command(2))="" set %mindRes="-the filename has not been provided"_CRLF,%mindRes("status")=0 quit
    ;
    set file=command(2)
    ;
    set cmd="("_cursor_":exception=""goto writeToFileOpenError"")"
    open file:@cmd
    use file
    write command(3)
    close file
    ;
    set %mindRes="+ok"_CRLF,%mindRes("status")=1
    ;
    quit
    ;
writeToFileOpenError
    new err
    ;
    set err=$zpiece($zstatus,",",1)
    if err=150379354 do
    . set %mindRes="-error opening: "_file_": "_$zpiece($zstatus,",",6)_CRLF,%mindRes("status")=0
    ;
    quit
    ;
    ;

