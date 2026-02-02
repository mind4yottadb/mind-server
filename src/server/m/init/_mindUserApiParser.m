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
    zwr JDOM
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
	merge %mindParams("uApiJson")=JDOM
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
    new err,hasChildren,hasFunctions,hasMethods
    new errHeader,iy
    ;
    set err="",(hasChildren,hasFunctions,hasMethods)=0
    set errHeader="Namespace: "_namespace_": "
    ;
    ; verify that at least one of these nodes exists and they are arrays with items
    set hasFunctions=$data(@obj@("functions")),hasMethods=$data(@obj@("methods")),hasChildren=$data(@obj@("children"))
    if hasFunctions=0,hasMethods=0,hasChildren=0 do  goto parseNamespaceQuit
    . set err=errHeader_"you need at least one of the following properties: methods, functions or namespaces"
    ;
    ; verify that existing nodes are arrays
    if hasChildren,$$isArray($name(@obj@("children")))=0 do  goto parseNamespaceQuit
    . set err=errHeader_"children node exists, but is not an array"
    if hasFunctions,$$isArray($name(@obj@("functions")))=0 do  goto parseNamespaceQuit
    . set err=errHeader_"function node exists, but is not an array"
    if hasMethods,$$isArray($name(@obj@("methods")))=0 do  goto parseNamespaceQuit
    . set err=errHeader_"methods node exists, but is not an array"
    ;
    ; functions
    if hasFunctions set iy="" for  set iy=$order(@obj@("functions",iy)) quit:iy=""  do
    . set err=$$parseFunction($name(@obj@("functions",iy)),namespace)




parseNamespaceQuit
    quit err
    ;
    ;
parseFunction(obj,namespace)
    new err
    ;
    set err=""
    ;
    ; verify that the entrypoint is there
    if $get(@obj@("entryPoint"))="" do  goto parseFunctionQuit
    . set err="function: "_iy_" in namespace: "_namespace_" has no entry point"
    ;
    ; and it has a valid syntax
    if $find(@obj@("entryPoint"),"^")=0 do  goto parseFunctionQuit
    . set err="function: "_iy_" in namespace: "_namespace_" has an invalid entry point"
    ;
    ; verify that the return value is there
    if $get(@obj@("returns"))="" do  goto parseFunctionQuit
    . set err="function: "_iy_" in namespace: "_namespace_" has no returns node"
    ;
    ; verify that the return value is valid
    if $find(%mindParams("uApiDataTypes"),@obj@("returns"))=0 do  goto parseFunctionQuit
    . set err="function: "_iy_" in namespace: "_namespace_" has invalid return datatype"
    ;
    ; REGISTER FUNCTION
    set %mindParams("uApi",namespace_"."_$piece(@obj@("entryPoint"),"^",1))=@obj@("entryPoint")
    ;
    ; now parse parameters


parseFunctionQuit
    quit err
    ;
    ;
parseMethod(obj)
    new err
    ;
    set err=""
    ;
    ; verify that at least one of these nodes exists
    ;if


    quit err
    ;
    ;
parseParameter(obj)
    new err
    ;
    set err=""
    ;

    quit err
    ;
    ;
isArray(node)
    quit $$isNumber^%mindUtils($order(@node@("")))
    ;
    ;