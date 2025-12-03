	;#################################################################
	;#                                                               #
	;# Copyright (c) 2025 DnaSoft BV and/or its subsidiaries.        #
	;# All rights reserved.                                          #
	;#                                                               #
	;#   This source code contains the intellectual property         #
	;#   of its copyright holder(s), and is made available           #
	;#   under a license.  If you do not know the terms of           #
	;#   the license, please stop and do not read further.           #
	;#                                                               #
	;#################################################################
	;
	new fileList,path,extension,ix,objectPath,file,trm,callVersion
	;
	set callVersion="1.0"
	set objectPath="/opt/mind/o/"
	set extension="*.m"
	;
	do set^terminal
	;
	write trm("bgnd_black"),!
	;
	write trm("B89"),"                           ",trm("bgnd_black")_trm("F127")_"                                "_trm("B89"),"                           ",trm("bgnd_black"),!
	write trm("B90"),"                           ",trm("bgnd_black")_trm("F127")_"                                "_trm("B90"),"                           ",trm("bgnd_black"),!
	write trm("B91"),"         DNA Soft          ",trm("bgnd_black")_trm("F127")_"  M++ Compile All Version "_callVersion_"   "_trm("B91"),"          DNA Soft         ",trm("bgnd_black"),!
	write trm("B92"),"                           ",trm("bgnd_black")_trm("F127")_"                                "_trm("B92"),"                           ",trm("bgnd_black"),!
	write trm("B93"),"                           ",trm("bgnd_black")_trm("F127")_"                                "_trm("B93"),"                           ",trm("bgnd_black"),!
	;
	write trm("bgnd_black"),!
	;
	write trm("yellow"),"Object path: ",trm("light_cyan"),objectPath,!
	write trm("yellow"),"Extension:   ",trm("light_cyan"),extension,!
	;
	do drawLine^terminal
	;
	write !,trm("light_magenta"),"Processing tree...",!!
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
	. . zcompile "-object="_objectPath_$zparse(file,"NAME")_".o "_file
	. . if $ZCSTATUS=1 write !,trm("bgnd_black"),trm("yellow")_"Compiled: "_trm("cyan")_file_trm("yellow"),?90," into:",trm("cyan"),objectPath_$zparse(file,"NAME")_".o ",!
	. . else  write trm("bgnd_red")_trm("light_yellow")_"ERROR compiling source: ",trm("light_blue"),trm("bgnd_black"),file,!
	;
	write !
	;
	do drawLine^terminal
	;	
	write trm("tty_reset"),!
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
	;
	;
	;