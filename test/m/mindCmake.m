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
CMAKE0	;@test
    quit
CMAKE1	;@test -----------------  CMake     -
	quit
CMAKE2	;@test
	quit
CMAKE3 	;@test with no params
    new buffer,command,ret,found
    ;
    ; perform the installation
    set command="rm -fr /tmp/mind-server && echo ""Using branch: $test_branch"" && cd /tmp && git clone -b $test_branch --single-branch https://github.com/mind4yottadb/mind-server.git && cd mind-server && mkdir build && cd build && cmake .. && make && make install"
    set ret=$$runShell^%mindTestUtils(command,.buffer)
    ;
    ; verify exit code = 0
    do eq^%ut(ret,0,"sub-process returned exitCode="_ret)
    ;
    set found=$$findStringInArray^%mindTestUtils(": /opt/yottadb/current/plugin/etc/mind/mind.ydbcrypt",.buffer)
    write !,"found:",found
    ;
    set found=$$findStringInArray^%mindTestUtils("Found YDBEncrypt plugin",.buffer)
    do eq^%ut(found,0,"string found!!!")
    ;
    set found=$$findStringInArray^%mindTestUtils("BUILD PARAM",.buffer)
    do eq^%ut(found,0,"string found!!!")
    ;
    set found=$$findStringInArray^%mindTestUtils(": /opt/yottadb/current/plugin/etc/mind/users.json",.buffer)
    do eq^%ut(found,1,"no users!!!")
    ;
    set found=$$findStringInArray^%mindTestUtils(": /opt/yottadb/current/plugin/etc/mind/mind",.buffer)
    do eq^%ut(found,1,"no mind!!!")
    ;
    set found=$$findStringInArray^%mindTestUtils(": /opt/yottadb/current/plugin/etc/mind/mind.conf",.buffer)
    do eq^%ut(found,1,"no conf!!!")
    ;
    set found=$$findStringInArray^%mindTestUtils(": /opt/mind/test/m/mindConfigFileParser.m",.buffer)
    do eq^%ut(found,0,"no test files!!!")
    ;
	quit
	;
	;
CMAKE4 	;@test with -Dtls
    new buffer,command,ret,found
    ;
    ; perform the installation
    set command="rm -fr /tmp/mind-server && echo ""Using branch: $test_branch"" && cd /tmp && git clone -b $test_branch --single-branch https://github.com/mind4yottadb/mind-server.git && cd mind-server && mkdir build && cd build && cmake .. -Dtls=1 && make && make install"
    set ret=$$runShell^%mindTestUtils(command,.buffer)
    ;
    ; verify exit code = 0
    do eq^%ut(ret,0,"sub-process returned exitCode="_ret)
    ;
    set found=$$findStringInArray^%mindTestUtils("/opt/yottadb/current/plugin/etc/mind/mind.ydbcrypt",.buffer)
    do eq^%ut(found,1,"string not found!!!")
    ;
    set found=$$findStringInArray^%mindTestUtils("Found YDBEncrypt plugin",.buffer)
    do eq^%ut(found,1,"string not found!!!")
    ;
    set found=$$findStringInArray^%mindTestUtils("BUILD PARAM:  tls",.buffer)
    do eq^%ut(found,1,"string not found!!!")
    ;
    set found=$$findStringInArray^%mindTestUtils(": /opt/yottadb/current/plugin/etc/mind/users.json",.buffer)
    do eq^%ut(found,1,"no users!!!")
    ;
    set found=$$findStringInArray^%mindTestUtils(": /opt/yottadb/current/plugin/etc/mind/mind",.buffer)
    do eq^%ut(found,1,"no mind!!!")
    ;
    set found=$$findStringInArray^%mindTestUtils(": /opt/yottadb/current/plugin/etc/mind/mind.conf",.buffer)
    do eq^%ut(found,1,"no conf!!!")
    ;
    set found=$$findStringInArray^%mindTestUtils(": /opt/mind/test/m/mindConfigFileParser.m",.buffer)
    do eq^%ut(found,0,"no test files!!!")
    ;
	quit
	;
	;
CMAKE5 	;@test with -Dso_only
    new buffer,command,ret,found
    ;
    ; perform the installation
    set command="rm -fr /tmp/mind-server && echo ""Using branch: $test_branch"" && cd /tmp && git clone -b $test_branch --single-branch https://github.com/mind4yottadb/mind-server.git && cd mind-server && mkdir build && cd build && cmake .. -Dso_only=1 && make && make install"
    set ret=$$runShell^%mindTestUtils(command,.buffer)
    ;
    ; verify exit code = 0
    do eq^%ut(ret,0,"sub-process returned exitCode="_ret)
    ;
    set found=$$findStringInArray^%mindTestUtils(": /opt/yottadb/current/plugin/etc/mind/mind.ydbcrypt",.buffer)
    do eq^%ut(found,0,"string found!!!")
    ;
    set found=$$findStringInArray^%mindTestUtils(": /opt/yottadb/current/plugin/o/_mind.manifest.json",.buffer)
    do eq^%ut(found,1,"string not found!!!")
    ;
    set found=$$findStringInArray^%mindTestUtils("Found YDBEncrypt plugin",.buffer)
    do eq^%ut(found,0,"no encrypt!!!")
    ;
    set found=$$findStringInArray^%mindTestUtils("BUILD PARAM: Only compiling and linking",.buffer)
    do eq^%ut(found,1,"param specs!!!")
    ;
    set found=$$findStringInArray^%mindTestUtils(": /opt/yottadb/current/plugin/etc/mind/users.json",.buffer)
    do eq^%ut(found,0,"no users!!!")
    ;
    set found=$$findStringInArray^%mindTestUtils(": /opt/yottadb/current/plugin/etc/mind/mind",.buffer)
    do eq^%ut(found,0,"no mind!!!")
    ;
    set found=$$findStringInArray^%mindTestUtils(": /opt/yottadb/current/plugin/etc/mind/mind.conf",.buffer)
    do eq^%ut(found,0,"no conf!!!")
    ;
    set found=$$findStringInArray^%mindTestUtils(": /opt/mind/test/m/mindConfigFileParser.m",.buffer)
    do eq^%ut(found,0,"no test files!!!")
    ;
	quit
	;
	;
CMAKE6 	;@test with -Dtest_mode
    new buffer,command,ret,found
    ;
    ; perform the installation
    set command="rm -fr /tmp/mind-server && echo ""Using branch: $test_branch"" && cd /tmp && git clone -b $test_branch --single-branch https://github.com/mind4yottadb/mind-server.git && cd mind-server && mkdir build && cd build && cmake .. -Dtest_mode=1 && make && make install"
    set ret=$$runShell^%mindTestUtils(command,.buffer)
    ;
    ; verify exit code = 0
    do eq^%ut(ret,0,"sub-process returned exitCode="_ret)
    ;
    set found=$$findStringInArray^%mindTestUtils(": /opt/yottadb/current/plugin/etc/mind/mind.ydbcrypt",.buffer)
    do eq^%ut(found,0,"string found!!!")
    ;
    set found=$$findStringInArray^%mindTestUtils(": /opt/yottadb/current/plugin/o/_mind.manifest.json",.buffer)
    do eq^%ut(found,1,"string not found!!!")
    ;
    set found=$$findStringInArray^%mindTestUtils("Found YDBEncrypt plugin",.buffer)
    do eq^%ut(found,0,"no encrypt!!!")
    ;
    set found=$$findStringInArray^%mindTestUtils("BUILD PARAM: Test mode, copying test files as well",.buffer)
    do eq^%ut(found,1,"param specs!!!")
    ;
    set found=$$findStringInArray^%mindTestUtils(": /opt/yottadb/current/plugin/etc/mind/users.json",.buffer)
    do eq^%ut(found,1,"no users!!!")
    ;
    set found=$$findStringInArray^%mindTestUtils(": /opt/yottadb/current/plugin/etc/mind/mind",.buffer)
    do eq^%ut(found,1,"no mind!!!")
    ;
    set found=$$findStringInArray^%mindTestUtils(": /opt/yottadb/current/plugin/etc/mind/mind.conf",.buffer)
    do eq^%ut(found,1,"no conf!!!")
    ;
    set found=$$findStringInArray^%mindTestUtils(": /opt/mind/test/m/mindConfigFileParser.m",.buffer)
    do eq^%ut(found,1,"no test files!!!")
    ;
	quit
	;
	;
