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
parse
    new level,userApiFile
    new counter,buffer,string
    new JDOM,JERR

	set level=$zlevel
	;
	; look for config file
	set configFile="$ydb_dist/plugin/etc/mind/user-api.json"
	set userApiFile=$zsearch(configFile)
	if userApiFile="" do dumpError("User API file: "_configFile_" not found...") quit
	open userApiFile:(read:EXCEPTION="goto userApiError")
	use userApiFile
	;
	for  quit:$zeof  read string set buffer($increment(counter))=string
	;
closeFile
	close userApiFile
	;
	write !,"Processing user-api file: "_configFile
    ;
    ; parse the json
    do parse^%mindJSON("buffer","JDOM","JERR")
    if $data(JERR) do dumpError("Error parsing JSON: "_$get(JERR(1))_" "_$get(JERR(2))) quit
    ;
    ; Quit if file is empty
    if $data(JDOM)=0 do dumpError("File does not contain any JSON data...") quit
    ;
    ; ----------------------------------------
    ; PARSER
    ; ----------------------------------------
    ; ensure root is array
    if $$isArray("JDOM")=0 do dumpError("JSON root must be an array...") quit
    ;
    new ix,ret,exit
    ;
    set ix="",exit=0 for  set ix=$order(JDOM(ix)) quit:ix=""!(exit)  do
    . ; test for name
    . if $get(JDOM(ix,"name"))="" do dumpError("Object:"_ix_" in root has the following error: No name found") set exit=1 quit
    . ;
    . ; test the namespace
    . set ret=$$parseNamespace($name(JDOM(ix)),JDOM(ix,"name"))
    . if ret'="" do dumpError(ret) set exit=1
    ;
    ; quit if error was returned
    quit:exit
    ;
	write !,"user-api file processed..."
	;
	; copy the JDOM to the config for later usage
	set ix="" for  set ix=$order(buffer(ix)) quit:ix=""  set %mindParams("uApiJson")=%mindParams("uApiJson")_buffer(ix)
    ;
continueAfterUserApiFileError
    quit
    ;
userApiError
	new errorNumber
	;
	set errorNumber=$zpiece($zstatus,",",1)
	zgoto:errorNumber=150373082 level:closeFile
	use zpout
	write !,%trm("red"),"WARNING: Error opening userApi file...",!
	write "Filename: ",configFile,!,$zstatus ;"Error:",$zpiece($zstatus,",",6),%trm("white"),!
	zgoto level:continueAfterUserApiFileError
    ;
    ;
dumpError(errString)
    write !,%trm("red")_"WARNING: ",errString,!,"USER-API NOT AVAILABLE..."
    ;
    quit
    ;
    ;
parseNamespace(obj,namespace)
    ; returns:
    ; empty string, all ok
    ; string '= "" error string
    ;
    new err,hasChildren,hasProperties,hasMethods
    new errHeader,iy,error
    ;
    set err="",(hasChildren,hasProperties,hasMethods)=0
    set errHeader="Namespace: "_namespace_": "
    ;
    ; quit if levels > 2
    if +$zlength(namespace)-$zlength($translate(namespace,".",""))>2 do  goto parseNamespaceQuit
    . set err=errHeader_"too many namespaces"
    ; last namespace can only has props or methods
    set hasProperties=$data(@obj@("properties")),hasMethods=$data(@obj@("methods")),hasChildren=$data(@obj@("children"))
    ;
    if +$zlength(namespace)-$zlength($translate(namespace,".",""))=2 do
    . if hasChildren set err=errHeader_"namespace can be maximum 3 levels deep" quit
    . if hasProperties=0,hasMethods=0 set err=errHeader_"You need at least one method or property" quit
    else  do
    . ; verify that at least one of these nodes exists and they are arrays with items
    . if hasProperties=0,hasMethods=0,hasChildren=0 do
    . . set err=errHeader_"you need at least one of the following: methods, properties or namespaces"
    ;
    goto:err'="" parseNamespaceQuit
    ;
    ; verify that existing nodes are arrays
    if hasChildren,$$isArray($name(@obj@("children")))=0 do  goto parseNamespaceQuit
    . set err=errHeader_"children node exists, but is not an array"
    if hasProperties,$$isArray($name(@obj@("properties")))=0 do  goto parseNamespaceQuit
    . set err=errHeader_"properties node exists, but is not an array"
    if hasMethods,$$isArray($name(@obj@("methods")))=0 do  goto parseNamespaceQuit
    . set err=errHeader_"methods node exists, but is not an array"
    ;
    ; properties
    if hasProperties set iy="" for  set iy=$order(@obj@("properties",iy)) quit:iy=""  do  quit:err'=""
    . set err=$$parseProperty($name(@obj@("properties",iy)),namespace)
    ;
    ; methods
    if hasMethods set iy="" for  set iy=$order(@obj@("methods",iy)) quit:iy=""  do  quit:err'=""
    . set err=$$parseMethod($name(@obj@("methods",iy)),namespace)
    ;
    ; namespaces
    set error=0
    if hasChildren set iy="" for  set iy=$order(@obj@("children",iy)) quit:iy=""!(error)  do
    . ; test for name
    . if $get(@obj@("children",iy,"name"))="" do dumpError(errHeader_" has the following error: No name found") set exit=1 quit
    . set err=$$parseNamespace($name(@obj@("children",iy)),namespace_"."_@obj@("children",iy,"name"))
    ;
parseNamespaceQuit
    quit err
    ;
    ;
parseProperty(obj,namespace)
    new err,errHeader,iz
    ;
    set err="",errHeader="function: "_iy_" in namespace: "_namespace_" "
    ;
    ; verify that the entrypoint is there
    if $get(@obj@("entryPoint"))="" do  goto parseFunctionQuit
    . set err=errHeader_"has no entry point"
    ;
    ; and it has a valid syntax
    if $find(@obj@("entryPoint"),"^")=0 do  goto parseFunctionQuit
    . set err=errHeader_"has an invalid entry point"
    ;
    set errHeader="function: "_$zpiece(@obj@("entryPoint"),"^",1)_" in namespace: "_namespace_" "
    ;
    ; verify that the return value is there
    if $get(@obj@("returns"))="" do  goto parseFunctionQuit
    . set err=errHeader_"has no returns set"
    ;
    ; verify that the return value is valid
    if $find(%mindParams("uApiDataTypes"),@obj@("returns"))=0 do  goto parseFunctionQuit
    . set err=errHeader_"has invalid return datatype"
    ;
    ; ----------------------------
    ; REGISTER FUNCTION
    ; ----------------------------
    set %mindParams("uApi",namespace_"."_$piece(@obj@("entryPoint"),"^",1))=@obj@("entryPoint")
    ;
    ; now parse parameters
    ; verify that existing node is an array
    if $data(@obj@("parameters")),$$isArray($name(@obj@("parameters")))=0 do  goto parseFunctionQuit
    . set err=errHeader_"parameters node exists, but is not an array"
    ;
    set iz="" for  set iz=$order(@obj@("parameters",iz)) quit:iz=""  do
    . set err=$$parseParameter($name(@obj@("parameters",iz)),namespace,@obj@("entryPoint"),errHeader,iz)
    ;
parseFunctionQuit
    quit err
    ;
    ;
parseMethod(obj,namespace)
    new err,errHeader,iz
    ;
    set err="",errHeader="method: "_iy_" in namespace: "_namespace_" "
    ;
    ; verify that the name is there
    if $get(@obj@("name"))="" do  goto parseMethodQuit
    . set err=errHeader_"has no name"
    ;
    set err="",errHeader="method: "_@obj@("name")_" in namespace: "_namespace_" "
    ;
    ; verify that the entrypoint is there
    if $get(@obj@("entryPoint"))="" do  goto parseMethodQuit
    . set err=errHeader_"has no entry point"
    ;
    ; and it has a valid syntax
    if $find(@obj@("entryPoint"),"^")=0 do  goto parseMethodQuit
    . set err=errHeader_"has an invalid entry point"
    ;
    set errHeader="method: "_$zpiece(@obj@("entryPoint"),"^",1)_" in namespace: "_namespace_" "
    ;
    ; verify that the return value is valid
    if $data(@obj@("returns")),$find(%mindParams("uApiDataTypes"),@obj@("returns"))=0 do  goto parseMethodQuit
    . set err=errHeader_"has invalid return datatype"
    ;
    ; now parse parameters
    ; verify that existing node is an array
    if $data(@obj@("parameters")),$$isArray($name(@obj@("parameters")))=0 do  goto parseMethodQuit
    . set err=errHeader_"parameters node exists, but is not an array"
    ;
    set iz="" for  set iz=$order(@obj@("parameters",iz)) quit:iz=""  do
    . set err=$$parseParameter($name(@obj@("parameters",iz)),namespace,@obj@("name"),errHeader,iz)
    ;
    ; ----------------------------
    ; REGISTER METHOD
    ; ----------------------------
    set %mindParams("uApi",namespace_"."_$piece(@obj@("entryPoint"),"^",1))=@obj@("entryPoint")
    ;
parseMethodQuit
    quit err
    ;
    ;
parseParameter(obj,namespace,function,errHeaderFunction,iz)
    new err,errHeader
    ;
    set err="",errHeader=errHeaderFunction_"parameter "_iz_": "
    ;
    ; verify that the name is there
    if $get(@obj@("name"))="" do  goto parseParameterQuit
    . set err=errHeader_"has no name"
    ;
    set errHeader=errHeaderFunction_"parameter: "_@obj@("name")_": "
    ;
    ; verify that the datatype is there
    if $get(@obj@("datatype"))="" do  goto parseParameterQuit
    . set err=errHeader_"has no datatype"
    ;
    ; verify that the datatype is valid
    if $find(%mindParams("uApiDataTypes"),@obj@("datatype"))=0 do
    . set err=errHeader_"has invalid datatype"
parseParameterQuit
    quit err
    ;
    ;
isArray(node)
    quit $$isNumber^%mindUtils($order(@node@("")))
    ;
    ;