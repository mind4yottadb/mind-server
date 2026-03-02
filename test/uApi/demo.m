bhasTest(a,b)
    new buffer
    ;
    set buffer=""
    if $zlength(b)<3 do returnErrorString^%mindRESP3("Param b must be 3 chars or longer...") quit *buffer

    merge buffer=@a
    set buffer("newProp","newnew")=b
    set buffer("newProp","newnew2")=b_" hey"
    ;
    quit *buffer
    ;