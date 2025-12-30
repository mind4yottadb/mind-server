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
    set %mindRes="-error opening: "_file_": "_$zpiece($zstatus,",",6)_CRLF,%mindRes("status")=0
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
; ************************************************************
; readdir
; ************************************************************
readdir
    if $get(command(2))="" set %mindRes="-the path has not been provided"_CRLF,%mindRes("status")=0 quit
    if $zsearch(command(2))="" set %mindRes="-the path does not exists"_CRLF,%mindRes("status")=0 quit
    ;
    new val,path,dir
    ;
    set:$get(command(3))="" command(3)="*"
    set dir=""
    set path=$select($zextract(command(2),$zlength(command(2)),$zlength(command(2)))="/":command(2)_command(3),1:command(2)_"/"_command(3))
    set val=$zsearch("/*.null")
    for  set val=$zsearch(path) quit:val=""  set dir=dir_$zparse(val,"NAME")_$zparse(val,"TYPE")_","
    set dir=$zextract(dir,1,$zlength(dir)-1)
    ;
    set %mindRes=$$RESP3getBlob^%mindUtils(dir),%mindRes("status")=1
    ;
    quit
    ;
    ;
; ************************************************************
; removeFile
; ************************************************************
removeFile
    new opCode
    ;
    set opCode="DELETE"
    ;
    goto processFile
    ;
; ************************************************************
; renameFile
; ************************************************************
renameFile
    new opCode,path
    ;
    if $get(command(3))="" set %mindRes="-the new filename has not been provided"_CRLF,%mindRes("status")=0 quit
    set path=$zparse(command(3),"DIRECTORY")
    if $zsearch(path)="" set %mindRes="-the path of the new filename is not valid"_CRLF,%mindRes("status")=0 quit
    ;
    set opCode="REPLACE="""_command(3)_""""
    ;
    goto processFile
    ;
processFile
    new file,cmd
    ;
    if $get(command(2))="" set %mindRes="-the filename has not been provided"_CRLF,%mindRes("status")=0 quit
    ;
    do log^%mindLogger("proceeding")
    set file=command(2)
    open file:(readonly:exception="goto processOpenError")
    use file
    set cmd="("_opCode_":exception=""goto processCloseError"")"
    close file:@cmd
    ;
    set %mindRes="+ok"_CRLF,%mindRes("status")=1
    ;
    quit
    ;
processOpenError
    set %mindRes="-error opening: "_file_": "_$zpiece($zstatus,",",6)_CRLF,%mindRes("status")=0
    ;
    quit
    ;
processCloseError
    set %mindRes="-error "_$select(opCode="REPLACE":"renaming",1:"deleting")_": "_file_": "_$zpiece($zstatus,",",6)_CRLF,%mindRes("status")=0
    ;
    quit
    ;
    ;
; ************************************************************
; readtree
; ************************************************************
readtree
    if $get(command(2))="" set %mindRes="-the path has not been provided"_CRLF,%mindRes("status")=0 quit
    if $zsearch(command(2))="" set %mindRes="-the path does not exists"_CRLF,%mindRes("status")=0 quit
    ;
    new fileList,ix
	new context,fileCount
    ;
    set:$get(command(3))="" command(3)="*.*"
	;
	set (context,fileCount)=0
    ;
	do log^%mindLogger(command(2)_" "_command(3))
	do dir(command(2),command(3),.fileList)
	;
	set %mindRes=""
	set ix="" for  set ix=$order(fileList(ix)) quit:ix=""  do
	. set %mindRes=%mindRes_fileList(ix)_","
    ;
    set %mindRes=$extract(%mindRes,1,$zlength(%mindRes)-1)
    set %mindRes=$$RESP3getBlob^%mindUtils(%mindRes),%mindRes("status")=1
    ;
    quit
    ;
dir(path,extension,fileList)
	new found
	;
	quit:context=255
	set context=context+1
	;
	if $extract(path,$length(path))'="/" set path=path_"/"
	set path=path_"*"
	;
	for  set found=$zsearch(path,context) quit:found=""  do
	. if extension="*.*" set fileCount=fileCount+1,fileList(fileCount)=found do dir(found,extension,.fileList) quit
	. if extension="*",$find(found,".")=0 set fileCount=fileCount+1,fileList(fileCount)=found do dir(found,extension,.fileList) quit
	. if $zextract(found,$zlength(found)-$zlength(extension)+2,$zlength(found))'=$zextract(extension,2,$zlength(extension)) do dir(found,extension,.fileList) quit
	. set:extension'="*" fileCount=fileCount+1,fileList(fileCount)=found
	;
	set context=context-1
	;
	quit
	;