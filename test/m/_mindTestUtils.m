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
STARTUP
	job start^%ydbxiderServer("--api-only")
	set serverPid=$zjob
	write !,"Xider server started with --api-only using PID: ",serverPid
	;
	kill ^%ydbxider,^%ydbxiderK,^%ydbxiderKDT,^%ydbxiderKT
	;
	quit
	;
	;
SHUTDOWN
	; kill the xider server
	open "p":(command="mupip stop "_serverPid)::"pipe"
	use "p" read x:1
	close "p"
	do eq^%ut($ZCLOSE,0)
	;
	for  quit:'$zgetjpi(serverPid,"isprocalive")  hang .001
	;
	; and the helper process
	open "p":(command="mupip stop "_(serverPid+2))::"pipe"
	use "p" read x:1
	close "p"
	do eq^%ut($ZCLOSE,0)
	;
	for  quit:'$zgetjpi((serverPid+2),"isprocalive")  hang .001
	;
	write !!,"Xider server stopped..."
	;
	quit
	;
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

