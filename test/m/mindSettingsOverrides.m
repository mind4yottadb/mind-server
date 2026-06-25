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
DEFAULT0	;@test
    quit
DEFAULT1	;@test -----------------  default values
	quit
DEFAULT2	;@test
	quit
DEFAULT3 	;@test Transport protocol
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string=""
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("3mTransport protocol:       "_$C(27)_"[38;5;6mTCP",.ret)
    ;
    do eq^%ut(foundIx>0,1,"looking for TCP")
    ;
	quit
	;
	;
DEFAULT4 	;@test Listen port
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string=""
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("3mListen port:              "_$C(27)_"[38;5;6m10000",.ret)
    ;
    do eq^%ut(foundIx>0,1,"looking for port")
    ;
	quit
	;
	;
DEFAULT5 	;@test use tls
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string=""
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Use TLS:                  "_$C(27)_"[38;5;6mNO",.ret)
    ;
    do eq^%ut(foundIx>0,1,"looking for tls")
    ;
	quit
	;
	;
DEFAULT6 	;@test log level
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string=""
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Log level:                "_$C(27)_"[38;5;6mcommands",.ret)
    ;
    do eq^%ut(foundIx>0,1,"looking for log level")
    ;
	quit
	;
	;
DEFAULT7 	;@test log to
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string=""
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Log to:                   "_$C(27)_"[38;5;6mCONSOLE",.ret)
    ;
    do eq^%ut(foundIx>0,1,"looking for log to")
    ;
	quit
	;
	;
DEFAULT8 	;@test dump request
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string=""
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Dump requests:            "_$C(27)_"[38;5;6mNo",.ret)
    ;
    do eq^%ut(foundIx>0,1,"looking for dum request")
    ;
	quit
	;
	;
DEFAULT9 	;@test dump response
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string=""
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("3mDump responses:           "_$C(27)_"[38;5;6mNo",.ret)
    ;
    do eq^%ut(foundIx>0,1,"looking for dum request")
    ;
	quit
	;
	;
DEFAULT10 	;@test statistics
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string=""
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Statistics:               "_$C(27)_"[38;5;6mOff",.ret)
    ;
    do eq^%ut(foundIx>0,1,"looking for dum response")
    ;
	quit
	;
	;
DEFAULT11 	;@test error dump
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string=""
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("3mErrors dump:              "_$C(27)_"[38;5;6mBrief",.ret)
    ;
    do eq^%ut(foundIx>0,1,"looking for error dump")
    ;
	quit
	;
	;
DEFAULT12 	;@test user API dir
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string=""
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("3mUser API dir:             "_$C(27)_"[38;5;6m$ydb_dist/plugin/etc/mind/uApi/",.ret)
    ;
    do eq^%ut(foundIx>0,1,"looking for user api")
    ;
	quit
	;
	;
DEFAULT13 	;@test console width
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string=""
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("[38;5;3mConsole width:            "_$C(27)_"[38;5;6m132",.ret)
    ;
    do eq^%ut(foundIx>0,1,"looking for user api")
    ;
	quit
	;
	;
DEFAULT14 	;@test session idle timeout
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string=""
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("[38;5;3mSession idle timeout:     "_$C(27)_"[38;5;6m30 mins",.ret)
    ;
    do eq^%ut(foundIx>0,1,"looking for user api")
    ;
	quit
	;
	;
PORT0	;@test
    quit
PORT1	;@test -----------------  port
	quit
PORT2	;@test
	quit
PORT3 	;@test port override with conf
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="port=5000"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("3mListen port:              "_$C(27)_"[38;5;6m5000",.ret)
    ;
    do eq^%ut(foundIx>0,1,"looking for 5000")
    ;
	quit
	;
	;
PORT4 	;@test port override with conf, then switch
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="port=5000"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils("--port=3000")
    set foundIx=$$findIndexInArray^%mindTestUtils("3mListen port:              "_$C(27)_"[38;5;6m3000",.ret)
    ;
    do eq^%ut(foundIx>0,1,"looking for 3000")
    ;
	quit
	;
	;
PROT0	;@test
    quit
PROT1	;@test -----------------  protocol
	quit
PROT2	;@test
	quit
PROT3 	;@test protocol override with conf
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="protocol=uds"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("3mTransport protocol:       "_$C(27)_"[38;5;6mUDS",.ret)
    ;
    do eq^%ut(foundIx>0,1,"looking for UDS")
    ;
	quit
	;
	;
PROT4 	;@test protocol override with conf, then switch
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="protocol=uds"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils("--protocol=TCP")
    set foundIx=$$findIndexInArray^%mindTestUtils("3mTransport protocol:       "_$C(27)_"[38;5;6mTCP",.ret)
    ;
    do eq^%ut(foundIx>0,1,"looking for TCP")
    ;
	quit
	;
	;
TLS0	;@test
    quit
TLS1	;@test -----------------  tls
	quit
TLS2	;@test
	quit
TLS3 	;@test tls override with conf
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="use-tls=yes"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Use TLS:                  "_$C(27)_"[38;5;6mYES",.ret)
    ;
    do eq^%ut(foundIx>0,1,"looking for tls")
    ;
	quit
	;
	;
TLS4 	;@test tls override with conf, then switch
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="use-tls=yes"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils("--use-tls=no")
    set foundIx=$$findIndexInArray^%mindTestUtils("Use TLS:                  "_$C(27)_"[38;5;6mNO",.ret)
    ;
    do eq^%ut(foundIx>0,1,"looking for tls")
    ;
	quit
	;
	;
LOGLEVEL0	;@test
    quit
LOGLEVEL1	;@test -----------------  log-level
	quit
LOGLEVEL2	;@test
	quit
LOGLEVEL3 	;@test log-level override with conf
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="log-level=timings"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Log level:                "_$C(27)_"[38;5;6mtimings",.ret)
    ;
    do eq^%ut(foundIx>0,1,"looking for log")
    ;
	quit
	;
	;
LOGLEVEL4 	;@test log-level override with conf, then switch
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="log-level=timings"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils("--log-level=sessions")
    set foundIx=$$findIndexInArray^%mindTestUtils("Log level:                "_$C(27)_"[38;5;6msessions",.ret)
    ;
    do eq^%ut(foundIx>0,1,"looking for log")
    ;
	quit
	;
	;
LOGFILE0	;@test
    quit
LOGFILE1	;@test -----------------  log-file
	quit
LOGFILE2	;@test
	quit
LOGFILE3 	;@test log-file override with conf
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="log-file=/opt/mind.log"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Log to:                   "_$C(27)_"[38;5;6m/opt/mind.log",.ret)
    ;
    do eq^%ut(foundIx>0,1,"looking for log")
    ;
	quit
	;
	;
LOGFILE4 	;@test log-file override with conf, then switch
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="log-file=/opt/yottadb/mind.log"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils("--log-level=sessions")
    set foundIx=$$findIndexInArray^%mindTestUtils("Log to:                   "_$C(27)_"[38;5;6m/opt/yottadb/mind.log",.ret)
    ;
    do eq^%ut(foundIx>0,1,"looking for log")
    ;
	quit
	;
	;
DUMPREQ0	;@test
    quit
DUMPREQ1	;@test -----------------  dump-request
	quit
DUMPREQ2	;@test
	quit
DUMPREQ3 	;@test dump-request override with conf
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="dump-request=yes"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Dump requests:            "_$C(27)_"[38;5;6mYes",.ret)
    ;
    do eq^%ut(foundIx>0,1,"looking for dump-request")
    ;
	quit
	;
	;
DUMPREQ4 	;@test dump-request override with conf, then switch
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="dump-request=yes"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils("--dump-request=no")
    set foundIx=$$findIndexInArray^%mindTestUtils("Dump requests:            "_$C(27)_"[38;5;6mNo",.ret)
    ;
    do eq^%ut(foundIx>0,1,"looking for dump-request")
    ;
	quit
	;
	;
DUMPRESP0	;@test
    quit
DUMPRESP1	;@test -----------------  dump-responses
	quit
DUMPRESP2	;@test
	quit
DUMPRESP3 	;@test dump-response override with conf
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="dump-response=yes"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("3mDump responses:           "_$C(27)_"[38;5;6mYes",.ret)
    ;
    do eq^%ut(foundIx>0,1,"looking for dump-response")
    ;
	quit
	;
	;
DUMPRESP4 	;@test dump-response override with conf, then switch
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="dump-response=yes"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils("--dump-response=no")
    set foundIx=$$findIndexInArray^%mindTestUtils("3mDump responses:           "_$C(27)_"[38;5;6mNo",.ret)
    ;
    do eq^%ut(foundIx>0,1,"looking for dump-response")
    ;
	quit
	;
	;
STATS0	;@test
    quit
STATS1	;@test -----------------  statistics
	quit
STATS2	;@test
	quit
STATS3 	;@test statistics override with conf
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="statistics=grand"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Statistics:               "_$C(27)_"[38;5;6mOnly grand totals",.ret)
    ;
    do eq^%ut(foundIx>0,1,"looking for statistics")
    ;
	quit
	;
	;
STATS4 	;@test dump-responses override with conf, then switch
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="statistics=grand"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils("--statistics=details")
    set foundIx=$$findIndexInArray^%mindTestUtils("Statistics:               "_$C(27)_"[38;5;6mDetailed",.ret)
    ;
    do eq^%ut(foundIx>0,1,"looking for statistics")
    ;
	quit
	;
	;
ERRDUMP0	;@test
    quit
ERRDUMP1	;@test -----------------  error-dump
	quit
ERRDUMP2	;@test
	quit
ERRDUMP3 	;@test error-dump override with conf
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="error-dump=none"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("3mErrors dump:              "_$C(27)_"[38;5;6mNone",.ret)
    ;
    do eq^%ut(foundIx>0,1,"looking for error-dump")
    ;
	quit
	;
	;
ERRDUMP4 	;@test error-dump override with conf, then switch
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="error-dump=none"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils("--error-dump=extended")
    set foundIx=$$findIndexInArray^%mindTestUtils("3mErrors dump:              "_$C(27)_"[38;5;6mExtended",.ret)
    ;
    do eq^%ut(foundIx>0,1,"looking for error-dump")
    ;
	quit
	;
	;
APIDIR0	;@test
    quit
APIDIR1	;@test -----------------  uapi-dir
	quit
APIDIR2	;@test
	quit
APIDIR3 	;@test uapi-dir override with conf
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="uapi-dir=/opt/mind"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("3mUser API dir:             "_$C(27)_"[38;5;6m/opt/mind",.ret)
    ;
    do eq^%ut(foundIx>0,1,"looking for uapi-dir")
    ;
	quit
	;
	;
APIDIR4 	;@test uapi-dir override with conf, then switch
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="uapi-dir=/opt/mind"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils("--uapi-dir=/tmp")
    set foundIx=$$findIndexInArray^%mindTestUtils("3mUser API dir:             "_$C(27)_"[38;5;6m/tmp",.ret)
    ;
    do eq^%ut(foundIx>0,1,"looking for uapi-dir")
    ;
	quit
	;
	;
CONWIDTH0	;@test
    quit
CONWIDTH1	;@test -----------------  console width
	quit
CONWIDTH2	;@test
	quit
CONWIDTH3 	;@test uapi-dir override with conf
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="console-width=81"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("[38;5;3mConsole width:            "_$C(27)_"[38;5;6m81",.ret)
    ;
    do eq^%ut(foundIx>0,1,"looking for uapi-dir")
    ;
	quit
	;
	;
CONWIDTH4 	;@test console-width override with conf, then switch
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="console-width=81"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils("--console-width=90")
    set foundIx=$$findIndexInArray^%mindTestUtils("[38;5;3mConsole width:            "_$C(27)_"[38;5;6m90",.ret)
    ;
    do eq^%ut(foundIx>0,1,"looking for uapi-dir")
    ;
	quit
	;
	;
IDLETOUT0	;@test
    quit
IDLETOUT1	;@test -----------------  session idle timeout
	quit
IDLETOUT2	;@test
	quit
IDLETOUT3 	;@test uapi-dir override with conf
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="session-idle-timeout=22"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("[38;5;3mSession idle timeout:     "_$C(27)_"[38;5;6m22 mins",.ret)
    ;
    do eq^%ut(foundIx>0,1,"looking for uapi-dir")
    ;
	quit
	;
	;
IDLETOUT4 	;@test console-width override with conf, then switch
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="session-idle-timeout=22"
    do writeToConfig^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils("--session-idle-timeout=44")
    set foundIx=$$findIndexInArray^%mindTestUtils("[38;5;3mSession idle timeout:     "_$C(27)_"[38;5;6m44 mins",.ret)
    ;
    do eq^%ut(foundIx>0,1,"looking for uapi-dir")
    ;
	quit
	;
	;
TLSCHECK0	;@test
    quit
TLSCHECK1	;@test -----------------  tls check
	quit
TLSCHECK2	;@test
	quit
TLSCHECK3 	;@test when both libs and config are installed and tls is on
    new string,LF,ret,foundIx
    ;
    set *ret=$$runMind^%mindTestUtils("--use-tls=yes")
    set foundIx=$$findIndexInArray^%mindTestUtils($C(27)_"[38;5;3mUse TLS:                  "_$C(27)_"[38;5;6mYES",.ret)
    ;
    do eq^%ut(foundIx>0,1,"looking for uapi-dir")
    ;
	quit
	;
	;
TLSCHECK4 	;@test when libs are installed but not config and tls is on
    new string,LF,ret,foundIx
    ;
    zsystem "mv $ydb_dist/plugin/libgtmcrypt.so $ydb_dist/plugin/libgtmcrypt.so.old"
    ;
    set *ret=$$runMind^%mindTestUtils("--use-tls=yes")
    set foundIx=$$findIndexInArray^%mindTestUtils($C(27)_"[38;5;1mtls configuration file not found",.ret)
    ;
    do eq^%ut(foundIx>0,1,"looking for uapi-dir")
    ;
    zsystem "mv $ydb_dist/plugin/libgtmcrypt.so.old $ydb_dist/plugin/libgtmcrypt.so"
    ;
	quit
	;
	;
TLSCHECK5 	;@test when libs are installed but not config and tls is off
    new string,LF,ret,foundIx
    ;
    zsystem "mv $ydb_dist/plugin/libgtmcrypt.so $ydb_dist/plugin/libgtmcrypt.so.old"
    ;
    set *ret=$$runMind^%mindTestUtils("--use-tls=no")
    set foundIx=$$findIndexInArray^%mindTestUtils("[38;5;3mUse TLS:                  "_$C(27)_"[38;5;6mNot installed or configured",.ret)
    ;
    do eq^%ut(foundIx>0,1,"looking for uapi-dir")
    ;
    zsystem "mv $ydb_dist/plugin/libgtmcrypt.so.old $ydb_dist/plugin/libgtmcrypt.so"
    ;
	quit
	;
	;
TLSCHECK6 	;@test when libs and config are not installed and tls is on
    new string,LF,ret,foundIx
    ;
    zsystem "mv $ydb_dist/plugin/libgtmcrypt.so $ydb_dist/plugin/libgtmcrypt.so.old"
    zsystem "mv $ydb_dist/plugin/etc/mind/mind.ydbcrypt $ydb_dist/plugin/etc/mind/mind.ydbcrypt.old"
    ;
    set *ret=$$runMind^%mindTestUtils("--use-tls=yes")
    set foundIx=$$findIndexInArray^%mindTestUtils("[38;5;1mtls NOT installed",.ret)
    ;
    do eq^%ut(foundIx>0,1,"looking for uapi-dir")
    ;
    zsystem "mv $ydb_dist/plugin/libgtmcrypt.so.old $ydb_dist/plugin/libgtmcrypt.so"
    zsystem "mv $ydb_dist/plugin/etc/mind/mind.ydbcrypt.old $ydb_dist/plugin/etc/mind/mind.ydbcrypt"
    ;
	quit
	;
	;
TLSCHECK7 	;@test when libs and config are not installed and tls is off
    new string,LF,ret,foundIx
    ;
    zsystem "mv $ydb_dist/plugin/libgtmcrypt.so $ydb_dist/plugin/libgtmcrypt.so.old"
    zsystem "mv $ydb_dist/plugin/etc/mind/mind.ydbcrypt $ydb_dist/plugin/etc/mind/mind.ydbcrypt.old"
    ;
    set *ret=$$runMind^%mindTestUtils("--use-tls=no")
    set foundIx=$$findIndexInArray^%mindTestUtils("[38;5;3mUse TLS:                  "_$C(27)_"[38;5;6mNot installed or configured",.ret)
    ;
    do eq^%ut(foundIx>0,1,"looking for uapi-dir")
    ;
    zsystem "mv $ydb_dist/plugin/libgtmcrypt.so.old $ydb_dist/plugin/libgtmcrypt.so"
    zsystem "mv $ydb_dist/plugin/etc/mind/mind.ydbcrypt.old $ydb_dist/plugin/etc/mind/mind.ydbcrypt"
    ;
	quit
	;
	;
