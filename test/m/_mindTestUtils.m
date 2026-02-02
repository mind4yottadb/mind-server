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
runMind(param)
	new device,string,currentdevice,command,cnt,return
	;
	set currentdevice=$io
	set device="runshellcommmandpipe"_$job
	set command="/opt/mind/mind --init-only "_$get(param)
	;
	open device:(shell="/bin/sh":command=command):5:"pipe"
	use device
	for  quit:$zeof=1  read:5 string quit:$test=0  set return($increment(cnt))=string
	close device
	;
	use currentdevice
	;
	if $zclose'=0 set return=$zstatus
    ;
	quit *return
	;
	;
findStringInArray(str,array)
    new ix,found
    ;
    set ix="",found=0  for  set ix=$order(array(ix)) quit:ix=""  if $find(array(ix),str) set found=1 quit
    ;
    quit found
    ;
    ;
findIndexInArray(str,array)
    new ix,found
    ;
    set ix="",found=0  for  set ix=$order(array(ix)) quit:ix=""  if $find(array(ix),str) set found=1 quit
    ;
    set:found=1 found=ix
    ;
    quit found
    ;
    ;
backupConfigFile
    zsystem "cp $ydb_dist/plugin/etc/mind/mind.conf $ydb_dist/plugin/etc/mind/mind.conf.old"
    ;
    quit
    ;
    ;
restoreConfigFile
    zsystem "cp $ydb_dist/plugin/etc/mind/mind.conf.old $ydb_dist/plugin/etc/mind/mind.conf"
    ;
    quit
    ;
    ;
backupUsersFile
    zsystem "cp $ydb_dist/plugin/etc/mind/users.json $ydb_dist/plugin/etc/mind/users.json.old"
    ;
    quit
    ;
    ;
restoreUsersFile
    zsystem "cp $ydb_dist/plugin/etc/mind/users.json.old $ydb_dist/plugin/etc/mind/users.json"
    ;
    quit
    ;
    ;
backupUserApiFile
    zsystem "cp $ydb_dist/plugin/etc/mind/user-api.json $ydb_dist/plugin/etc/mind/user-api.json.old"
    ;
    quit
    ;
    ;
restoreUserApiFile
    zsystem "cp $ydb_dist/plugin/etc/mind/user-api.json.old $ydb_dist/plugin/etc/mind/user-api.json"
    ;
    quit
    ;
    ;
writeToConfig(string)
    new %params,%res,CRLF
    ;
    set CRLF=$zchar(13)_$zchar(10)
    set %params(1)="$ydb_dist/plugin/etc/mind/mind.conf"
    set %params(2)=string
    do writeFile^%mindNSfs
    ;
    quit
    ;
    ;
writeToUserApi(string)
    new %params,%res,CRLF
    ;
    set CRLF=$zchar(13)_$zchar(10)
    set %params(1)="$ydb_dist/plugin/etc/mind/user-api.json"
    set %params(2)=string
    do writeFile^%mindNSfs
    ;
    write %trm("tty_reset")
    ;
    quit
    ;
    ;


