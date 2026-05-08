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
; ****************************************************************
; runShell
; ****************************************************************
runShell(command,return,shell)
	; The shell parameter is used to use an alternative shell (like bash)
	new device,counter,string,currentdevice
	;
	set shell=$get(shell,"/bin/sh")
	set counter=0
	set currentdevice=$io
	set device="runshellcommmandpipe"_$job
	;
	open device:(shell=shell:command=command:readonly):5:"pipe"
	use device
	for  quit:$zeof=1  read string set return($increment(counter))=string
	close device if $get(return(counter))="" kill return(counter)
	use currentdevice
	quit $zclose
	;
	;
isNumber(str)
    quit $zlength(str)&($char(0)]]str)
    ;
    ;
isBoolean(str)
    quit:$find(str,$zchar(0)_"true")!($find(str,$zchar(0)_"false"))!($find(str,$zchar(0)_"null")) 1
    ;
    quit 0
    ;
    ;
isValidApiName(str)
    new char0,ix,ret,char
    ;
    quit:$zlength(str)<3!($zlength(str)>32) 0
    ;
    set char0=$extract(str,1,1)
    set ret=char0?.A
    if ret=0,char0'="_" quit 0
    ;
    set ret=1
    for ix=2:1:$zlength(str) do  quit:ret=0
    . set char=$zextract(str,ix,ix)
    . quit:char?.AN
    . set:char'="_" ret=0
    ;
    quit ret
    ;
    ;
isValidParamName(str)
    new char0,ix,ret,char
    ;
    quit:$zlength(str)<1!($zlength(str)>32) 0
    ;
    set char0=$extract(str,1,1)
    set ret=char0?.A
    if ret=0,char0'="_" quit 0
    ;
    set ret=1
    for ix=2:1:$zlength(str) do  quit:ret=0
    . set char=$zextract(str,ix,ix)
    . quit:char?.AN
    . set:char'="_" ret=0
    ;
    quit ret
    ;
    ;
isValidVarName(str)
    new char0,ix,ret,char
    ;
    quit:$zlength(str)<2!($zlength(str)>32) 0
    ;
    set char0=$extract(str,1,1)
    set ret=char0?.A
    if ret=0,char0'="%" quit 0
    ;
    set ret=1
    for ix=2:1:$zlength(str) do  quit:ret=0
    . set char=$zextract(str,ix,ix)
    . set ret=char?.AN
    ;
    quit ret
    ;
isDir(path)
    new ret,constDir
    ;
    set ret=$&ydbposix.filemodeconst("S_IFDIR",.constDir)
    set path=$zsearch(path,-1)
	do statfile^%ydbposix(path,.stat)
	;
	quit stat("mode")\constDir#2
    ;
    ;
isFile(path)
    new ret,constFile
    ;
    set ret=$&ydbposix.filemodeconst("S_IFREG",.constFile)
    set path=$zsearch(path,-1)
	do statfile^%ydbposix(path,.stat)
	;
	quit stat("mode")\constFile#2
    ;
    ;
isValidEntryPoint(ep)
    new names
    ;
    ;set *names=$$SPLIT^%MPIECE(ep,"^")
    set names(1)=$piece(ep,"^")
    set names(2)=$piece(ep,"^",2)
    ;
    ; check existence of both pieces (^)
    if $get(names(1))=""!($get(names(2))="") quit 0
    ; check label
    if $$isValidVarName(names(1))=0 quit 0
    ; check routine
    if $$isValidVarName(names(2))=0 quit 0
    ;
    quit 1
    ;
    ;
triggerError()
    new x;
    ;
    set x=5/0
    ;
    quit
    ;
    ;