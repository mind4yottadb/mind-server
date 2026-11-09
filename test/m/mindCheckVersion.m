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
mindCmake
	; Requires M-Unit
	;
test if $text(^%ut)="" quit
	do en^%ut($text(+0),3)
	;
	write !
	;
	quit
	;
CHECKVERSION0	;@test
    quit
CHECKVERSION1	;@test -----------------  CMake     -
	quit
CHECKVERSION2	;@test
	quit
CHECKVERSION3 	;@test with no params
    new ret,command,buffer
    new CMakeFile,ix,found,str,versionServer,versionCurrent
    ;
    set command="rm -fr /tmp/mind-server && cd /tmp && git clone -b main --single-branch https://github.com/mind4yottadb/mind-server.git"
    set ret=$$runShell^%mindTestUtils(command,.buffer)
    ;
    ; verify exit code = 0
    do eq^%ut(ret,0,"sub-process returned exitCode="_ret)
    ;
    ; get server CMakeLists.txt and read it
    set CMakeFile="/tmp/mind-server/CMakeLists.txt"
    open CMakeFile
    use CMakeFile
    kill buffer
    for ix=1:1 quit:$zeof  read buffer(ix)
    close CMakeFile
    ;
    ; parse the file and get the version number
    use $principal
    ;
    set ix="",found=0 for  set ix=$order(buffer(ix)) quit:ix=""!(found)  do
    . if $find(buffer(ix),"project(MIND") do
    . . set *str=$$SPLIT^%MPIECE(buffer(ix+2))
    . . set versionServer=$zextract(str(2),1,$zlength(str(2))-1)
    . . set found=1
    ;
    ; verify found > 0
    do eq^%ut(found,1,"remote CMake version not found="_ret)
    ;
    ; get current CMakeLists.txt and read it
    set CMakeFile=$select($ZTRNLNM("test_branch")="":"./CMakeLists.txt",1:"$ydb_dist/plugin/etc/mind/CMakeLists.txt")
    open CMakeFile:READONLY
    use CMakeFile
    kill buffer
    for ix=1:1 quit:$zeof  read buffer(ix)
    close CMakeFile
    ;
    ; parse the file and get the version number
    use $principal
    ;
    set ix="",found=0 for  set ix=$order(buffer(ix)) quit:ix=""!(found)  do
    . if $find(buffer(ix),"project(MIND") do
    . . set *str=$$SPLIT^%MPIECE(buffer(ix+2))
    . . set versionCurrent=$zextract(str(2),1,$zlength(str(2))-1)
    . . set found=1
    ;
    ; verify found > 0
    do eq^%ut(found,1,"local CMake version not found="_ret)
    ;
    ; verify version increase
    write !,versionServer," >>> ",versionCurrent
    do eq^%ut(versionCurrent>versionServer,1,"local version is lower or equal than server version")
    ;
    quit
    ;
    ;
