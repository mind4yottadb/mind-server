testParams0RetStr
    do returnBlob^%mindRESP3("This is a string")
    ;
    quit
    ;
    ;
testParams0RetInt
    do returnInt^%mindRESP3(123456)
    ;
    quit
    ;
    ;
testParams0RetFloat
    do returnFloat^%mindRESP3(654.321)
    ;
    quit
    ;
    ;
testParams0RetBooleanTrue
    do returnBoolean^%mindRESP3(1)
    ;
    quit
    ;
    ;
testParams0RetBooleanFalse
    do returnBoolean^%mindRESP3(0)
    ;
    quit
    ;
    ;
testParams0RetNull
    do returnNull^%mindRESP3()
    ;
    quit
    ;
    ;
testParams0RetObject
    new buffer
    ;
    set buffer("field1")=2321
    set buffer("array1",0)="field0"
    set buffer("array1",1)="field1"
    set buffer("array1",2)="field2"
    do returnObject^%mindRESP3(.buffer)
    ;
    quit
    ;
    ;
testParams0Ret0 ;
    do returnSimpleString^%mindRESP3("ok")
    ;
    quit
    ;
    ;
testParams0ErrSimple
    do returnErrorString^%mindRESP3("this is a simple error")
    ;
    quit
    ;
    ;
testParams0ErrBlob
    do returnErrorBlob^%mindRESP3("This is a blob error\nwith more\nextended text\nand multiple lines")
    ;
    quit
    ;
    ;
testParams1
    new buffer
    ;
    set buffer("param1")=%args("paramStr")
    do returnObject^%mindRESP3(.buffer)
    ;
    quit
    ;
    ;
testParams2
    new buffer
    ;
    set buffer("param1")=%args("paramStr")
    set buffer("param2")=%args("paramInt")
    do returnObject^%mindRESP3(.buffer)
    ;
    quit
    ;
    ;
testParams3
    new buffer
    ;
    set buffer("param1")=%args("paramStr")
    set buffer("param2")=%args("paramInt")
    set buffer("param3")=%args("paramFloat")
    do returnObject^%mindRESP3(.buffer)
    ;
    quit
    ;
    ;
testParams4
    new buffer
    ;
    set buffer("param1")=%args("paramStr")
    set buffer("param2")=%args("paramInt")
    set buffer("param3")=%args("paramFloat")
    set buffer("param4")=$$buildJsonBoolean^%mindRESP3(%args("paramBoolean"))
    do returnObject^%mindRESP3(.buffer)
    ;
    quit
    ;
    ;
testParams5
    new buffer
    ;
    set buffer("param1")=%args("paramStr")
    set buffer("param2")=%args("paramInt")
    set buffer("param3")=%args("paramFloat")
    set buffer("param4")=$$buildJsonBoolean^%mindRESP3(%args("paramBoolean1"))
    set buffer("param5")=$$buildJsonBoolean^%mindRESP3(%args("paramBoolean2"))
    do returnObject^%mindRESP3(.buffer)
    ;
    quit
    ;
    ;
testParams6
    new buffer
    ;
    set buffer("param1")=%args("paramStr")
    set buffer("param2")=%args("paramInt")
    set buffer("param3")=%args("paramFloat")
    set buffer("param4")=$$buildJsonBoolean^%mindRESP3(%args("paramBoolean1"))
    set buffer("param5")=$$buildJsonBoolean^%mindRESP3(%args("paramBoolean2"))
    merge buffer("param6")=%args("paramObject")
    do returnObject^%mindRESP3(.buffer)
    ;
    quit
    ;
    ;
testParams7

    quit
    ;
    ;
testParams8

    quit
    ;
    ;
testParams9

    quit
    ;
    ;
testParams10

    quit
    ;
    ;







