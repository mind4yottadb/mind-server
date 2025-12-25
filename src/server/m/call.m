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
; This file compiles all the .m files in the tree under: ./m and saves the object files into "objectPath"
;
	new fileList,path,extension,ix,objectPath,file,trm,callVersion
	new compilerFlags
	new $etrap,level
	;
	; setup error trap to reset terminal
	set level=$zlevel
	set $etrap="zgoto level:callError"
	;
	set callVersion="1.1"
	set objectPath="/opt/mind/o/"
	set extension="*.m"
	set compilerFlags="-embed_source "
	;
	do set^%mindTerminal
	;
	write %mindTrm("bgnd_black"),!
	;
	write %mindTrm("B91"),"         DnaSoft B.V.          ",%mindTrm("bgnd_black"),!,%mindTrm("F127")_"  mind Compile All Version "_callVersion_"   "_%mindTrm("B91"),%mindTrm("bgnd_black"),!
		;
	write %mindTrm("bgnd_black"),!
	;
	write %mindTrm("yellow"),"Object path:    ",%mindTrm("light_cyan"),objectPath,!
	write %mindTrm("yellow"),"Extension:      ",%mindTrm("light_cyan"),extension,!
	write %mindTrm("yellow"),"Compiler flags: ",%mindTrm("light_cyan"),compilerFlags,!
	;
	do drawLine^%mindTerminal
	;
	write !,%mindTrm("light_magenta"),"Processing tree...",!!
	;
	; Perform the compilation
	for path="/opt/mind/m/" do
	. set ix=0
	. kill fileList
	. ;
	. do tree(path,extension,.fileList)
	. ;
	. set ix="" for  set ix=$order(fileList(ix)) quit:ix=""  do
	. . set file=fileList(ix)
	. . zcompile compilerFlags_"-object="_objectPath_$zparse(file,"NAME")_".o "_file
	. . if $ZCSTATUS=1 write %mindTrm("bgnd_black"),%mindTrm("yellow")_"Compiled: ",?15,%mindTrm("cyan")_file_%mindTrm("yellow"),! ;,"into:",?10,%mindTrm("cyan"),objectPath_$zparse(file,"NAME")_".o "
	. . else  write %mindTrm("bgnd_red")_%mindTrm("light_yellow")_"ERROR compiling source: ",%mindTrm("light_blue"),%mindTrm("bgnd_black"),file
	;
callError
	do drawLine^%mindTerminal
	;
	write %mindTrm("tty_reset"),!
	;
	;
	quit
	;
tree(path,extension,fileList)
	new context,fileCount
	;
	set context=0,fileCount=0
	do dir(path,extension,.fileList)
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
	. if $zextract(found,$zlength(found)-1,$zlength(found))'=$zextract(extension,2,$zlength(extension))  do dir(found,extension,.fileList) quit
	. set fileCount=fileCount+1,fileList(fileCount)=found
	;
	set context=context-1
	;
	quit
	;