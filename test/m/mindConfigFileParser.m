;#################################################################
;#                                                               #
;# Copyright (c) 2025-2026 DnaSoft B.V. and/or its subsidiaries. #
;# All rights reserved.                                          #
;#                                                               #
;#   This source code contains the intellectual property         #
;#   of its copyright holder(s), and is made available           #
;#   under a license.  If you do not know the terms of           #
;#   the license, please stop and do not read further.           #
;#                                                               #
;#################################################################
;
mindConfigFileParser
	; Requires M-Unit
	;
test if $text(^%ut)="" quit
	do en^%ut($text(+0),3)
	;
	write !
	;
	quit
	;
STARTUP
	do backupConfigFile^%mindTestUtils
	write !,"Backup created..."
	;
	quit
	;
	;
SHUTDOWN
	do restoreConfigFile^%mindTestUtils
	write !!,"Backup restored..."
	;
	quit
	;
	;
COMM0	;@test
    quit
COMM1	;@test -----------------  comments and empty lines
	quit
COMM2	;@test
	quit
COMM3 	;@test comments and empty lines
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="# comment"_LF_"   "_LF_"#extra comment with no space"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Processing conf file",.ret)
    ;
    do eq^%ut(ret(foundIx+1),"conf file processed...","should have no dump inbetween")
    ;
	quit
	;
	;
COMM4 	;@test line with tabs
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="# comment"_LF_"   "_$char(9)_LF_"#extra comment"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Processing conf file",.ret)
    ;
    do eq^%ut(ret(foundIx+2),"conf file processed...","should have no dump inbetween")
    ;
	quit
	;
	;
PORT0	;@test
    quit
PORT1	;@test -----------------  port       -
	quit
PORT2	;@test
	quit
PORT3 	;@test port only
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="port"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Warning on line 1: No port number specified",.ret)
    ;
    do eq^%ut(found,1,"error not found")
    ;
	quit
	;
	;
PORT4 	;@test port with string
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="port test"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Warning on line 1: Invalid switch",.ret)
    ;
    do eq^%ut(found,1,"error not found")
    ;
	quit
	;
	;
PORT5 	;@test port with value outside range 80-49151
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="port 1023"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Warning on line 1: Invalid switch",.ret)
    ;
    do eq^%ut(found,1,"error not found")
    ;
	quit
	;
	;
PORT6 	;@test port with value outside range 80-49151
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="port 49152"
    do writeToConfig^%mindTestUtils(.string)

    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Warning on line 1: Invalid switch",.ret)
    ;
    do eq^%ut(found,1,"error not found")
    ;
	quit
	;
	;
PORT7 	;@test port with valid value but with space separator
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="port 49152"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Warning on line 1: Invalid switch",.ret)
    ;
    do eq^%ut(found,1,"error not found")
    ;
	quit
	;
	;
PORT8 	;@test port with valid value inside range 80-49151
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="port=1024"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Processing conf file",.ret)
    ;
    do eq^%ut(ret(foundIx+1),"conf file processed...","should have no dump inbetween")
    ;
	quit
	;
	;
PORT9 	;@test port with valid value inside range 80-49151
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="port=49151"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Processing conf file",.ret)
    ;
    do eq^%ut(ret(foundIx+1),"conf file processed...","should have no dump inbetween")
    ;
	quit
	;
	;
PORT10 	;@test port with valid value inside range 80-49151
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="port=49151"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Processing users configuration file",.ret)
    do eq^%ut(found,1,"string not found")
    set found=$$findStringInArray^%mindTestUtils("Listen port:",.ret)
    do eq^%ut(found,1,"header not set")
    set found=$$findStringInArray^%mindTestUtils("49151",.ret)
    do eq^%ut(found,1,"value not set")
    ;
	quit
	;
	;
LOGLEVEL0	;@test
    quit
LOGLEVEL1	;@test -----------------  log-level       -
	quit
LOGLEVEL2	;@test
	quit
LOGLEVEL3 	;@test bad syntax
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="log level"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Warning on line 1: Invalid switch",.ret)
    ;
    do eq^%ut(found,1,"error not found")
    ;
	quit
	;
	;
LOGLEVEL4 	;@test good syntax, no param
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="log-level"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Warning on line 1: No log level specified",.ret)
    ;
    do eq^%ut(found,1,"error not found")
    ;
	quit
	;
	;
LOGLEVEL5 	;@test good syntax, bad param
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="log-level everything"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Warning on line 1: Invalid switch",.ret)
    ;
    do eq^%ut(found,1,"error not found")
    ;
	quit
	;
	;
LOGLEVEL6 	;@test good syntax, good param, extra param
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="log-level=none yes"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Warning on line 1: Invalid log level specified",.ret)
    ;
    do eq^%ut(found,1,"error not found")
    ;
	quit
	;
	;
LOGLEVEL7 	;@test good syntax, none
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="log-level=none"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Processing conf file",.ret)
    ;
    do eq^%ut(ret(foundIx+1),"conf file processed...","should have no dump inbetween")
    ;
	quit
	;
	;
LOGLEVEL8 	;@test good syntax, sessions
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="log-level=sessions"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Processing conf file",.ret)
    ;
    do eq^%ut(ret(foundIx+1),"conf file processed...","should have no dump inbetween")
    ;
	quit
	;
	;
LOGLEVEL9 	;@test good syntax, commands
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="log-level=commands"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Processing conf file",.ret)
    ;
    do eq^%ut(ret(foundIx+1),"conf file processed...","should have no dump inbetween")
    ;
	quit
	;
	;
LOGLEVEL10 	;@test good syntax, responses
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="log-level=timings"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Processing conf file",.ret)
    ;
    do eq^%ut(ret(foundIx+1),"conf file processed...","should have no dump inbetween")
    ;
	quit
	;
	;
LOGLEVEL11 	;@test good syntax, responses
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="log-level=timings"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Processing users configuration file",.ret)
    do eq^%ut(found,1,"string not found")
    set found=$$findStringInArray^%mindTestUtils("Log level:",.ret)
    do eq^%ut(found,1,"header not set")
    set found=$$findStringInArray^%mindTestUtils("timings",.ret)
    do eq^%ut(found,1,"value not set")
    ;
	quit
	;
	;
LOGFILE0	;@test
    quit
LOGFILE1	;@test -----------------  log-file       -
	quit
LOGFILE2	;@test
	quit
LOGFILE3 	;@test bad syntax
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="log file"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Warning on line 1: Invalid switch",.ret)
    ;
    do eq^%ut(found,1,"error not found")
    ;
	quit
	;
	;
LOGFILE4 	;@test good syntax, no params
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="log-file"
    do writeToConfig^%mindTestUtils(.string)

    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Warning on line 1: No path specified",.ret)
    ;
    do eq^%ut(found,1,"error not found")
    ;
	quit
	;
	;
LOGFILE5 	;@test good syntax, no params
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="log-file="
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Warning on line 1: No path specified",.ret)
    ;
    do eq^%ut(found,1,"error not found")
    ;
	quit
	;
	;
LOGFILE6 	;@test good syntax, file not exist
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="log-file=/opt/trr/test"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Log file could not be opened, defaulting to console",.ret)
    ;
    do eq^%ut(found,1,"error not found")
    ;
	quit
	;
	;
LOGFILE7 	;@test good syntax, file good
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="log-file=/tmp/mind.log"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Processing conf file",.ret)
    ;
    do eq^%ut(ret(foundIx+1),"conf file processed...","should have no dump inbetween")
    ;
	quit
	;
	;
LOGFILE8 	;@test good syntax, file good
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="log-file=/tmp/mind.log"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Processing users configuration file",.ret)
    do eq^%ut(found,1,"string not found")
    set found=$$findStringInArray^%mindTestUtils("Log to:",.ret)
    do eq^%ut(found,1,"header not set")
    set found=$$findStringInArray^%mindTestUtils("/tmp/mind.log",.ret)
    do eq^%ut(found,1,"value not set")
    ;
	quit
	;
	;
USRCMDDIR0	;@test
    quit
USRCMDDIR1	;@test -----------------  uApi-working-dir       -
	quit
USRCMDDIR2	;@test
	quit
USRCMDDIR3 	;@test bad syntax
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="user commands dir"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Warning on line 1: Invalid switch",.ret)
    ;
    do eq^%ut(found,1,"error not found")
    ;
	quit
	;
	;
USRCMDDIR4 	;@test bad syntax
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="userApiDir"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Warning on line 1: Invalid switch",.ret)
    ;
    do eq^%ut(found,1,"error not found")
    ;
	quit
	;
	;
USRCMDDIR5 	;@test good syntax, no path
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="uapi-dir"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Warning on line 1: No path specified",.ret)
    ;
    do eq^%ut(found,1,"error not found")
    ;
	quit
	;
	;
USRCMDDIR6 	;@test good syntax, invalid path
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="uapi-dir=sfgkdkdjdkfljsd"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Warning on line 1: Path not found",.ret)
    ;
    do eq^%ut(found,1,"error not found")
    ;
	quit
	;
	;
USRCMDDIR7 	;@test good syntax, file
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="uapi-dir=$ydb_dist/plugin/etc/mind/mind.conf"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Warning on line 1: Path not found",.ret)
    ;
    do eq^%ut(found,1,"error not found")
    ;
	quit
	;
	;
USRCMDDIR8 	;@test good syntax, valid path
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="uapi-dir=$ydb_dist/plugin/etc/mind/"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Processing conf file",.ret)
    ;
    do eq^%ut(ret(foundIx+1),"conf file processed...","should have no dump inbetween")
    ;
	quit
	;
	;
USRCMDDIR9 	;@test good syntax, file, no equal separator
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="uapi-dir $ydb_dist/plugin/etc/mind/mind.conf"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Warning on line 1: Invalid switch",.ret)
    ;
    do eq^%ut(found,1,"error not found")
    ;
	quit
	;
	;
USRCMDDIR10 	;@test good syntax, valid path
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="uapi-dir=$ydb_dist/plugin/etc/mind/"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Processing users configuration file",.ret)
    do eq^%ut(found,1,"string not found")
    set found=$$findStringInArray^%mindTestUtils("User API dir:",.ret)
    do eq^%ut(found,1,"header not set")
    set found=$$findStringInArray^%mindTestUtils("$ydb_dist/plugin/etc/mind/",.ret)
    do eq^%ut(found,1,"value not set")
    ;
	quit
	;
	;
DUMPREQ0	;@test
    quit
DUMPREQ1	;@test -----------------  dump-request       -
	quit
DUMPREQ2	;@test
	quit
DUMPREQ3 	;@test bad syntax
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="dump request"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Warning on line 1: Invalid switch",.ret)
    ;
    do eq^%ut(found,1,"error not found")
    ;
	quit
	;
	;
DUMPREQ4 	;@test bad syntax
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="dumpRequest"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Warning on line 1: Invalid switch",.ret)
    ;
    do eq^%ut(found,1,"error not found")
    ;
	quit
	;
	;
DUMPREQ5 	;@test good syntax, no param
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="dump-request"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Warning on line 1: Only YES and NO supported",.ret)
    ;
    do eq^%ut(found,1,"error not found")
    ;
	quit
	;
	;
DUMPREQ6 	;@test good syntax, no param
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="dump-request="
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Warning on line 1: Only YES and NO supported",.ret)
    ;
    do eq^%ut(found,1,"error not found")
    ;
	quit
	;
	;
DUMPREQ7 	;@test good syntax, bad param
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="dump-request=maybe"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Warning on line 1: Only YES and NO supported",.ret)
    ;
    do eq^%ut(found,1,"error not found")
    ;
	quit
	;
	;
DUMPREQ8 	;@test good syntax, good param
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="dump-request=yes"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Processing conf file",.ret)
    ;
    do eq^%ut(ret(foundIx+1),"conf file processed...","should have no dump inbetween")
    ;
	quit
	;
	;
DUMPREQ9 	;@test good syntax, good param
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="dump-request=no"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Processing conf file",.ret)
    ;
    do eq^%ut(ret(foundIx+1),"conf file processed...","should have no dump inbetween")
    ;
	quit
	;
	;
DUMPREQ10 	;@test good syntax, good param
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="dump-request=Yes"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Processing conf file",.ret)
    ;
    do eq^%ut(ret(foundIx+1),"conf file processed...","should have no dump inbetween")
    ;
	quit
	;
	;
DUMPREQ11 	;@test good syntax, good param
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="dump-request=Yes"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Processing users configuration file",.ret)
    do eq^%ut(found,1,"string not found")
    set found=$$findStringInArray^%mindTestUtils("Dump requests:",.ret)
    do eq^%ut(found,1,"header not set")
    set found=$$findStringInArray^%mindTestUtils("6mYes",.ret)
    do eq^%ut(found,1,"value not set")
    ;
	quit
	;
	;
DUMPRES0	;@test
    quit
DUMPRES1	;@test -----------------  dump-response       -
	quit
DUMPRES2	;@test
	quit
DUMPRES3 	;@test bad syntax
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="dump response"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Warning on line 1: Invalid switch",.ret)
    ;
    do eq^%ut(found,1,"error not found")
    ;
	quit
	;
	;
DUMPRES4 	;@test bad syntax
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="dumpResponse"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Warning on line 1: Invalid switch",.ret)
    ;
    do eq^%ut(found,1,"error not found")
    ;
	quit
	;
	;
DUMPRES5 	;@test good syntax, no param
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="dump-response"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Warning on line 1: Only YES and NO supported",.ret)
    ;
    do eq^%ut(found,1,"error not found")
    ;
	quit
	;
	;
DUMPRES6 	;@test good syntax, no param
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="dump-response="
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Warning on line 1: Only YES and NO supported",.ret)
    ;
    do eq^%ut(found,1,"error not found")
    ;
	quit
	;
	;
DUMPRES7 	;@test good syntax, bad param
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="dump-response=maybe"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Warning on line 1: Only YES and NO supported",.ret)
    ;
    do eq^%ut(found,1,"error not found")
    ;
	quit
	;
	;
DUMPRES8 	;@test good syntax, good param
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="dump-response=yes"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Processing conf file",.ret)
    ;
    do eq^%ut(ret(foundIx+1),"conf file processed...","should have no dump inbetween")
    ;
	quit
	;
	;
DUMPRES9 	;@test good syntax, good param
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="dump-response=no"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Processing conf file",.ret)
    ;
    do eq^%ut(ret(foundIx+1),"conf file processed...","should have no dump inbetween")
    ;
	quit
	;
	;
DUMPRES10 	;@test good syntax, good param
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="dump-response=Yes"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Processing conf file",.ret)
    ;
    do eq^%ut(ret(foundIx+1),"conf file processed...","should have no dump inbetween")
    ;
	quit
	;
	;
DUMPRES11 	;@test good syntax, good param
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="dump-response=Yes"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Processing users configuration file",.ret)
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
STATS0	;@test
    quit
STATS1	;@test -----------------  statistics       -
	quit
STATS2	;@test
	quit
STATS3 	;@test bad syntax
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="statistic"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Warning on line 1: Invalid switch",.ret)
    ;
    do eq^%ut(found,1,"error not found")
    ;
	quit
	;
	;
STATS4 	;@test good syntax, no param
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="statistics"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Warning on line 1: Only OFF, GRAND and DETAILS supported",.ret)
    ;
    do eq^%ut(found,1,"error not found")
    ;
	quit
	;
	;
STATS5 	;@test good syntax, no param
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="statistics="
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Warning on line 1: Only OFF, GRAND and DETAILS supported",.ret)
    ;
    do eq^%ut(found,1,"error not found")
    ;
	quit
	;
	;
STATS6 	;@test good syntax, bad param
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="statistics=maybe"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Warning on line 1: Only OFF, GRAND and DETAILS supported",.ret)
    ;
    do eq^%ut(found,1,"error not found")
    ;
	quit
	;
	;
STATS7 	;@test good syntax, good param
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="statistics=off"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Processing conf file",.ret)
    ;
    do eq^%ut(ret(foundIx+1),"conf file processed...","should have no dump inbetween")
    ;
	quit
	;
	;
STATS8 	;@test good syntax, good param
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="statistics=grand"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Processing conf file",.ret)
    ;
    do eq^%ut(ret(foundIx+1),"conf file processed...","should have no dump inbetween")
    ;
	quit
	;
	;
STATS9 	;@test good syntax, good param
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="statistics=details"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Processing conf file",.ret)
    ;
    do eq^%ut(ret(foundIx+1),"conf file processed...","should have no dump inbetween")
    ;
	quit
	;
	;
STATS10 	;@test good syntax, good param
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="statistics=details"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Processing users configuration file",.ret)
    do eq^%ut(found,1,"string not found")
    set found=$$findStringInArray^%mindTestUtils("Statistics:",.ret)
    do eq^%ut(found,1,"header not set")
    set found=$$findStringInArray^%mindTestUtils("6mDetailed",.ret)
    do eq^%ut(found,1,"value not set")
    ;
	quit
	;
	;
ERRDUMP0	;@test
    quit
ERRDUMP1	;@test -----------------  error-dump       -
	quit
ERRDUMP2	;@test
	quit
ERRDUMP3 	;@test bad syntax
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="error"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Warning on line 1: Invalid switch",.ret)
    ;
    do eq^%ut(found,1,"error not found")
    ;
	quit
	;
	;
ERRDUMP4 	;@test bad syntax
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="errorDump"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Warning on line 1: Invalid switch",.ret)
    ;
    do eq^%ut(found,1,"error not found")
    ;
	quit
	;
	;
ERRDUMP5 	;@test good syntax, no param
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="error-dump"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Warning on line 1: Only NONE, BRIEF and EXTENDED supported",.ret)
    ;
    do eq^%ut(found,1,"error not found")
    ;
	quit
	;
	;
ERRDUMP6 	;@test good syntax, no param
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="error-dump="
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Warning on line 1: Only NONE, BRIEF and EXTENDED supported",.ret)
    ;
    do eq^%ut(found,1,"error not found")
    ;
	quit
	;
	;
ERRDUMP7 	;@test good syntax, bad param
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="error-dump=onlysome"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Warning on line 1: Only NONE, BRIEF and EXTENDED supported",.ret)
    ;
    do eq^%ut(found,1,"error not found")
    ;
	quit
	;
	;
ERRDUMP8 	;@test good syntax, good param
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="error-dump=none"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Processing conf file",.ret)
    ;
    do eq^%ut(ret(foundIx+1),"conf file processed...","should have no dump inbetween")
    ;
	quit
	;
	;
ERRDUMP9 	;@test good syntax, good param
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="error-dump=brief"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Processing conf file",.ret)
    ;
    do eq^%ut(ret(foundIx+1),"conf file processed...","should have no dump inbetween")
    ;
	quit
	;
	;
ERRDUMP10 	;@test good syntax, good param
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="error-dump=extended"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Processing conf file",.ret)
    ;
    do eq^%ut(ret(foundIx+1),"conf file processed...","should have no dump inbetween")
    ;
	quit
	;
	;
ERRDUMP11 	;@test good syntax, good param
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="error-dump=EXTENDED"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Processing conf file",.ret)
    ;
    do eq^%ut(ret(foundIx+1),"conf file processed...","should have no dump inbetween")
    ;
	quit
	;
	;
ERRDUMP12 	;@test good syntax, good param,verify value
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="error-dump=EXTENDED"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Processing users configuration file",.ret)
    do eq^%ut(found,1,"string not found")
    set found=$$findStringInArray^%mindTestUtils("Errors dump:",.ret)
    do eq^%ut(found,1,"header not set")
    set found=$$findStringInArray^%mindTestUtils("6mExtended",.ret)
    do eq^%ut(found,1,"value not set")
    ;
	quit
	;
	;
USETLS0	;@test
    quit
USETLS1	;@test -----------------  use-tls       -
	quit
USETLS2	;@test
	quit
USETLS3 	;@test bad syntax
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="use tls"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Warning on line 1: Invalid switch",.ret)
    ;
    do eq^%ut(found,1,"error not found")
    ;
	quit
	;
	;
USETLS4 	;@test bad syntax
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="useTls"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Warning on line 1: Invalid switch",.ret)
    ;
    do eq^%ut(found,1,"error not found")
    ;
	quit
	;
	;
USETLS5 	;@test good syntax, no param
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="use-tls"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Warning on line 1: Only YES and NO supported",.ret)
    ;
    do eq^%ut(found,1,"error not found")
    ;
	quit
	;
	;
USETLS6 	;@test good syntax, no param
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="use-tls="
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Warning on line 1: Only YES and NO supported",.ret)
    ;
    do eq^%ut(found,1,"error not found")
    ;
	quit
	;
	;
USETLS7 	;@test good syntax, bad param
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="use-tls=maybe"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Warning on line 1: Only YES and NO supported",.ret)
    ;
    do eq^%ut(found,1,"error not found")
    ;
	quit
	;
	;
USETLS8 	;@test good syntax, good param
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="use-tls=yes"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Processing conf file",.ret)
    ;
    do eq^%ut(ret(foundIx+1),"conf file processed...","should have no dump inbetween")
    ;
	quit
	;
	;
USETLS9 	;@test good syntax, good param
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="use-tls=no"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Processing conf file",.ret)
    ;
    do eq^%ut(ret(foundIx+1),"conf file processed...","should have no dump inbetween")
    ;
	quit
	;
	;
USETLS10 	;@test good syntax, good param
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="use-tls=Yes"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Processing conf file",.ret)
    ;
    do eq^%ut(ret(foundIx+1),"conf file processed...","should have no dump inbetween")
    ;
	quit
	;
	;
USETLS11 	;@test good syntax, good param
    new string,LF,ret,found
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="use-tls=Yes"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set found=$$findStringInArray^%mindTestUtils("Processing users configuration file",.ret)
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;