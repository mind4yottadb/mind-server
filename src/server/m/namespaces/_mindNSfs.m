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
; parameters:
; 1 filename
;
; Returns:
; <RESP3 BLOB> {file content}
;
; ************************************************************
readFile
    new file,line,buffer
    ;
    if $get(%mindArgs(1))="" set %mindRes="-the filename has not been provided"_%mindCRLF quit
    ;
    set file=%mindArgs(1)
    set buffer=""
    open file:(readonly:exception="goto readFileOpenError")
    use file:(exception="goto readFileUse")
    for  read line set buffer=buffer_$ztranslate(line,$zchar(13),"")_LF
    ;
readFileOpenError
    set %mindRes="-error opening: "_file_": "_$zpiece($zstatus,",",6)_%mindCRLF
    ;
    quit
    ;
readFileUse
    close file
    ;
    set buffer=$extract(buffer,1,$zlength(buffer)-1)
    set %mindRes=$$buildBlob^%mindRESP3(buffer)
    ;
    quit
    ;
    ;
; ************************************************************
; writeFile
; ************************************************************
; parameters:
; 1 filename
; 1 data
;
; Returns:
; <RESP3 SINGLE STRING> ok
;
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
; parameters:
; 1 filename
; 1 data
;
; Returns:
; <RESP3 SINGLE STRING> ok
;
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
    if $get(%mindArgs(1))="" set %mindRes="-the filename has not been provided"_%mindCRLF quit
    ;
    set file=%mindArgs(1)
    ;
    set cmd="("_cursor_":exception=""goto writeToFileOpenError"")"
    open file:@cmd
    use file
    write %mindArgs(2)
    close file
    ;
    set %mindRes="+ok"_%mindCRLF
    ;
    quit
    ;
writeToFileOpenError
    new err
    ;
    set err=$zpiece($zstatus,",",1)
    if err=150379354 do
    . set %mindRes="-error opening: "_file_": "_$zpiece($zstatus,",",6)_%mindCRLF
    ;
    quit
    ;
    ;
; ************************************************************
; removeFile
; ************************************************************
; parameters:
; 1 filename
;
; Returns:
; <RESP3 SINGLE STRING> ok
;
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
; parameters:
; 1 filename
; 1 data
;
; Returns:
; <RESP3 SINGLE STRING> ok
;
; ************************************************************
renameFile
    new opCode,path,destination
    ;
    if $get(%mindArgs(2))="" set %mindRes="-the destination filename has not been provided"_%mindCRLF quit
    ;
    set destination=$zsearch($zparse(%mindArgs(2),"DIRECTORY"),-1)
    if destination="" set %mindRes="-the destination path could not be found"_%mindCRLF quit
    ;
    set opCode="REPLACE="""_destination_"/"_$zparse(%mindArgs(2),"NAME")_$zparse(%mindArgs(2),"TYPE")_""""
    ;
    goto processFile
    ;
processFile
    new file,cmd,source
    ;
    if $get(%mindArgs(1))="" set %mindRes="-the source filename has not been provided"_%mindCRLF quit
    ;
    set source=$zsearch(%mindArgs(1),-1)
    if source="" set %mindRes="-the source filename could not be found"_%mindCRLF quit
    ;
    set file=%mindArgs(1)
    open file:(readonly:exception="goto processOpenError")
    use file
    set cmd="("_opCode_":exception=""goto processCloseError"")"
    close file:@cmd
    ;
    set %mindRes="+ok"_%mindCRLF
    ;
    quit
    ;
processOpenError
    set %mindRes="-error opening: "_file_": "_$zpiece($zstatus,",",6)_%mindCRLF
    ;
    quit
    ;
processCloseError
    set %mindRes="-error "_$select(opCode'="DELETE":"renaming",1:"deleting")_": "_file_": "_$zpiece($zstatus,",",4,6)_%mindCRLF
    ;
    quit
    ;
    ;
; ************************************************************
; readDir
; ************************************************************
; parameters:
; 1 path
; 2 mask
;
; Returns:
; <RESP3 ARRAY> {dir content}
;
; ************************************************************
readDir
    if $get(%mindArgs(1))="" set %mindRes="-the path has not been provided"_%mindCRLF quit
    if $zsearch(%mindArgs(1))="" set %mindRes="-the path does not exists"_%mindCRLF quit
    ;
    new val,path,dir
    ;
    set:$get(%mindArgs(2))="" %mindArgs(2)="*.*"
    set dir=""
    set path=$select($zextract(%mindArgs(1),$zlength(%mindArgs(1)),$zlength(%mindArgs(1)))="/":%mindArgs(1)_%mindArgs(2),1:%mindArgs(1)_"/"_%mindArgs(2))
    set val=$zsearch("/*.null")
    for  set val=$zsearch(path) quit:val=""  set dir=dir_$zparse(val,"NAME")_$zparse(val,"TYPE")_","
    set dir=$zextract(dir,1,$zlength(dir)-1)
    ;
    set %mindRes=$$buildBlob^%mindRESP3(dir)
    ;
    quit
    ;
; ************************************************************
; readTree
; ************************************************************
; parameters:
; 1 path
; 2 mask
;
; Returns:
; <RESP3 ARRAY> {tree content}
;
; ************************************************************
readTree
    if $get(%mindArgs(1))="" set %mindRes="-the path has not been provided"_%mindCRLF quit
    if $zsearch(%mindArgs(1))="" set %mindRes="-the path does not exists"_%mindCRLF quit
    if %mindArgs(1)="/" set %mindRes="-the path can not be root (/)"_%mindCRLF quit
    ;
    new fileList,ix,res
	new context,fileCount
    ;
	set (context,fileCount)=0
    ;
	do dir(%mindArgs(1),%mindArgs(2),.fileList)
	;
	set res=""
	set ix="" for  set ix=$order(fileList(ix)) quit:ix=""  do
	. set res=res_fileList(ix)_","
    ;
    set res=$extract(res,1,$zlength(res)-1)
    set %mindRes=$$buildBlob^%mindRESP3(res)
    ;
    quit
    ;
dir(path,extension,fileList)
	new found,ret,constDir,stat
	;
	quit:context=255
	set context=context+1
	;
	if $extract(path,$length(path))'="/" set path=path_"/"
	set path=path_"*"
	;
	for  set found=$zsearch(path,context) quit:found=""  do
	. if extension="" do  quit
	. . if $$isDir^%mindUtils(found) set fileCount=fileCount+1,fileList(fileCount)=found do dir(found,extension,.fileList)
	. if extension="*.*" set fileCount=fileCount+1,fileList(fileCount)=found do dir(found,extension,.fileList) quit
	. if extension="*",$find(found,".")=0 set fileCount=fileCount+1,fileList(fileCount)=found do dir(found,extension,.fileList) quit
	. if $zextract(found,$zlength(found)-$zlength(extension)+2,$zlength(found))'=$zextract(extension,2,$zlength(extension)) do dir(found,extension,.fileList) quit
	. set:extension'="*" fileCount=fileCount+1,fileList(fileCount)=found
	;
	set context=context-1
	;
	quit
	;
	;
; ************************************************************
; isDir
; ************************************************************
; parameters:
; 1 filename
;
; Returns:
; <RESP3 BOOLEAN>
;
; ************************************************************
isDir
    if $get(%mindArgs(1))="" set %mindRes="-the filename has not been provided"_%mindCRLF quit
    if $zsearch(%mindArgs(1))="" set %mindRes="-the filename does not exists or it is not accessible"_%mindCRLF quit
    ;
	set %mindRes="#"_$select($$isDir^%mindUtils(%mindArgs(1)):"t",1:"f")_%mindCRLF
    ;
	quit
    ;
    ;
; ************************************************************
; isFile
; ************************************************************
; parameters:
; 1 filename
;
; Returns:
; <RESP3 BOOLEAN>
;
; ************************************************************
isFile
    if $get(%mindArgs(1))="" set %mindRes="-the filename has not been provided"_%mindCRLF quit
    if $zsearch(%mindArgs(1))="" set %mindRes="-the filename does not exists or it is not accessible"_%mindCRLF quit
    ;
	set %mindRes="#"_$select($$isFile^%mindUtils(%mindArgs(1)):"t",1:"f")_%mindCRLF
    ;
	quit
    ;
    ;
; ************************************************************
; stat
; ************************************************************
; parameters:
; 1 filename
;
; Returns:
; <RESP3 MAP>
;
; ************************************************************
stat
    new expandedFile
    ;
    if $get(%mindArgs(1))="" set %mindRes="-the filename has not been provided"_%mindCRLF quit
    set expandedFile=$zsearch(%mindArgs(1),-1)
    if expandedFile="" set %mindRes="-the filename does not exists or it is not accessible"_%mindCRLF quit
    ;
    new stat,ix,cnt
    ;
    set ret=$$statfile^%ydbposix(expandedFile,.stat)
    if ret set %mindRes="-error: "_ret_" received from stat()"_%mindCRLF quit
    ;
    set cnt=0,ix="" for  set ix=$order(stat(ix)) quit:ix=""  do
    . set %mindRes=%mindRes_"+"_ix_%mindCRLF_"+"_stat(ix)_%mindCRLF
    . set cnt=cnt+1
	;
    set %mindRes="%"_cnt_%mindCRLF_%mindRes
    ;
    quit
    ;
    ;
; ************************************************************
; copyfile
; ************************************************************
; parameters:
; 1 source path
; 2 destination path
;
; Returns:
; <RESP3 SIMPLE STRING> ok
;
; ************************************************************
copyfile
    new path,ret,stat,constDir,source,destination
    ;
    if $get(%mindArgs(1))="" set %mindRes="-the source filename has not been provided"_%mindCRLF quit
    if $zsearch(%mindArgs(1),-1)="" set %mindRes="-the source filename does not exists or it is not accessible"_%mindCRLF quit
    ;
    ; verify that is it not a valid directory only
	if $$isDir^%mindUtils(%mindArgs(1)) set %mindRes="-the source filename can not be a directory"_%mindCRLF quit
    ;
    if $get(%mindArgs(2))="" set %mindRes="-the destination filename has not been provided"_%mindCRLF quit
    set path=$zparse(%mindArgs(2),"DIRECTORY")
    if $zsearch(path,-1)="" set %mindRes="-the path of the destination is not valid"_%mindCRLF quit
	if $$isDir^%mindUtils(%mindArgs(2)) set %mindRes="-the destination filename can not be a directory"_%mindCRLF quit
    ;
    ; expand the path if necessary
    set %mindArgs(1)=$zsearch(%mindArgs(1),-1)
	if %mindArgs(1)="" set %mindRes="-the source filename can not be found"_%mindCRLF quit
    ;
    set destination=$zsearch($zparse(%mindArgs(2),"DIRECTORY"),-1)
	if destination="" set %mindRes="-the destination filename can not be found"_%mindCRLF quit
	;
    ;
    do cp^%ydbposix(%mindArgs(1),destination_"/"_$zparse(%mindArgs(2),"NAME")_$zparse(%mindArgs(2),"TYPE"))
    ;
    set %mindRes="+ok"_%mindCRLF
    ;
    quit
    ;
    ;
; ************************************************************
; mkdir
; ************************************************************
; parameters:
; 1 path
;
; Returns:
; <RESP3 SIMPLE STRING> ok
;
; ************************************************************
mkdir
    new path
    ;
    if $get(%mindArgs(1))="" set %mindRes="-the path has not been provided"_%mindCRLF quit
    set path=$zpiece(%mindArgs(1),"/",1,$zlength(%mindArgs(1),"/")-1)
    if $zsearch(path)="" set %mindRes="-the path is not valid"_%mindCRLF quit
    if $zsearch(%mindArgs(1),-1)'="" set %mindRes="-the path already exists"_%mindCRLF quit
    ;
    new mode
    ;
    set mode="S_IRWXU"
    ;
    do log^%mindLogger($zsearch(path,-1)_"/"_$zpiece(%mindArgs(1),"/",$zlength(%mindArgs(1),"/")))
    set ret=$$mkdir^%ydbposix($zsearch(path,-1)_"/"_$zpiece(%mindArgs(1),"/",$zlength(%mindArgs(1),"/")),mode)
    if ret set %mindRes="-error: "_ret_" while creating the directory"_%mindCRLF quit
    ;
    set %mindRes="+ok"_%mindCRLF
    ;
    quit
    ;
    ;
; ************************************************************
; expandPath
; ************************************************************
; parameters:
; 1 path
;
; Returns:
; <RESP3 SIMPLE STRING> <new path>>
;
; ************************************************************
expandPath
    if $get(%mindArgs(1))="" set %mindRes="-the path can not be empty"_%mindCRLF quit
    ;
    set ret=$zsearch(%mindArgs(1),-1)
    ;
    if ret="" set %mindRes="-path could not be resolved"_%mindCRLF quit
    ;
    set %mindRes="+"_ret_%mindCRLF
    ;
    quit
    ;
    ;
; ************************************************************
; rmdir
; ************************************************************
; parameters:
; 1 path
;
; Returns:
; <RESP3 SIMPLE STRING> ok
;
; ************************************************************
rmdir
    if $get(%mindArgs(1))="" set %mindRes="-the path can not be empty"_%mindCRLF quit
    if $zsearch(%mindArgs(1),-1)="" set %mindRes="-the path does not exists"_%mindCRLF quit
    ;
    new path
    ;
    set path=%mindArgs(1)
    set path=path_$select($zextract(path,$zlength(path),$zlength(path))="/":"",1:"/")_"*.*"
    set ret=$zsearch(path,-1)
    if ret'="" set %mindRes="-the directory is not empty"_%mindCRLF quit
    ;
    do rmdir^%ydbposix($zsearch(%mindArgs(1),-1))
    set %mindRes="+ok"_%mindCRLF
    ;
    quit