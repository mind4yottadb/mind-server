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
parse()
    new level,userApiFile
    new counter,buffer,string
    new JDOM,JERR,JDOMserver,JSONfile
    new dir,file,iy,ret
    new reservedRootNames,names
    new parseError
    ;
	set level=$zlevel
	;
	set parseError=0
	set reservedRootNames("fs")=""
	set reservedRootNames("server")=""
	set reservedRootNames("session")=""
	set reservedRootNames("process")=""
	set reservedRootNames("db")=""
	set reservedRootNames("dbms")=""
	set reservedRootNames("RESP3")=""
	;
	write !
	;
	; sanitize the uApi path
	set uApiPath=%mindParams("userApiDir")
	if $extract(uApiPath,$zlength(uApiPath),$zlength(uApiPath))'="/" set %mindParams("userApiDir")=%mindParams("userApiDir")_"/"
	;
	; search for configuration files
	set file=$zsearch(%mindParams("userApiDir")_"*.json",-1)
    for  set file=$zsearch(%mindParams("userApiDir")_"*.json") quit:file=""  set %mindParams("uApi",$zparse(file,"NAME"))=""
    ;
    ; quit if no files are found
    if $data(%mindParams("uApi"))>9 write !,%mindTrm("green"),"USER API configuration files found!"
    else  write !!,%mindTrm("yellow"),"USER API configuration files not found!" quit 0
    ;
	; read all the config files
	set file="" for  set file=$order(%mindParams("uApi",file)) quit:file=""  do
	. set userApiFile=%mindParams("userApiDir")_file_".json"
	. open userApiFile:read
	. use userApiFile
	. ;
	. for  quit:$zeof  read string set buffer(file,$increment(counter))=$ztranslate(string,$zchar(13),"")
	. ;
	. close userApiFile
	;
    ; parse the json
	set file="" for  set file=$order(%mindParams("uApi",file)) quit:file=""  do  quit:parseError
	. write !,%mindTrm("cyan"),"Processing file: "_file
	. ;
	. kill JDOM,JERR,names,JDOMserver,JDOMfile
    . do parse^%mindJSON($name(buffer(file)),"JDOMfile","JERR")
    . if $data(JERR) do dumpError("Error parsing JSON: "_$get(JERR(1))_" "_$get(JERR(2))) set parseError=1 quit
    . ;
    . ; Quit if file is empty
    . if $data(JDOMfile)=0 do dumpError("File does not contain any JSON data...") set parseError=1 quit
    . ;
    . ; move the server away
    . merge JDOMserver=JDOMfile("server")
    . merge JDOM=JDOMfile("client")
    . ; ----------------------------------------
    . ; PARSER
    . ; ----------------------------------------
    . new exit,varsFound
    . ;
    . ; ----------------------------------------
    . ; parse server
    . ; ----------------------------------------
    . set (varsFound,exit)=0
    . ;
    . ; *********
    . ; vars
    . ; *********
    . if $data(JDOMserver),$data(JDOMserver("vars")) do  quit:parseError
    . . if $$isArray($name(JDOMserver("vars")))=0 do dumpError("JSON server.vars is not an array") set exit=1 quit
    . . set err=$$parseVars($name(JDOMserver("vars")))
    . . if err'="" do dumpError(err) set exit=1 quit
    . . else  merge %mindParams("uApiServer","vars",file)=JDOMserver("vars")
    . ;
    . ; *********
    . ; code
    . ; *********
    . if $data(JDOMserver),$data(JDOMserver("code")),$zlength(JDOMserver("code")) do
    . . ; ensure path / file exists
    . . if $zsearch(JDOMserver("code"),-1)="" do dumpError("server/code: "_JDOMserver("code")_" does not exists or it is not accessible") set exit=1 quit
    . . ; check what type of file it is
    . . ;
    . . ; is it a file and an .so and a valid .so?
    . . if $$isFile^%mindUtils(JDOMserver("code")) do  quit
    . . . if $zparse(JDOMserver("code"),"TYPE")'=".so" do dumpError("server/code: "_JDOMserver("code")_" is not a valid .so file") set exit=1 quit
    . . . new $etrap
    . . . set $etrap="do isNotSo set exit=1,$ecode="""""
    . . . quit:exit
    . . . set $zroutines=JDOMserver("code")_" "_%mindParams("userApiDir")_" "_$zroutines
    . . . set $zroutines=%mindParams("zroutines")
    . . . merge %mindParams("uApiServer","code",file)=JDOMserver("code")
    . . ;
    . . ; is it a directory?
    . . if $$isDir^%mindUtils(JDOMserver("code")) do  quit
    . . . new $etrap
    . . . set $etrap="do dumpError(""server/code: ""_JDOMserver(""code"")_"" is not a valid directory"") set exit=1,$ecode="""" quit"
    . . . set $zroutines=JDOMserver("code")_" "_%mindParams("userApiDir")_" "_$zroutines
    . . . set $zroutines=%mindParams("zroutines")
    . . . merge %mindParams("uApiServer","code",file)=JDOMserver("code")
    . . . ;
    . . ; none of above, error out
    . . do dumpError("server/code: "_JDOMserver("code")_" is neither a file or a directory") set exit=1
    . ;
    . ; *********
    . ; hooks
    . ; *********
    . if $data(JDOMserver),$data(JDOMserver("hooks")),$get(JDOMserver("hooks","onInit"))'=""!($get(JDOMserver("hooks","onTerminate"))'="")!($get(JDOMserver("hooks","onError"))'="") do
    . . ; ensure $zroutines is correct
    . . set $zroutines=$select($get(JDOMserver("code"))="":"",1:JDOMserver("code"))_" "_%mindParams("userApiDir")_" "_$zroutines
    . . ;
    . . ; onInit
    . . if $get(JDOMserver("hooks","onInit"))'="" do  quit:exit
    . . . ; check name syntax
    . . . if $$isValidEntryPoint^%mindUtils(JDOMserver("hooks","onInit"))=0 do dumpError("server/hooks/onInit: "_JDOMserver("hooks","onInit")_" is not a valid entry point name") set exit=1 quit
    . . . ; verify code is available
    . . . if $text(@JDOMserver("hooks","onInit"))="" do dumpError("server/hooks/onInit: "_JDOMserver("hooks","onInit")_" is a valid entry point name but code can not be loaded") set exit=1
    . . ;
    . . ; onTerminate
    . . if $get(JDOMserver("hooks","onTerminate"))'="" do  quit:exit
    . . . ; check name syntax
    . . . if $$isValidEntryPoint^%mindUtils(JDOMserver("hooks","onTerminate"))=0 do dumpError("server/hooks/onTerminate: "_JDOMserver("hooks","onTerminate")_" is not a valid entry point name") set exit=1 quit
    . . . ; verify code is available
    . . . if $text(@JDOMserver("hooks","onTerminate"))="" do dumpError("server/hooks/onTerminate: "_JDOMserver("hooks","onTerminate")_" is a valid entry point name but code can not be loaded") set exit=1
    . . ;
    . . ; onError
    . . if $get(JDOMserver("hooks","onError"))'="" do  quit:exit
    . . . ; check name syntax
    . . . if $$isValidEntryPoint^%mindUtils(JDOMserver("hooks","onError"))=0 do dumpError("server/hooks/onError: "_JDOMserver("hooks","onError")_" is not a valid entry point name") set exit=1 quit
    . . . ; verify code is available
    . . . if $text(@JDOMserver("hooks","onError"))="" do dumpError("server/hooks/onError: "_JDOMserver("hooks","onError")_" is a valid entry point name but code can not be loaded") set exit=1
    . . merge %mindParams("uApiServer","hooks",file)=JDOMserver("hooks")
    . ;
    . if exit do  quit
    . . write !,%mindTrm("red"),"File: "_file_" has errors..."
    . . kill %mindParams("uApi",file),%mindParams("uApiJson",file)
    . ; ----------------------------------------
    . ; parse client
    . ; ----------------------------------------
    . ; ensure client root is array
    . if exit=0,$$isArray("JDOM")=0,varsFound=0 do dumpError("JSON client root must be an array and/or not be empty OR must have vars in the server node.") set exit=1
    . ;
    . new ix,ret
    . ;
    . ;change zroutines to validate entry points
    . set $zroutines=$select($get(JDOMserver("code"))="":"",1:JDOMserver("code"))_" "_%mindParams("userApiDir")_" "_$zroutines
    . ;
    . if exit=0 set ix="",exit=0 for  set ix=$order(JDOM(ix)) quit:ix=""!(exit)  do
    . . ; test for name
    . . if $get(JDOM(ix,"name"))="" do dumpError("Object:"_ix_" in client root has the following error: No name found") set exit=1 quit
    . . ;
    . . ; test the name
    . . if $$isBoolean(JDOM(ix,"name")) do dumpError("Object:"_ix_" in client root has the following error: boolean or null instead of name") set exit=1 quit
    . . if $$isValidApiName^%mindUtils(JDOM(ix,"name"))=0 do dumpError("Object:"_ix_" in client root has the following error: Invalid chars in name or len<3") set exit=1 quit
    . . ;
    . . ; check for reserved root name
    . . if $data(reservedRootNames(JDOM(ix,"name"))) do dumpError("Object:"_JDOM(ix,"name")_" in client root has the following error: Name is reserved and cannot be used in the root") set exit=1 quit
    . . ;
    . . ; test the namespace
    . . set ret=$$parseNamespace($name(JDOM(ix)),JDOM(ix,"name"),.names)
    . . if ret'="" do dumpError(ret) set exit=1
    . ;
    . ; restore $zroutines
    . set $zroutines=%mindParams("zroutines")
    . ;
    . ; remove entry and quit if error was returned
    . if exit do  quit
    . . write !,%mindTrm("red"),"File: "_file_" has errors..."
    . . kill %mindParams("uApi",file),%mindParams("uApiJson",file)
    . . set parseError=1
    . ;
	. write %mindTrm("green")," parsed and compiled OK..."
	. ;
	. ; copy the JDOM to the config for later usage
	. set (iy,%mindParams("uApiJson",file))="" for  set iy=$order(buffer(file,iy)) quit:iy=""  set %mindParams("uApiJson",file)=%mindParams("uApiJson",file)_buffer(file,iy)
	. merge %mindParams("uApiJson",file)=buffer(file)
    ;
continueAfterUserApiFileError
    quit $get(parseError,0)
    ;
userApiError
	new errorNumber
	;
	set errorNumber=$zpiece($zstatus,",",1)
	zgoto:errorNumber=150373082 level:closeFile
	use zpout
	write !,%mindTrm("red"),"WARNING: Error opening userApi file...",!
	write "Filename: ",configFile,!,$zstatus ;"Error:",$zpiece($zstatus,",",6),%mindTrm("white"),!
	set parseError=1
	zgoto level:continueAfterUserApiFileError
    ;
    ;
dumpError(errString)
    write !,%mindTrm("red")_"WARNING: ",errString
    ;
    quit
    ;
    ;
parseNamespace(obj,namespace,names)
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
    ; check for name duplicates
    if $data(names(namespace)) do  goto parseNamespaceQuit
    . set err=errHeader_"name: "_@obj@("name")_" already exists at this level"
    ;
    ; register the name
    set names(namespace)=""
    ;
    ; quit if levels > 3
    if +$zlength(namespace)-$zlength($translate(namespace,".",""))>3 do  goto parseNamespaceQuit
    . set err=errHeader_"too many namespaces"
    ;
    ; last namespace can only has props or methods
    set hasProperties=$data(@obj@("properties")),hasMethods=$data(@obj@("methods")),hasChildren=$data(@obj@("children"))
    ;
    if +$zlength(namespace)-$zlength($translate(namespace,".",""))=3 do
    . if hasChildren set err=errHeader_"namespace can be maximum 4 levels deep" quit
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
    . set err=$$parseProperty($name(@obj@("properties",iy)),namespace,.names)
    ;
    goto:err'="" parseNamespaceQuit
    ;
    ; methods
    if hasMethods set iy="" for  set iy=$order(@obj@("methods",iy)) quit:iy=""  do  quit:err'=""
    . set err=$$parseMethod($name(@obj@("methods",iy)),namespace,.names)
    ;
    goto:err'="" parseNamespaceQuit
    ;
    ; namespaces
    set exit=0
    if hasChildren set iy="" for  set iy=$order(@obj@("children",iy)) quit:iy=""!(exit)  do
    . ; test for name
    . if $get(@obj@("children",iy,"name"))="" do dumpError(errHeader_", item: "_iy_" has the following error: No name found") set exit=1,err="err" quit
    . ;
    . ; test the name
    . if $$isBoolean(@obj@("children",iy,"name")) do dumpError(errHeader_" name: "_@obj@("children",iy,"name")_" has the following error: boolean or null instead of name") set exit=1,err="err" quit
    . if $$isValidApiName^%mindUtils(@obj@("children",iy,"name"))=0 do dumpError(errHeader_" name: "_@obj@("children",iy,"name")_" has the following error: Invalid chars in name or len<3") set exit=1,err="err" quit
    . ;
    . ; check for name duplicates
    . if $data(names(namespace_"."_@obj@("children",iy,"name"))) do  set exit=1 quit
    . . set err="Namespace: "_namespace_"."_@obj@("children",iy,"name")_" name: "_@obj@("children",iy,"name")_" already exists at this level"
    . ;
    . ; register the name
    . set names(namespace)=""
    . ;
    . set err=$$parseNamespace($name(@obj@("children",iy)),namespace_"."_@obj@("children",iy,"name"),.names)
    . set:err'="" exit=1
    ;
parseNamespaceQuit
    quit err
    ;
    ;
parseProperty(obj,namespace,names)
    new err,errHeader,iz
    ;
    set err="",errHeader="property: "_iy_" in namespace: "_namespace_" "
    ;
    ; verify that the name is there
    if $get(@obj@("name"))="" do  goto parsePropertyQuit
    . set err=errHeader_"has no name"
    ;
    ; test the name
    if $$isBoolean(@obj@("name")) set err=errHeader_" has the following error: boolean or null instead of name" goto parseMethodQuit
    if $$isValidApiName^%mindUtils(@obj@("name"))=0 set err=errHeader_" has the following error: Invalid chars in name or len<3" goto parseMethodQuit
    ;
    set err="",errHeader="property: "_@obj@("name")_" in namespace: "_namespace_" "
    ;
    ; check for name duplicates within this level (properties and methods)
    if $data(names(namespace,@obj@("name"))) do  goto parsePropertyQuit
    . set err=errHeader_"name already used at this level"
    ;
    ; register the name
    set names(namespace,@obj@("name"))=""
    ;
    ; verify it has a datatype
    if $get(@obj@("datatype"))="" do  goto parsePropertyQuit
    . set err=errHeader_"has no datatype set"
    ;
    ; verify that the datatype value is valid
    if $find(%mindParams("uApiPropsDataTypes"),","_@obj@("datatype")_",")=0 do  goto parsePropertyQuit
    . set err=errHeader_"has invalid datatype"
    ;
    ; verify it has a value
    if $get(@obj@("value"))="" do  goto parsePropertyQuit
    . set err=errHeader_"has no value set"
    ;
    ; verify that value matches the datatype
    if @obj@("datatype")="string",$$isNumber^%mindUtils(@obj@("value")) do  goto parsePropertyQuit
    . set err=errHeader_"datatype is string but value is number"
    ;
    ; verify that value matches the datatype
    if @obj@("datatype")="int",$$isNumber^%mindUtils(@obj@("value"))=0 do  goto parsePropertyQuit
    . set err=errHeader_"datatype is int but value is string"
    ;
    ; verify that value matches the datatype
    if @obj@("datatype")="int",$$isNumber^%mindUtils(@obj@("value")),$zfind(@obj@("value"),".") do  goto parsePropertyQuit
    . set err=errHeader_"datatype is int but value is float"
    ;
    ; verify that value matches the datatype
    if @obj@("datatype")="float",$$isNumber^%mindUtils(@obj@("value"))=0 do  goto parsePropertyQuit
    . set err=errHeader_"datatype is float but value is string"
    ;
    ; verify that value matches the datatype
    if @obj@("datatype")="boolean",$$isNumber^%mindUtils(@obj@("value")) do  goto parsePropertyQuit
    . set err=errHeader_"datatype is boolean but value is number"
    ;
    ; verify that value matches the datatype
    if @obj@("datatype")="boolean",@obj@("value")'="false",@obj@("value")'="true" do  goto parsePropertyQuit
    . set err=errHeader_"datatype is boolean but value is not true or false"
    ;
parsePropertyQuit
    quit err
    ;
    ;
parseMethod(obj,namespace,names)
    new err,errHeader,iz
    ;
    set err="",errHeader="method: "_iy_" in namespace: "_namespace_" "
    ;
    ; verify that the name is there
    if $get(@obj@("name"))="" do  goto parseMethodQuit
    . set err=errHeader_"has no name"
    ;
    ; test the name
    if $$isBoolean(@obj@("name")) do dumpError(errHeader_" has the following error: boolean or null instead of name") goto parseMethodQuit
    if $$isValidApiName^%mindUtils(@obj@("name"))=0 do dumpError(errHeader_" has the following error: Invalid chars in name or len<3") goto parseMethodQuit
    ;
    set err="",errHeader="method: "_@obj@("name")_" in namespace: "_namespace_" "
    ;
    ; check for name duplicates within this level (properties and methods)
    if $data(names(namespace,@obj@("name"))) do  goto parseMethodQuit
    . set err=errHeader_"name already used at this level"
    ;
    ; register the name
    set names(namespace,@obj@("name"))=""
    ;
    ; verify that the entrypoint is there
    if $get(@obj@("entryPoint"))="" do  goto parseMethodQuit
    . set err=errHeader_"has no entry point"
    ;
    ; and it has a valid syntax
    if $$isValidEntryPoint^%mindUtils(@obj@("entryPoint"))=0 do  goto parseMethodQuit
    . set err=errHeader_"has an invalid entry point"
    ;
    ; and it is accessible by code
    if $text(@@obj@("entryPoint"))="" do  goto parseMethodQuit
    . set err=errHeader_"has a valid entry point syntax, but code is not reachable"
    ;
    ; verify that the return value is valid
    if $data(@obj@("returns")),$find(%mindParams("uApiDataTypes"),","_@obj@("returns")_",")=0 do  goto parseMethodQuit
    . set err=errHeader_"has invalid return datatype"
    ;
    if $data(@obj@("returns")),@obj@("returns")="varByRef" do  goto parseMethodQuit
    . set err=errHeader_"has an invalid return datatype: varByRef not supported as return"
    ;
    ; now parse parameters
    ; verify that existing node is an array
    if $data(@obj@("parameters")),$$isArray($name(@obj@("parameters")))=0 do  goto parseMethodQuit
    . set err=errHeader_"parameters node exists, but is not an array"
    ;
    set iz="" for  set iz=$order(@obj@("parameters",iz)) quit:iz=""  do
    . set err=$$parseParameter($name(@obj@("parameters",iz)),namespace,@obj@("name"),errHeader,iz,.names)
    ;
    goto:err'="" parseMethodQuit
    ;
    ; ----------------------------
    ; REGISTER METHOD
    ; ----------------------------
    set %mindParams("uApi",file,namespace_"."_@obj@("name"))=@obj@("entryPoint")
    set %mindParams("uApi",file,namespace_"."_@obj@("name"),"returns")=$get(@obj@("returns"))
    merge %mindParams("uApi",file,namespace_"."_@obj@("name"),"parameters")=@obj@("parameters")
    ;
parseMethodQuit
    quit err
    ;
    ;
parseParameter(obj,namespace,function,errHeaderFunction,iz,names)
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
    ; test the name
    if $$isBoolean(@obj@("name")) do  goto parseMethodQuit
    . set err=errHeader_" has the following error: boolean or null instead of name"
    if $$isValidParamName^%mindUtils(@obj@("name"))=0 do  goto parseMethodQuit
    . set err=errHeader_" has the following error: Invalid chars in name or len<3"
    ;
    ; check for param name duplicates within this level
    if $data(names(namespace,function,@obj@("name"))) do  goto parsePropertyQuit
    . set err=errHeader_"name already used at this level"
    ;
    ; verify that the datatype is there
    if $get(@obj@("datatype"))="" do  goto parseParameterQuit
    . set err=errHeader_"has no datatype"
    ;
    ; verify that the datatype is valid
    if $find(%mindParams("uApiDataTypes"),","_@obj@("datatype")_",")=0 do  goto parseParameterQuit
    . set err=errHeader_"has invalid datatype"
    ;
    ; register the name
    set names(namespace,function,@obj@("name"))=""
    ;
parseParameterQuit
    quit err
    ;
    ;
parseVars(obj)
    new err,ix,names,cnt
    ;
    set (err,ix)="",cnt=0
    for  set ix=$order(@obj@(ix)) quit:ix=""!(err'="")  do
    . set varsFound=1
    . if $order(@obj@(ix,""))'="" set err="server.var "_ix_": Can not be an object" quit
    . if $$isNumber^%mindUtils(@obj@(ix)) set err="server.var."_@obj@(ix)_": Can not be a number" quit
    . if $$isValidVarName^%mindUtils(@obj@(ix))=0 set err="server.var."_@obj@(ix)_": Invalid var syntax" quit
    . if $data(names(@obj@(ix))) set err="server.var."_@obj@(ix)_": duplicate name" quit
    . set cnt=cnt+1
    . if cnt>10 set err="A maximum of 10 vars is allowed" quit
    . set names(@obj@(ix))=""
    ;
    quit err
    ;
    ;
isArray(node)
    quit $$isNumber^%mindUtils($order(@node@("")))
    ;
    ;
isNotSo()
    do dumpError("server/code: "_JDOMserver("code")_" is not a valid .so file")
    set exit=1
    ;
    quit
    ;
    ;
isBoolean(str)
    quit:$find(str,$zchar(0)_"true")!($find(str,$zchar(0)_"false"))!($find(str,$zchar(0)_"null")) 1
    ;
    quit 0
    ;
    ;
