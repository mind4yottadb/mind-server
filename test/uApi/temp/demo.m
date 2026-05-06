bhasTest(a,b)
    new buffer
    ;
    merge buffer=@a
    set buffer("newProp","newnew")=b
    set buffer("newProp","newnew2")=b_" hey"
    ;
    quit *buffer
    ;
    ;
test2(field1,field2)
    if $zlength(field1)<3 do returnErrorString^%mindRESP3("Param str1 must be 3 chars or longer...") quit ""
    ;
    quit field1_" "_field2

