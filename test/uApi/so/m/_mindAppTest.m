soTest()
    new a
    ;
    set a=1
    ;
    quit a
    ;
    ;
onInit()
    set ^%mindSo=1
    ;
    quit
    ;
    ;
onTerminate()
    set ^%mindSo=0
    ;
    quit
    ;
    ;
onError()
    set ^%mindSo=2
    ;
    quit
    ;
    ;
