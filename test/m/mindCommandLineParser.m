;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;								;
; Copyright (c) 2024-2025 YottaDB LLC and/or its subsidiaries.	;
; All rights reserved.						;
;								;
;	This source code contains the intellectual property	;
;	of its copyright holder(s), and is made available	;
;	under a license.  If you do not know the terms of	;
;	the license, please stop and do not read further.	;
;								;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
STARTUP
	;do STARTUP^%ydbxiderTestUtils
	;
	quit
	;
	;
SHUTDOWN
	;do SHUTDOWN^%ydbxiderTestUtils
	;
	quit
	;
	;
PORT0	;@test
    quit
PORT1	;@test -----------------  --port
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
    set found=$$findStringInArray^%mindTestUtils("Parameter for --port not specified or invalid",.ret)
    ;
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
PORT5 	;@test --port with string value
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--port testingstring")
    set found=$$findStringInArray^%mindTestUtils("Parameter for --port not specified or invalid",.ret)
    ;
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
PORT6 	;@test --port with value outside range 1024-49151
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--port 1023")
    set found=$$findStringInArray^%mindTestUtils("Parameter for --port not specified or invalid",.ret)
    ;
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
PORT7 	;@test --port with value outside range 1024-49151
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--port 49152")
    set found=$$findStringInArray^%mindTestUtils("Parameter for --port not specified or invalid",.ret)
    ;
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
PORT8 	;@test --port with value just inside range 1024-49151
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--port 1024")
    set found=$$findStringInArray^%mindTestUtils("Parameter for --port not specified or invalid",.ret)
    ;
    do eq^%ut(found,0,"nope")
    ;
	quit
	;
	;
PORT9 	;@test --port with value just inside range 1024-49151
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--port 49151")
    ;zwr:$data(ret) ret
    set found=$$findStringInArray^%mindTestUtils("Parameter for --port not specified or invalid",.ret)
    ;
    do eq^%ut(found,0,"nope")
    ;
	quit
	;
	;
VERS0	;@test-
    quit
VERS1	;@test -----------------  --version
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
HELP1	;@test -----------------  --help
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
    do eq^%ut(found,0,"string not found")
    ;
	quit
	;
	;
LOGLEV0	;@test-
    quit
LOGLEV1	;@test -----------------  --log-level
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
LOGLEV6 	;@test --log-level correct, but no param
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--log-level")
    set found=$$findStringInArray^%mindTestUtils("Parameter for --log-level not specified or invalid",.ret)
    ;
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
LOGLEV7 	;@test --log-level correct, but numeric param
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--log-level 0")
    set found=$$findStringInArray^%mindTestUtils("Parameter: 0 not supported",.ret)
    ;
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
LOGLEV8 	;@test --log-level correct, but bad string param
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--log-level advanced")
    set found=$$findStringInArray^%mindTestUtils("Parameter: advanced not supported",.ret)
    ;
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
LOGLEV9 	;@test --log-level correct, param correct: none
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--log-level none")
    set found=$$findStringInArray^%mindTestUtils("Processing users configuration file",.ret)
    ;
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
LOGLEV10 	;@test --log-level correct, param correct: sessions
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--log-level sessions")
    set found=$$findStringInArray^%mindTestUtils("Processing users configuration file",.ret)
    ;
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
LOGLEV11 	;@test --log-level correct, param correct: commands
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--log-level commands")
    set found=$$findStringInArray^%mindTestUtils("Processing users configuration file",.ret)
    ;
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
LOGLEV12 	;@test --log-level correct, param correct: responses
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--log-level responses")
    set found=$$findStringInArray^%mindTestUtils("Processing users configuration file",.ret)
    ;
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
DUMPREQ0	;@test-
    quit
DUMPREQ1	;@test -----------------  --dump-request
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
DUMPREQ4 	;@test --dump-request with good syntax
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--dump-request")
    set found=$$findStringInArray^%mindTestUtils("Processing users configuration file",.ret)
    ;
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
DUMPREQ5 	;@test --dump-request with extra parameter
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--dump-request true")
    set found=$$findStringInArray^%mindTestUtils("Parameter: true not supported",.ret)
    ;
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
STATS0	;@test-
    quit
STATS1	;@test -----------------  --statistics
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
    set found=$$findStringInArray^%mindTestUtils("Parameter for --statistics not specified or invalid",.ret)
    ;
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
STATS5 	;@test --statistics with good syntax, bad param
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--statistics on")
    set found=$$findStringInArray^%mindTestUtils("Parameter: on not supported",.ret)
    ;
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
STATS6 	;@test --statistics with good syntax, good param: off
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--statistics off")
    set found=$$findStringInArray^%mindTestUtils("Processing users configuration file",.ret)
    ;
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
STATS6 	;@test --statistics with good syntax, good param: grand
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--statistics grand")
    set found=$$findStringInArray^%mindTestUtils("Processing users configuration file",.ret)
    ;
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
STATS6 	;@test --statistics with good syntax, good param: details
    new ret,found
    ;
    set *ret=$$runMind^%mindTestUtils("--statistics details")
    set found=$$findStringInArray^%mindTestUtils("Processing users configuration file",.ret)
    ;
    do eq^%ut(found,1,"string not found")
    ;
	quit
	;
	;
