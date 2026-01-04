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
    if $get(command(3))="" set %mindRes="-the destination filename has not been provided"_CRLF,%mindRes("status")=0 quit
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
; readDir
; ************************************************************
readDir
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
; ************************************************************
; readTree
; ************************************************************
readTree
    if $get(command(2))="" set %mindRes="-the path has not been provided"_CRLF,%mindRes("status")=0 quit
    if $zsearch(command(2))="" set %mindRes="-the path does not exists"_CRLF,%mindRes("status")=0 quit
    if command(2)="/" set %mindRes="-the path can not be root (/)"_CRLF,%mindRes("status")=0 quit
    ;
    new fileList,ix,res
	new context,fileCount
    ;
	set (context,fileCount)=0
    ;
	do dir(command(2),command(3),.fileList)
	;
	set res=""
	set ix="" for  set ix=$order(fileList(ix)) quit:ix=""  do
	. set res=res_fileList(ix)_","
    ;
    set res=$extract(res,1,$zlength(res)-1)
    set %mindRes=$$RESP3getBlob^%mindUtils(res),%mindRes("status")=1
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
	. . set ret=$&ydbposix.filemodeconst("S_IFDIR",.constDir)
	. . do statfile^%ydbposix(found,.stat)
	. . if stat("mode")\constDir#2 set fileCount=fileCount+1,fileList(fileCount)=found do dir(found,extension,.fileList)
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
; stat
; ************************************************************
stat
    if $get(command(2))="" set %mindRes="-the filename has not been provided"_CRLF,%mindRes("status")=0 quit
    if $zsearch(command(2))="" set %mindRes="-the filename does not exists or it is not accessible"_CRLF,%mindRes("status")=0 quit
    ;
    new stat,ix,cnt
    ;
    set ret=$$statfile^%ydbposix(command(2),.stat)
    if ret set %mindRes="-error: "_ret_" received from stat()"_CRLF,%mindRes("status")=0 quit
    ;
    set cnt=0,ix="" for  set ix=$order(stat(ix)) quit:ix=""  do
    . set %mindRes=%mindRes_"+"_ix_CRLF_"+"_stat(ix)_CRLF
    . set cnt=cnt+1
	;
    set %mindRes="%"_cnt_CRLF_%mindRes,%mindRes("status")=1
    ;
    quit
    ;
    ;
; ************************************************************
; copyfile
; ************************************************************
copyfile
    new path,ret,stat,constDir
    ;
    if $get(command(2))="" set %mindRes="-the source filename has not been provided"_CRLF,%mindRes("status")=0 quit
    if $zsearch(command(2))="" set %mindRes="-the source filename does not exists or it is not accessible"_CRLF,%mindRes("status")=0 quit
    ; verify that is it not a valid directory only
	set ret=$&ydbposix.filemodeconst("S_IFDIR",.constDir)
	do statfile^%ydbposix(command(2),.stat)
	if stat("mode")\constDir#2 set %mindRes="-the source filename can not be a directory"_CRLF,%mindRes("status")=0 quit
    ;
    if $get(command(3))="" set %mindRes="-the destination filename has not been provided"_CRLF,%mindRes("status")=0 quit
    set path=$zparse(command(3),"DIRECTORY")
    if $zsearch(path)="" set %mindRes="-the path of the destination is not valid"_CRLF,%mindRes("status")=0 quit
	set ret=$&ydbposix.filemodeconst("S_IFDIR",.constDir)
	do statfile^%ydbposix(command(3),.stat)
	if stat("mode")\constDir#2 set %mindRes="-the destination filename can not be a directory"_CRLF,%mindRes("status")=0 quit
    ;
    do cp^%ydbposix(command(2),command(3))
    ;
    set %mindRes="+ok"_CRLF,%mindRes("status")=1
    ;
    quit
    ;
    ;
; ************************************************************
; mkdir
; ************************************************************
mkdir
    if $get(command(2))="" set %mindRes="-the path has not been provided"_CRLF,%mindRes("status")=0 quit
    set path=$zpiece(command(2),"/",1,$zlength(command(2),"/")-1)
    if $zsearch(path)="" set %mindRes="-the path is not valid"_CRLF,%mindRes("status")=0 quit
    if $zsearch(command(2))'="" set %mindRes="-the path already exists"_CRLF,%mindRes("status")=0 quit
    ;
    new mode
    ;
    set mode="S_IRWXU"
    ;
    set ret=$$mkdir^%ydbposix(command(2),mode)
    if ret set %mindRes="-error: "_ret_" while creating the directory"_CRLF,%mindRes("status")=0 quit
    ;
    set %mindRes="+ok"_CRLF,%mindRes("status")=1
    ;
    quit
    ;
    ;
; ************************************************************
; expandPath
; ************************************************************
expandPath
    if $get(command(2))="" set %mindRes="-the path can not be empty"_CRLF,%mindRes("status")=0 quit
    ;
    set ret=$zsearch(command(2))
    ;
    if ret="" set %mindRes="-path could not be resolved"_CRLF,%mindRes("status")=0 quit
    ;
    set %mindRes="+"_ret_CRLF,%mindRes("status")=1
    ;
    quit
    ;
    ;
; ************************************************************
; rmdir
; ************************************************************
rmdir
    if $get(command(2))="" set %mindRes="-the path can not be empty"_CRLF,%mindRes("status")=0 quit
    if $zsearch(command(2))="" set %mindRes="-the path does not exists"_CRLF,%mindRes("status")=0 quit
    ;
    new path
    ;
    set path=command(2)
    set path=path_$select($zextract(path,$zlength(path),$zlength(path))="/":"",1:"/")_"*.*"
    set ret=$zsearch(path)
    if ret'="" set %mindRes="-the directory is not empty"_CRLF,%mindRes("status")=0 quit
    ;
    do rmdir^%ydbposix(command(2))
    set %mindRes="+ok"_CRLF,%mindRes("status")=1
    ;
    quit