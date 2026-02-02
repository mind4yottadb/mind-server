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
    ; ensure root is array
    if $$isArray("JDOM")=0 do dumpError("JSON root must be an array...") quit
    ;
    new ix,iy,iz,ret,exit
    ;
    set ix="",exit=0 for  set ix=$order(JDOM(ix)) quit:ix=""!(exit)  do
    . set ret=$$parseNamespace($name(JDOM(ix)))
    . if ret'="" do dumpError("Object:"_ix_" in root has the following error: "_ret) set exit=1 quit
    . ; do we need to go deeper into children
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
parseNamespace(obj)
    ; returns:
    ; empty string, all ok
    ; string '= "" error string
    ;
    new err,hasChildren,hasFunctions,hasMethods
    ;
    set err="",(hasChildren,hasFunctions,hasMethods)=0
    ;
    ; verify that a name is set
    if $get(@obj@("name"))="" set err="no name found" goto parseNamespaceQuit
    ;
    ; verify that at least one of these nodes exists and they are arrays with items
    set hasFunctions=$data(@obj@("functions")),hasMethods=$data(@obj@("methods")),hasChildren=$data(@obj@("children"))
    if hasFunctions=0,hasMethods=0,hasChildren=0 do  goto parseNamespaceQuit
    . set err="you need at least one of the following properties: methods, functions or namespaces"
    ;
    ; verify that existing nodes are arrays
    if hasChildren,$$isArray($name(@obj@("children")))=0 do  goto parseNamespaceQuit
    . set err="children node exists, but is not an array"
    if hasFunctions,$$isArray($name(@obj@("functions")))=0 do  goto parseNamespaceQuit
    . set err="function node exists, but is not an array"
    if hasMethods,$$isArray($name(@obj@("methods")))=0 do  goto parseNamespaceQuit
    . set err="methods node exists, but is not an array"
    ;





parseNamespaceQuit
    quit err
    ;
    ;
parseFunction(obj)
    new err
    ;
    set err=""
    ;
    ; verify that at least one of these nodes exists
    ;if


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