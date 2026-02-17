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
    if $get(%args(1))="" set %res="-the filename has not been provided"_CRLF quit
    ;
    set file=%args(1)
    set buffer=""
    open file:(readonly:exception="goto readFileOpenError")
    use file:(exception="goto readFileUse")
    for  read line set buffer=buffer_line_LF
    ;
readFileOpenError
    set %res="-error opening: "_file_": "_$zpiece($zstatus,",",6)_CRLF
    ;
    quit
    ;
readFileUse
    close file
    ;
    set buffer=$extract(buffer,1,$zlength(buffer)-1)
    set %res=$$buildBlob^%mindRESP3(buffer)
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
    if $get(%args(1))="" set %res="-the filename has not been provided"_CRLF quit
    ;
    set file=%args(1)
    ;
    set cmd="("_cursor_":exception=""goto writeToFileOpenError"")"
    open file:@cmd
    use file
    write %args(2)
    close file
    ;
    set %res="+ok"_CRLF
    ;
    quit
    ;
writeToFileOpenError
    new err
    ;
    set err=$zpiece($zstatus,",",1)
    if err=150379354 do
    . set %res="-error opening: "_file_": "_$zpiece($zstatus,",",6)_CRLF
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
    new opCode,path
    ;
    if $get(%args(2))="" set %res="-the destination filename has not been provided"_CRLF quit
    ;
    set opCode="REPLACE="""_%args(2)_""""
    ;
    goto processFile
    ;
processFile
    new file,cmd
    ;
    if $get(%args(1))="" set %res="-the filename has not been provided"_CRLF quit
    ;
    set file=%args(1)
    open file:(readonly:exception="goto processOpenError")
    use file
    set cmd="("_opCode_":exception=""goto processCloseError"")"
    close file:@cmd
    ;
    set %res="+ok"_CRLF
    ;
    quit
    ;
processOpenError
    set %res="-error opening: "_file_": "_$zpiece($zstatus,",",6)_CRLF
    ;
    quit
    ;
processCloseError
    set %res="-error "_$select(opCode="REPLACE":"renaming",1:"deleting")_": "_file_": "_$zpiece($zstatus,",",6)_CRLF
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
    if $get(%args(1))="" set %res="-the path has not been provided"_CRLF quit
    if $zsearch(%args(1))="" set %res="-the path does not exists"_CRLF quit
    ;
    new val,path,dir
    ;
    set:$get(%args(2))="" %args(2)="*.*"
    set dir=""
    set path=$select($zextract(%args(1),$zlength(%args(1)),$zlength(%args(1)))="/":%args(1)_%args(2),1:%args(1)_"/"_%args(2))
    set val=$zsearch("/*.null")
    for  set val=$zsearch(path) quit:val=""  set dir=dir_$zparse(val,"NAME")_$zparse(val,"TYPE")_","
    set dir=$zextract(dir,1,$zlength(dir)-1)
    ;
    set %res=$$buildBlob^%mindRESP3(dir)
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
    if $get(%args(1))="" set %res="-the path has not been provided"_CRLF quit
    if $zsearch(%args(1))="" set %res="-the path does not exists"_CRLF quit
    if %args(1)="/" set %res="-the path can not be root (/)"_CRLF quit
    ;
    new fileList,ix,res
	new context,fileCount
    ;
	set (context,fileCount)=0
    ;
	do dir(%args(1),%args(2),.fileList)
	;
	set res=""
	set ix="" for  set ix=$order(fileList(ix)) quit:ix=""  do
	. set res=res_fileList(ix)_","
    ;
    set res=$extract(res,1,$zlength(res)-1)
    set %res=$$buildBlob^%mindRESP3(res)
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
    if $get(%args(1))="" set %res="-the filename has not been provided"_CRLF quit
    if $zsearch(%args(1))="" set %res="-the filename does not exists or it is not accessible"_CRLF quit
    ;
    new ret,constDir
    ;
    set ret=$&ydbposix.filemodeconst("S_IFDIR",.constDir)
	do statfile^%ydbposix(%args(1),.stat)
	;
	set %res="#"_$select(stat("mode")\constDir#2:"t",1:"f")_CRLF
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
    if $get(%args(1))="" set %res="-the filename has not been provided"_CRLF quit
    if $zsearch(%args(1))="" set %res="-the filename does not exists or it is not accessible"_CRLF quit
    ;
    new stat
    ;
	do statfile^%ydbposix(%args(1),.stat)
	;
	set %res="#"_$select(stat("mode")=0:"t",1:"f")_CRLF
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
    if $get(%args(1))="" set %res="-the filename has not been provided"_CRLF quit
    if $zsearch(%args(1))="" set %res="-the filename does not exists or it is not accessible"_CRLF quit
    ;
    new stat,ix,cnt
    ;
    set ret=$$statfile^%ydbposix(%args(1),.stat)
    if ret set %res="-error: "_ret_" received from stat()"_CRLF quit
    ;
    set cnt=0,ix="" for  set ix=$order(stat(ix)) quit:ix=""  do
    . set %res=%res_"+"_ix_CRLF_"+"_stat(ix)_CRLF
    . set cnt=cnt+1
	;
    set %res="%"_cnt_CRLF_%res
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
    new path,ret,stat,constDir
    ;
    if $get(%args(1))="" set %res="-the source filename has not been provided"_CRLF quit
    if $zsearch(%args(1))="" set %res="-the source filename does not exists or it is not accessible"_CRLF quit
    ;
    ; verify that is it not a valid directory only
	set ret=$&ydbposix.filemodeconst("S_IFDIR",.constDir)
	do statfile^%ydbposix(%args(1),.stat)
	if stat("mode")\constDir#2 set %res="-the source filename can not be a directory"_CRLF quit
    ;
    if $get(%args(2))="" set %res="-the destination filename has not been provided"_CRLF quit
    set path=$zparse(%args(2),"DIRECTORY")
    if $zsearch(path)="" set %res="-the path of the destination is not valid"_CRLF quit
	set ret=$&ydbposix.filemodeconst("S_IFDIR",.constDir)
	do statfile^%ydbposix(%args(2),.stat)
	if stat("mode")\constDir#2 set %res="-the destination filename can not be a directory"_CRLF quit
    ;
    do cp^%ydbposix(%args(1),%args(2))
    ;
    set %res="+ok"_CRLF
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
    if $get(%args(1))="" set %res="-the path has not been provided"_CRLF quit
    set path=$zpiece(%args(1),"/",1,$zlength(%args(1),"/")-1)
    if $zsearch(path)="" set %res="-the path is not valid"_CRLF quit
    if $zsearch(%args(1))'="" set %res="-the path already exists"_CRLF quit
    ;
    new mode
    ;
    set mode="S_IRWXU"
    ;
    set ret=$$mkdir^%ydbposix(%args(1),mode)
    if ret set %res="-error: "_ret_" while creating the directory"_CRLF quit
    ;
    set %res="+ok"_CRLF
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
    if $get(%args(1))="" set %res="-the path can not be empty"_CRLF quit
    ;
    set ret=$zsearch(%args(1))
    ;
    if ret="" set %res="-path could not be resolved"_CRLF quit
    ;
    set %res="+"_ret_CRLF
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
    if $get(%args(1))="" set %res="-the path can not be empty"_CRLF quit
    if $zsearch(%args(1))="" set %res="-the path does not exists"_CRLF quit
    ;
    new path
    ;
    set path=%args(1)
    set path=path_$select($zextract(path,$zlength(path),$zlength(path))="/":"",1:"/")_"*.*"
    set ret=$zsearch(path)
    if ret'="" set %res="-the directory is not empty"_CRLF quit
    ;
    do rmdir^%ydbposix(%args(1))
    set %res="+ok"_CRLF
    ;
    quit