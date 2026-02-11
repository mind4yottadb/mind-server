testParams0RetStr
    set %res=$$buildBlob^%mindRESP3("This is a string")
    ;
    quit
    ;
    ;
testParams0RetInt
    set %res=$$buildInt^%mindRESP3(123456)
    ;
    quit
    ;
    ;
testParams0RetFloat
    set %res=$$buildFloat^%mindRESP3(654.321)
    ;
    quit
    ;
    ;
testParams0RetBooleanTrue
    set %res=$$buildBoolean^%mindRESP3(1)
    ;
    quit
    ;
    ;
testParams0RetBooleanFalse
    set %res=$$buildBoolean^%mindRESP3(0)
    ;
    quit
    ;
    ;
testParams0RetNull
    set %res=$$buildNull^%mindRESP3()
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
    set %res=$$buildObject^%mindRESP3(.buffer)
    ;
    quit
    ;
    ;
testParams0Ret0 ;
    set %res=$$buildString^%mindRESP3("ok")
    ;
    quit
    ;
    ;
testParams0ErrSimple
    set %res=$$buildErrorString^%mindRESP3("this is a simple error")
    ;
    quit
    ;
    ;
testParams0ErrBlob
    set %res=$$buildErrorBlob^%mindRESP3("This is a blob error\nwith more\nextended text\nand multiple lines")
    ;
    quit
    ;
    ;
testParams1
    new buffer
    ;
    set buffer("param1")=%params("paramStr")
    set %res=$$buildObject^%mindRESP3(.buffer)
    ;
    quit
    ;
    ;
testParams2
    new buffer
    ;
    set buffer("param1")=%params("paramStr")
    set buffer("param2")=%params("paramInt")
    set %res=$$buildObject^%mindRESP3(.buffer)
    ;
    quit
    ;
    ;
testParams3
    new buffer
    ;
    set buffer("param1")=%params("paramStr")
    set buffer("param2")=%params("paramInt")
    set buffer("param3")=%params("paramFloat")
    set %res=$$buildObject^%mindRESP3(.buffer)
    ;
    quit
    ;
    ;
testParams4
    new buffer
    ;
    set buffer("param1")=%params("paramStr")
    set buffer("param2")=%params("paramInt")
    set buffer("param3")=%params("paramFloat")
    set buffer("param4")=$$valToBoolean^%mindRESP3(%params("paramBoolean"))
    set %res=$$buildObject^%mindRESP3(.buffer)
    ;
    quit
    ;
    ;
testParams5
    new buffer
    ;
    set buffer("param1")=%params("paramStr")
    set buffer("param2")=%params("paramInt")
    set buffer("param3")=%params("paramFloat")
    set buffer("param4")=$$valToBoolean^%mindRESP3(%params("paramBoolean1"))
    set buffer("param5")=$$valToBoolean^%mindRESP3(%params("paramBoolean2"))
    set %res=$$buildObject^%mindRESP3(.buffer)
    ;
    quit
    ;
    ;
testParams6
    new buffer
    ;
    set buffer("param1")=%params("paramStr")
    set buffer("param2")=%params("paramInt")
    set buffer("param3")=%params("paramFloat")
    set buffer("param4")=$$valToBoolean^%mindRESP3(%params("paramBoolean1"))
    set buffer("param5")=$$valToBoolean^%mindRESP3(%params("paramBoolean2"))
    merge buffer("param6")=%params("paramObject")
    set %res=$$buildObject^%mindRESP3(.buffer)
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







