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
testParams0RetBooleanT
    set %res=$$buildBoolean^%mindRESP3(1)
    ;
    quit
    ;
    ;
testParams0RetBooleanF
    set %res=$$buildBoolean^%mindRESP3(0)
    ;
    quit
    ;
    ;
testParams0RetObject
    set %res=$$buildObject^%mindRESP3("{""field1"":123}")
    ;
    quit
    ;
    ;
testParams0Ret0
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

    quit
    ;
    ;
testParams2

    quit
    ;
    ;
testParams3

    quit
    ;
    ;
testParams4

    quit
    ;
    ;
testParams5

    quit
    ;
    ;
testParams6

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







testReturnString

    quit
    ;
    ;
testReturnInt

    quit
    ;
    ;
testReturnFloat

    quit
    ;
    ;
testReturnBoolean

    quit
    ;
    ;
testReturnObject

    quit
    ;
    ;

