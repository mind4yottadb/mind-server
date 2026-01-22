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
mindCommandLineParser
	; Requires M-Unit
	;
test if $text(^%ut)="" quit
	do en^%ut($text(+0),3)
	;
	write !
	;
	quit
	;
PORT0	;@test
    quit
PORT1	;@test -----------------  --port     -
	quit
PORT2	;@test
	quit
PORT3 	;@test --port with bad syntax
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--porta")
    set found=$$findStringInArray^%mindTestUtils("--porta not supported",.ret)
    ;
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
PORT4 	;@test --port with no value
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--port")
    set found=$$findStringInArray^%mindTestUtils("--port: no port number specified...",.ret)
    ;
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
PORT5 	;@test --port with string value
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--port=testingstring")
    set found=$$findStringInArray^%mindTestUtils("port number not valid",.ret)
    ;
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
PORT6 	;@test --port with value outside range 80-49151
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--port=79")
    set found=$$findStringInArray^%mindTestUtils("port number not valid",.ret)
    ;
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
PORT7 	;@test --port with value outside range 80-49151
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--port=49152")
    set found=$$findStringInArray^%mindTestUtils("port number not valid",.ret)
    ;
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
PORT8 	;@test --port with value just inside range 80-49151
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--port=80")
    set found=$$findStringInArray^%mindTestUtils("port number not valid",.ret)
    do eq^%ut(found,0,"nope")
    set found=$$findStringInArray^%mindTestUtils("Listen port:",.ret)
    do eq^%ut(found,1,"header not set")
    set found=$$findStringInArray^%mindTestUtils("6m80",.ret)
    do eq^%ut(found,1,"value not set")
    ;
	quit
	;
	;
PORT9 	;@test --port with value just inside range 1024-49151
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--port=49151")
    set found=$$findStringInArray^%mindTestUtils("port number not valid",.ret)
    do eq^%ut(found,0,"nope")
    set found=$$findStringInArray^%mindTestUtils("Listen port:",.ret)
    do eq^%ut(found,1,"header not set")
    set found=$$findStringInArray^%mindTestUtils("6m49151",.ret)
    do eq^%ut(found,1,"value not set")
    ;
	quit
	;
	;
VERS0	;@test-
    quit
VERS1	;@test -----------------  --version     -
	quit
VERS2	;@test
	quit
VERS3 	;@test --version with bad syntax
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--versio")
    set found=$$findStringInArray^%mindTestUtils("--versio not supported",.ret)
    ;
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
VERS4 	;@test --version correct
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--version")
    set found=$$findStringInArray^%mindTestUtils("--versio not supported",.ret)
    ;
    do eq^%ut(found,0,"string not found")
    ;
	quit
	;
	;
HELP0	;@test-
    quit
HELP1	;@test -----------------  --help     -
	quit
HELP2	;@test
	quit
HELP3 	;@test --help with bad syntax
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--helpo")
    set found=$$findStringInArray^%mindTestUtils("--helpo not supported",.ret)
    ;
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
HELP4 	;@test --help correct
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--help")
    set found=$$findStringInArray^%mindTestUtils("Available parameters",.ret)
    ;
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
HELP5 	;@test --help upper case
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--HELP")
    set found=$$findStringInArray^%mindTestUtils("Available parameters",.ret)
    ;
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
LOGLEV0	;@test-
    quit
LOGLEV1	;@test -----------------  --log-level     -
	quit
LOGLEV2	;@test
	quit
LOGLEV3 	;@test --log-level with bad syntax
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--log-levela")
    set found=$$findStringInArray^%mindTestUtils("--log-levela not supported",.ret)
    ;
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
LOGLEV4 	;@test --log-level with bad syntax
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--loglevel")
    set found=$$findStringInArray^%mindTestUtils("--loglevel not supported",.ret)
    ;
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
LOGLEV5 	;@test --log-level with bad syntax
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--loglevel")
    set found=$$findStringInArray^%mindTestUtils("--loglevel not supported",.ret)
    ;
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
LOGLEV6 	;@test --log-level correct, but no param
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--log-level")
    set found=$$findStringInArray^%mindTestUtils("no log level specified",.ret)
    ;
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
LOGLEV7 	;@test --log-level correct, but numeric param
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--log-level=0")
    set found=$$findStringInArray^%mindTestUtils("invalid log level specified",.ret)
    ;
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
LOGLEV8 	;@test --log-level correct, but bad string param
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--log-level=advanced")
    set found=$$findStringInArray^%mindTestUtils("invalid log level specified",.ret)
    ;
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
LOGLEV9 	;@test --log-level correct, param correct: none
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--log-level=none")
    set found=$$findStringInArray^%mindTestUtils("Processing users configuration file",.ret)
    do eq^%ut(found,1,"string not found")
    set found=$$findStringInArray^%mindTestUtils("Log level:",.ret)
    do eq^%ut(found,1,"header not set")
    set found=$$findStringInArray^%mindTestUtils("6mnone",.ret)
    do eq^%ut(found,1,"value not set")
    ;
    ;
	quit
	;
	;
LOGLEV10 	;@test --log-level correct, param correct: sessions
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--log-level=sessions")
    set found=$$findStringInArray^%mindTestUtils("Processing users configuration file",.ret)
    do eq^%ut(found,1,"string not found")
    set found=$$findStringInArray^%mindTestUtils("Log level:",.ret)
    do eq^%ut(found,1,"header not set")
    set found=$$findStringInArray^%mindTestUtils("6msessions",.ret)
    do eq^%ut(found,1,"value not set")
    ;
	quit
	;
	;
LOGLEV11 	;@test --log-level correct, param correct: commands
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--log-level=commands")
    set found=$$findStringInArray^%mindTestUtils("Processing users configuration file",.ret)
    do eq^%ut(found,1,"string not found")
    set found=$$findStringInArray^%mindTestUtils("Log level:",.ret)
    do eq^%ut(found,1,"header not set")
    set found=$$findStringInArray^%mindTestUtils("6mcommands",.ret)
    do eq^%ut(found,1,"value not set")
    ;
	quit
	;
	;
LOGLEV12 	;@test --log-level correct, param correct: responses
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--log-level=responses")
    set found=$$findStringInArray^%mindTestUtils("Processing users configuration file",.ret)
    do eq^%ut(found,1,"string not found")
    set found=$$findStringInArray^%mindTestUtils("Log level:",.ret)
    do eq^%ut(found,1,"header not set")
    set found=$$findStringInArray^%mindTestUtils("6mresponses",.ret)
    do eq^%ut(found,1,"value not set")
    ;
	quit
	;
	;
DUMPREQ0	;@test-
    quit
DUMPREQ1	;@test -----------------  --dump-request     -
	quit
DUMPREQ2	;@test
	quit
DUMPREQ3 	;@test --dump-request with bad syntax
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--dumprequest")
    set found=$$findStringInArray^%mindTestUtils("--dumprequest not supported",.ret)
    ;
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
DUMPREQ5 	;@test --dump-request with extra parameter
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--dump-request=true")
    set found=$$findStringInArray^%mindTestUtils("only yes and no supported",.ret)
    ;
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
STATS0	;@test-
    quit
STATS1	;@test -----------------  --statistics     -
	quit
STATS2	;@test
	quit
STATS3 	;@test --statistics with bad syntax
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--stats")
    set found=$$findStringInArray^%mindTestUtils("--stats not supported",.ret)
    ;
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
STATS4 	;@test --statistics with good syntax, no param
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--statistics")
    set found=$$findStringInArray^%mindTestUtils("statistics requires either off, grand or details",.ret)
    ;
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
STATS5 	;@test --statistics with good syntax, bad param
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--statistics=on")
    set found=$$findStringInArray^%mindTestUtils("only off, grand and details supported",.ret)
    ;
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
STATS6 	;@test --statistics with good syntax, good param: off
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--statistics=off")
    set found=$$findStringInArray^%mindTestUtils("Processing users configuration file",.ret)
    do eq^%ut(found,1,"string not found")
    set found=$$findStringInArray^%mindTestUtils("Statistics:",.ret)
    do eq^%ut(found,1,"header not set")
    set found=$$findStringInArray^%mindTestUtils("6mOff",.ret)
    do eq^%ut(found,1,"value not set")
    ;
	quit
	;
	;
STATS7 	;@test --statistics with good syntax, good param: grand
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--statistics=grand")
    set found=$$findStringInArray^%mindTestUtils("Processing users configuration file",.ret)
    do eq^%ut(found,1,"string not found")
    set found=$$findStringInArray^%mindTestUtils("Statistics:",.ret)
    do eq^%ut(found,1,"header not set")
    set found=$$findStringInArray^%mindTestUtils("6mOnly grand totals",.ret)
    do eq^%ut(found,1,"value not set")
    ;
	quit
	;
	;
STATS8 	;@test --statistics with good syntax, good param: details
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--statistics=details")
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
ERRDUMP0	;@test-
    quit
ERRDUMP1	;@test -----------------  --error-dump     -
	quit
ERRDUMP2	;@test
	quit
ERRDUMP3 	;@test --errordump with bad syntax
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--errordump")
    set found=$$findStringInArray^%mindTestUtils("--errordump not supported",.ret)
    ;
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
ERRDUMP4 	;@test --error-dump with no params
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--error-dump")
    set found=$$findStringInArray^%mindTestUtils("missing parameter value",.ret)
    ;
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
ERRDUMP5 	;@test --error-dump with bad param
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--error-dump=all")
    set found=$$findStringInArray^%mindTestUtils("only none, brief and extended",.ret)
    ;
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
ERRDUMP6 	;@test --error-dump with good param: none
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--error-dump=none")
    set found=$$findStringInArray^%mindTestUtils("Processing users configuration file",.ret)
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
ERRDUMP7 	;@test --error-dump with good param: brief
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--error-dump=brief")
    set found=$$findStringInArray^%mindTestUtils("Processing users configuration file",.ret)
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
ERRDUMP8 	;@test --error-dump with good param: extended
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--error-dump=extended")
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
LOGFILE0	;@test-
    quit
LOGFILE1	;@test -----------------  --log-file     -
	quit
LOGFILE2	;@test
	quit
LOGFILE3 	;@test --logfile with bad syntax
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--logfile")
    set found=$$findStringInArray^%mindTestUtils("--logfile not supported",.ret)
    ;
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
LOGFILE4 	;@test --log-file with no param
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--log-file")
    set found=$$findStringInArray^%mindTestUtils("no path specified",.ret)
    ;
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
LOGFILE5 	;@test --log-file with bad param
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--log-file=/trrt/uutrtrtr")
    set found=$$findStringInArray^%mindTestUtils("log file could not be opened, defaulting to console",.ret)
    ;
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
LOGFILE6 	;@test --log-file with bad param
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--log-file=/trrt/uutrtrtr")
    set found=$$findStringInArray^%mindTestUtils("log file could not be opened, defaulting to console",.ret)
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
LOGFILE7 	;@test --log-file with dir instead of file
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--log-file=/opt")
    set found=$$findStringInArray^%mindTestUtils("log file could not be opened, defaulting to console",.ret)
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
LOGFILE8 	;@test --log-file with valid file
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--log-file=/tmp/mind.log")
    set found=$$findStringInArray^%mindTestUtils("WARNING: Log file could not be opened, defaulting to console",.ret)
    do eq^%ut(found,0,"string found")
    set found=$$findStringInArray^%mindTestUtils("Log to:",.ret)
    do eq^%ut(found,1,"header not set")
    set found=$$findStringInArray^%mindTestUtils("6m/tmp/mind.log",.ret)
    do eq^%ut(found,1,"value not set")
    ;
	quit
	;
	;
