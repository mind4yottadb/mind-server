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
UAPI0	;@test
    quit
UAPI1	;@test -----------------  Empty or bad JSON
	quit
UAPI2	;@test
	quit
UAPI3 	;@test root as object instead of array
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="{""test"":2}"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("WARNING: JSON root must be an array...",.ret)
    ;
    do eq^%ut(foundIx>0,1,"should have no dump inbetween")
    ;
	quit
	;
	;
UAPI4 	;@test empty json
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="{}"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("WARNING: File does not contain any JSON data",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;
UAPI5 	;@test empty file
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string=""
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("WARNING: File does not contain any JSON data",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;
UAPI6 	;@test missing file
    new string,LF,ret,foundIx
    ;
    zsystem "mv $ydb_dist/plugin/etc/mind/user-api.json $ydb_dist/plugin/etc/mind/user-api.json.old.2"
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("User API file: $ydb_dist/plugin/etc/mind/user-api.json not found",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
    zsystem "mv $ydb_dist/plugin/etc/mind/user-api.json.old.2 $ydb_dist/plugin/etc/mind/user-api.json"
    ;
	quit
	;
	;
UAPI7	;@test
    quit
UAPI8	;@test -----------------  Namespace
	quit
UAPI9	;@test
	quit
UAPI10 	;@test name missing in root namespace
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""test"":12}]"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("in root has the following error: No name found",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;
UAPI11 	;@test missing either children, functions or methods
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""myName""}]"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("you need at least one of the following: methods, properties or namespaces",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;
UAPI12 	;@test children as not array
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""myName"",""children"":{""test"":3}}]"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("children node exists, but is not an array",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;
UAPI13 	;@test properties as not array
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""myName"",""properties"":{""test"":3}}]"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("properties node exists, but is not an array",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;
UAPI14 	;@test methods as not array
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""myName"",""methods"":{""test"":3}}]"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("methods node exists, but is not an array",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;
UAPI15 	;@test children without a name
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""myName"",""children"":[{""test"":3}]}]"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("the following error: No name found",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;
UAPI16 	;@test too deeply nested namespaces
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""myName"",""children"":[{""name"":""myName"",""children"":[{""name"":""myName2"",""children"":[{""name"":3}]}]}]}]"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("namespace can be maximum 3 levels deep",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;
UAPI16x 	;@test no props or methods on last namespace level
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""myName"",""children"":[{""name"":""myName"",""children"":[{""name"":""myName""}]}]}]"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("You need at least one method or property",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;
UAPI17	;@test
    quit
UAPI18	;@test -----------------  Property
	quit
UAPI19	;@test
	quit
UAPI20 	;@test property with no name
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""banking"",""properties"":["
    set string=string_"""test"":2"
    set string=string_"]}]"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("banking has no name",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;
UAPI20x 	;@test property with no entry point
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""banking"",""properties"":["
    set string=string_"{""name"":""prop1""}"
    set string=string_"]}]"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("banking has no datatype set",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;

UAPI22 	;@test property with no datatype node
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""banking"",""properties"":["
    set string=string_"{""name"":""prop1"",""entryPoint"":""myLabel^myRoutine""}"
    set string=string_"]}]"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("banking has no datatype set",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;
UAPI23 	;@test property with invalid datatype
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""banking"",""properties"":["
    set string=string_"{""name"":""prop1"",""datatype"":""data""}"
    set string=string_"]}]"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("banking has invalid datatype",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;
UAPI24 	;@test property with valid datatype: string
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""banking"",""properties"":["
    set string=string_"{""name"":""prop1"",""datatype"":""string""}"
    set string=string_"]}]"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("banking has no value set",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;
UAPI25 	;@test property with valid datatype: int
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""banking"",""properties"":["
    set string=string_"{""name"":""prop1"",""datatype"":""int""}"
    set string=string_"]}]"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("banking has no value set",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;
UAPI26 	;@test property with valid  datatype: float
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""banking"",""properties"":["
    set string=string_"{""name"":""prop1"",""datatype"":""float""}"
    set string=string_"]}]"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("banking has no value set",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;
UAPI27 	;@test property with valid  datatype: boolean
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""banking"",""properties"":["
    set string=string_"{""name"":""prop1"",""datatype"":""boolean""}"
    set string=string_"]}]"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("banking has no value set",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;
UAPI28 	;@test valid datatype: boolean and invalid numeric value
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""banking"",""properties"":["
    set string=string_"{""name"":""prop1"",""datatype"":""boolean"",""value"":1}"
    set string=string_"]}]"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("datatype is boolean but value is number",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;
UAPI29 	;@test valid  datatype: boolean and invalid string value
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""banking"",""properties"":["
    set string=string_"{""name"":""prop1"",""datatype"":""boolean"",""value"":""myvalue""}"
    set string=string_"]}]"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("datatype is boolean but value is not true or false",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;
UAPI30 	;@test valid  datatype: boolean and valid string value
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""banking"",""properties"":["
    set string=string_"{""name"":""prop1"",""datatype"":""boolean"",""value"":""true""}"
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
UAPI31 	;@test valid  datatype: boolean and valid string value
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""banking"",""properties"":["
    set string=string_"{""name"":""prop1"",""datatype"":""boolean"",""value"":""false""}"
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
UAPI32 	;@test valid  datatype: string and invalid number value
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""banking"",""properties"":["
    set string=string_"{""name"":""prop1"",""datatype"":""string"",""value"":22}"
    set string=string_"]}]"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("datatype is string but value is number",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;
UAPI33 	;@test valid  datatype: string and invalid number value
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""banking"",""properties"":["
    set string=string_"{""name"":""prop1"",""datatype"":""string"",""value"":22.34}"
    set string=string_"]}]"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("datatype is string but value is number",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;
UAPI34 	;@test valid  datatype: int and invalid string value
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""banking"",""properties"":["
    set string=string_"{""name"":""prop1"",""datatype"":""int"",""value"":""thisis23""}"
    set string=string_"]}]"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("datatype is int but value is string",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;
UAPI35 	;@test valid  datatype: int and invalid float value
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""banking"",""properties"":["
    set string=string_"{""name"":""prop1"",""datatype"":""int"",""value"":22.34}"
    set string=string_"]}]"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("int but value is float",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;
UAPI36 	;@test valid  datatype: int and valid int value
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""banking"",""properties"":["
    set string=string_"{""name"":""prop1"",""datatype"":""int"",""value"":22}"
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
UAPI37 	;@test valid  datatype: float and valid int value
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""banking"",""properties"":["
    set string=string_"{""name"":""prop1"",""datatype"":""float"",""value"":22}"
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
UAPI38 	;@test valid datatype: float and valid float value
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""banking"",""properties"":["
    set string=string_"{""name"":""prop1"",""datatype"":""float"",""value"":22.234}"
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
UAPI39 	;@test valid  datatype: float and invalid string value
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""banking"",""properties"":["
    set string=string_"{""name"":""prop1"",""datatype"":""float"",""value"":""a string""}"
    set string=string_"]}]"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("datatype is float but value is string",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;
UAPI40	;@test
    quit
UAPI41	;@test -----------------  Method
	quit
UAPI42	;@test
	quit
UAPI43 	;@test method with no name
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""banking"",""methods"":["
    set string=string_"""test"":2"
    set string=string_"]}]"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("banking has no name",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;
UAPI43a 	;@test method with no entry point
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""banking"",""methods"":["
    set string=string_"{""name"":""addMe""}"
    set string=string_"]}]"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("banking has no entry point",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;
UAPI44 	;@test method with bad entry point
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""banking"",""methods"":["
    set string=string_"{""name"":""addMe"",""entryPoint"":""myRoutine""}"
    set string=string_"]}]"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("namespace: banking has an invalid entry point",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;
UAPI45 	;@test method with bad parameters node
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""banking"",""methods"":["
    set string=string_"{""name"":""addMe"",""entryPoint"":""myLabel^myRoutine"",""returns"":""int"","
    set string=string_"""parameters"":{""test"":2}}"
    set string=string_"]}]"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("method: addMe in namespace: banking parameters node exists, but is not an array",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;
UAPI50	;@test
    quit
UAPI51	;@test -----------------  Parameters
	quit
UAPI52	;@test
	quit
UAPI53 	;@test method with one parameter, no name
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""banking"",""methods"":["
    set string=string_"{""name"":""addMe"",""entryPoint"":""myLabel^myRoutine"",""returns"":""int"","
    set string=string_"""parameters"":["
    set string=string_"{""test"":2}]}"
    set string=string_"]}]"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("method: addMe in namespace: banking parameter 1: has no name",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;
UAPI54 	;@test method with one parameter, with name, no data type
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""banking"",""methods"":["
    set string=string_"{""name"":""addMe"",""entryPoint"":""myLabel^myRoutine"",""returns"":""int"","
    set string=string_"""parameters"":["
    set string=string_"{""name"":""str""}]}"
    set string=string_"]}]"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("method: addMe in namespace: banking parameter: str: has no datatype",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;
UAPI55 	;@test method with one parameter, invalid data type
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""banking"",""methods"":["
    set string=string_"{""name"":""addMe"",""entryPoint"":""myLabel^myRoutine"",""returns"":""int"","
    set string=string_"""parameters"":["
    set string=string_"{""name"":""str"",""datatype"":""ttt""}]}"
    set string=string_"]}]"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("method: addMe in namespace: banking parameter: str: has invalid datatype",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;
UAPI56 	;@test method with one parameter, valid data type
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""banking"",""methods"":["
    set string=string_"{""name"":""addMe"",""entryPoint"":""myLabel^myRoutine"",""returns"":""int"","
    set string=string_"""parameters"":["
    set string=string_"{""name"":""str"",""datatype"":""string""}]}"
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
UAPI57 	;@test method with one parameter, valid data type
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""banking"",""methods"":["
    set string=string_"{""name"":""addMe"",""entryPoint"":""myLabel^myRoutine"",""returns"":""int"","
    set string=string_"""parameters"":["
    set string=string_"{""name"":""str"",""datatype"":""int""}]}"
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
UAPI58 	;@test method with one parameter, valid data type
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""banking"",""methods"":["
    set string=string_"{""name"":""addMe"",""entryPoint"":""myLabel^myRoutine"",""returns"":""int"","
    set string=string_"""parameters"":["
    set string=string_"{""name"":""str"",""datatype"":""float""}]}"
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
UAPI59 	;@test method with one parameter, valid data type
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""banking"",""methods"":["
    set string=string_"{""name"":""addMe"",""entryPoint"":""myLabel^myRoutine"",""returns"":""int"","
    set string=string_"""parameters"":["
    set string=string_"{""name"":""str"",""datatype"":""boolean""}]}"
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
UAPI61 	;@test method with one parameter, valid data type
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""banking"",""methods"":["
    set string=string_"{""name"":""addMe"",""entryPoint"":""myLabel^myRoutine"",""returns"":""int"","
    set string=string_"""parameters"":["
    set string=string_"{""name"":""str"",""datatype"":""object""}]}"
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
UAPI62 	;@test method with one parameter, valid data type
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""banking"",""methods"":["
    set string=string_"{""name"":""addMe"",""entryPoint"":""myLabel^myRoutine"",""returns"":""int"","
    set string=string_"""parameters"":["
    set string=string_"{""name"":""str"",""datatype"":""array""}]}"
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
UAPI63 	;@test method with one parameter, valid data type
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
UAPI63 	;@test method with one parameter, valid data type
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
UAPI109 	;@test good name in root namespace: 3 char long
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""ban"",""methods"":["
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
UAPI110 	;@test good name in root namespace: 2 char long
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""ba"",""methods"":["
    set string=string_"]}]"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("or len<3",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;
UAPI120 	;@test bad name method
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""banking"",""methods"":["
    set string=string_"{""name"":""1addMe"",""entryPoint"":""myLabel^myRoutine"",""returns"":""int"","
    set string=string_"""parameters"":["
    set string=string_"{""name"":""str"",""datatype"":""any""}]}"
    set string=string_"]}]"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("method: 1 in namespace: banking  has the following error: Invalid chars",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;
UAPI121 	;@test bad name method
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""banking"",""methods"":["
    set string=string_"{""name"":""ad@dMe"",""entryPoint"":""myLabel^myRoutine"",""returns"":""int"","
    set string=string_"""parameters"":["
    set string=string_"{""name"":""str"",""datatype"":""any""}]}"
    set string=string_"]}]"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("method: 1 in namespace: banking  has the following error: Invalid chars",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;
UAPI122 	;@test bad name parameter
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""banking"",""methods"":["
    set string=string_"{""name"":""addMe"",""entryPoint"":""myLabel^myRoutine"",""returns"":""int"","
    set string=string_"""parameters"":["
    set string=string_"{""name"":""1str"",""datatype"":""any""}]}"
    set string=string_"]}]"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("method: addMe in namespace: banking parameter: 1str:  has the following error: Invalid",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;
UAPI123 	;@test bad name sub namespace
    new string,LF,ret,foundIx
    ;
    set LF=$zchar(10)
    ;
    ; create a new one
    set string="[{""name"":""banking"",""methods"":["
    set string=string_"{""name"":""addMe"",""entryPoint"":""myLabel^myRoutine"",""returns"":""int"","
    set string=string_"""parameters"":["
    set string=string_"{""name"":""str"",""datatype"":""any""}]}"
    set string=string_"],""children"":["
    set string=string_"{""name"":""1sub""}"
    set string=string_"]}]"
    do writeToUserApi^%mindTestUtils(.string)
    ;
    set *ret=$$runMind^%mindTestUtils()
    set foundIx=$$findIndexInArray^%mindTestUtils("Namespace: banking:  name: 1sub has the following error: Invalid chars",.ret)
    ;
    do eq^%ut(foundIx>0,1,"")
    ;
	quit
	;
	;
