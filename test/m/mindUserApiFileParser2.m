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
File
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
	; init terminal
   	do set^%mindTerminal
   	;
    do backupUserApiFile^%mindTestUtils
	write !,"Backup created..."
	;
	quit
	;
	;
SHUTDOWN
	do restoreUserApiFile^%mindTestUtils
	write !!,"Backup restored..."
	;
	quit
	;
	;
UAPI100 	;@test bad name in root namespace: num as first
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""1banking"",""methods"":["
    set string=string_"]}]"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Object:1 in root has the following error: Invalid chars in name",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;
UAPI101 	;@test bad name in root namespace: num as 1st
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""1banking"",""methods"":["
    set string=string_"]}]"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Object:1 in root has the following error: Invalid chars in name",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;
UAPI102 	;@test bad name in root namespace: symbol as first
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""$banking"",""methods"":["
    set string=string_"]}]"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Object:1 in root has the following error: Invalid chars in name",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;
UAPI103 	;@test bad name in root namespace: symbol as first
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""1banking"",""methods"":["
    set string=string_"]}]"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Object:1 in root has the following error: Invalid chars in name",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;
UAPI104 	;@test good name in root namespace: underscore as first
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""_banking"",""methods"":["
    set string=string_"]}]"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("you need at least one of the following: methods, properties",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;
UAPI105 	;@test good name in root namespace: num in middle
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""ban4king"",""methods"":["
    set string=string_"]}]"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Namespace: ban4king: you need at least one of the following: methods, properties or nam",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;
UAPI106 	;@test bad name in root namespace: symbol in middle
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""ban$king"",""methods"":["
    set string=string_"]}]"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Object:1 in root has the following error: Invalid chars in name",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;
UAPI107 	;@test bad name in root namespace: symbol in middle
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""ban&king"",""methods"":["
    set string=string_"]}]"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Object:1 in root has the following error: Invalid chars in name",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;
UAPI108 	;@test good name in root namespace: underscore in middle
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""ban_king"",""methods"":["
    set string=string_"]}]"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("you need at least one of the following: methods, properties",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;























UAPI100 	;@test bad name in root namespace
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""banking"",""methods"":["
    set string=string_"{""name"":""addMe"",""entryPoint"":""myLabel^myRoutine"",""returns"":""int"","
    set string=string_"""parameters"":["
    set string=string_"{""name"":""str"",""datatype"":""any""}]}"
    set string=string_"]}]"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("user-api file processed",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;
