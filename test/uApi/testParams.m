testParams0RetStr()
    ;
    quit "This is a string"
    ;
    ;
testParams0RetInt()
    ;
    quit 123456
    ;
    ;
testParams0RetFloat()
    ;
    quit 654.321
    ;
    ;
testParams0RetBooleanTrue()
    ;
    quit 1
    ;
    ;
testParams0RetBooleanFalse()
    ;
    quit 0
    ;
    ;
testParams0RetObject()
    new buffer
    ;
    set buffer("field1")=2321
    set buffer("array1",0)="field0"
    set buffer("array1",1)="field1"
    set buffer("array1",2)="field2"
    ;
    quit *buffer
    ;
    ;
testParams0Ret0() ;
    ;
    quit
    ;
    ;
testParams0ErrSimple()
    set %res=$$buildErrorString^%mindRESP3("this is a simple error")
    ;
    quit
    ;
    ;
testParams0ErrBlob()
    set %res=$$buildErrorBlob^%mindRESP3("This is a blob error\nwith more\nextended text\nand multiple lines")
    ;
    quit
    ;
    ;
testParams1(param1)
    new buffer
    ;
    set buffer("param1")=param1
    ;
    quit *buffer
    ;
    ;
testParams2(param1,param2)
    new buffer
    ;
    set buffer("param1")=param1
    set buffer("param2")=param2
    ;
    quit *buffer
    ;
    ;
testParams3(param1,param2,param3)
    new buffer
    ;
    set buffer("param1")=param1
    set buffer("param2")=param2
    set buffer("param3")=param3
    ;
    quit *buffer
    ;
    ;
testParams4(param1,param2,param3,param4)
    new buffer
    ;
    set buffer("param1")=param1
    set buffer("param2")=param2
    set buffer("param3")=param3
    set buffer("param4")=$$buildJsonBoolean^%mindRESP3(param4)
    ;
    quit *buffer
    ;
    ;
testParams5(param1,param2,param3,param4,param5)
    new buffer
    ;
    set buffer("param1")=param1
    set buffer("param2")=param2
    set buffer("param3")=param3
    set buffer("param4")=$$buildJsonBoolean^%mindRESP3(param4)
    set buffer("param5")=$$buildJsonBoolean^%mindRESP3(param5)
    ;
    quit *buffer
    ;
    ;
testParams6(param1,param2,param3,param4,param5,param6)
    new buffer
    ;
    set buffer("param1")=param1
    set buffer("param2")=param2
    set buffer("param3")=param3
    set buffer("param4")=$$buildJsonBoolean^%mindRESP3(param4)
    set buffer("param5")=$$buildJsonBoolean^%mindRESP3(param5)
    merge buffer("param6")=param6
    ;
    quit *buffer
    ;
    ;
testMethod0()
    ;
    quit
    ;
    ;
testMethod1(myVal)
    ;
    quit
    ;
    ;






