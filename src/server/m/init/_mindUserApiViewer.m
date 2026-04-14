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
dumpShort
    new appName,methods,methodsCnt,varsCnt,var,cnt
    ;
    write !!,%trm("light_white"),"APP NAME",?50,"METHODS",?65,"VARS",!
    for cnt=1:1:65 write "-"
    write !
    set appName="" for  set appName=$order(%mindParams("uApi",appName)) quit:appName=""  do
    . write %trm("yellow"),appName,?49
    . set methodsCnt=0,methods=""
    . for  set methods=$order(%mindParams("uApi",appName,methods)) quit:methods=""  set methodsCnt=methodsCnt+1
    . write %trm("cyan"),methodsCnt," method",$select(methodsCnt>1:"s",1:"")
    . set varsCnt=0,var=""
    . for  set var=$order(%mindParams("uApiServer","vars",appName,var)) quit:var=""  set varsCnt=varsCnt+1
    . write ?73,varsCnt," var",$select(varsCnt=1:"",1:"s"),!
dumpShortQuit
    quit
    ;
    ;
dumpFull
    new appName,method,var,cnt
    ;
    write !
    set appName="" for  set appName=$order(%mindParams("uApi",appName)) quit:appName=""  do
    . write %trm("yellow") for cnt=1:1:50 write "-"
    . write !
    . write %trm("light_white"),"APP name: ",%trm("yellow"),appName,!
    . for cnt=1:1:50 write "-"
    . write !
    . write %trm("light_green"),"Methods:",!
    . set method="" for  set method=$order(%mindParams("uApi",appName,method)) quit:method=""  do
    . . write %trm("cyan"),method,"()",!
    . write !
    . if $order(%mindParams("uApiServer","vars",appName,""))'="" do
    . . write %trm("light_green"),"Vars:",!
    . . set var="" for  set var=$order(%mindParams("uApiServer","vars",appName,var)) quit:var=""  do
    . . . write %trm("cyan"),%mindParams("uApiServer","vars",appName,var),!
    . . write !
    ;
dumpFullQuit
    quit
    ;
    ;