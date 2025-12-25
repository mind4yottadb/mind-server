;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;								;
; Copyright (c) 2024-2025 YottaDB LLC and/or its subsidiaries.	;
; All rights reserved.						;
;								;
;	This source code contains the intellectual property	;
;	of its copyright holder(s), and is made available	;
;	under a license.  If you do not know the terms of	;
;	the license, please stop and do not read further.	;
;								;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;
%ydbxiderTestApiHash
	; Requires M-Unit
	;
test if $text(^%ut)="" quit
	do en^%ut($text(+0),3)
	;
	write !
	;
	quit
	;
STARTUP
	do STARTUP^%ydbxiderTestUtils
	;
	quit
	;
	;
SHUTDOWN
	do SHUTDOWN^%ydbxiderTestUtils
	;
	quit
	;
	;
HSET0	;@test ------------------
	quit
	;
	;
HSET1	;@test ------------------API <hash> HSET
	quit
	;
	;
HSET2	;@test ------------------
	quit
	;
	;
T12999	;@test with no parameters
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	;execute the call
	set ret=$$HSET^xider
	;
	; verify response
	do eq^%ut(ret,NoKey,"no key was supplied")
	;
	quit
	;
	;
T13000	;@test with an empty key
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	set xider(2)=""
	;
	;execute the call
	set ret=$$HSET^xider
	;
	; verify response
	do eq^%ut(ret,NoKey,"empty key was supplied")
	;
	quit
	;
	;
T13001	;@test with no fields
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	; set the key only
	set xider(2)="hset key"
	;
	;execute the call
	set ret=$$HSET^xider
	;
	; verify response
	do eq^%ut(ret,NoField,"no fields")
	;
	quit
	;
	;
T13002	;@test with an empty field
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	; set the key only
	set xider(2)="hset key"
	set xider(3)=""
	;
	;execute the call
	set ret=$$HSET^xider
	;
	; verify response
	do eq^%ut(ret,NoField,"an empty field")
	;
	quit
	;
	;
T13003	;@test with data with no field
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	; set the key
	set xider(2)="hset key"
	;
	; set the data
	set xider(3)="myfield1"
	set xider(4)="myvalue1"
	set xider(6)="myvalue2"
	;
	;execute the call
	set ret=$$HSET^xider
	;
	; verify response
	do eq^%ut(ret,NoField,"some data has no field")
	;
	quit
	;
	;
T13004	;@test with field + key > xiderKeyFieldMaxLength
	new lField,lKey,ix,ret
	;
	; init the API
	do init^xider
	kill xider,xiderRet,xiderStatus
	;
	; build a long key
	set (lField,lKey)=""
	set $piece(lField,"x",xiderKeyFieldMaxLength+51)=""
	set $piece(lKey,"x",101)=""
	;
	; set the key
	set xider(2)=lKey
	;
	; set the data
	set xider(3)="field1"
	set xider(4)="myvalue1"
	set xider(5)=lField
	set xider(6)="myvalue2"
	;l
	;execute the call
	set ret=$$HSET^xider
	;
	; verify response
	do eq^%ut(ret,KeyFieldTooLong,"some field / key combination is too long")
	;
	quit
	;
	;
T13005	;@test with data with no data
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	; set the key
	set xider(2)="hset key"
	;
	; set the data
	set xider(3)="myfield1"
	set xider(4)="myvalue1"
	set xider(5)="myfield2"
	;
	;execute the call
	set ret=$$HSET^xider
	;
	; verify response
	do eq^%ut(ret,NoValue,"some data has no value")
	;
	quit
	;
	;
T13006	;@test with data with empty data
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	; set the key
	set xider(2)="hset key"
	;
	; set the data
	set xider(3)="myfield1"
	set xider(4)="myvalue1"
	set xider(5)="myfield2"
	set xider(6)=""
	;
	;execute the call
	set ret=$$HSET^xider
	;
	; verify response
	do eq^%ut(ret,Integer,"integer return type")
	do eq^%ut(xiderRet,2,"2 records created")
	;
	quit
	;
	;
T13007	;@test with key as string data-type
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="strkey"
	set xider(3)="strvalue"
	set ret=$$SET^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	; set the key
	set xider(2)="strkey"
	;
	; set the data
	set xider(3)="myfield1"
	set xider(4)="myvalue1"
	;
	;execute the call
	set ret=$$HSET^xider
	;
	; verify response
	do eq^%ut(ret,WrongDataType,"strkey exists, but not hash data-type")
	;
	quit
	;
	;
T13008	;@test with non-existing key
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	; set the key
	set xider(2)="hsetkey"
	;
	; set the data
	set xider(3)="myfield1"
	set xider(4)="myvalue1"
	set xider(5)="myfield2"
	set xider(6)="myvalue2"
	;
	;execute the call
	set ret=$$HSET^xider
	;
	; verify response
	do eq^%ut(ret,Integer,"integer return type")
	do eq^%ut(xiderRet,2,"2 records created")
	;
	quit
	;
	;
T13009	;@test with existing key and 1 existing record
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	; set the key
	set xider(2)="hsetkey"
	;
	; set the data
	set xider(3)="myfield1"
	set xider(4)="myvalue1"
	set xider(5)="myfield3"
	set xider(6)="myvalue3"
	;
	;execute the call
	set ret=$$HSET^xider
	;
	; verify response
	do eq^%ut(ret,Integer,"integer return type")
	do eq^%ut(xiderRet,1,"1 records created")
	;
	quit
	;
	;
T13010	;@test with existing key and existing records
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	; set the key
	set xider(2)="hsetkey"
	;
	; set the data
	set xider(3)="myfield1"
	set xider(4)="myvalue1"
	set xider(5)="myfield3"
	set xider(6)="myvalue3"
	;
	;execute the call
	set ret=$$HSET^xider
	;
	; verify response
	do eq^%ut(ret,Integer,"integer return type")
	do eq^%ut(xiderRet,0,"0 records created")
	;
	quit
	;
	;
T13011	;@test as procedure
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	;execute the call
	do HSET^xider
	;
	; verify response
	do eq^%ut($data(xiderStatus),1,"status got populated")
	;
	quit
	;
	;
HSETNX0	;@test ------------------
	quit
	;
	;
HSETNX1	;@test --------------API <hash> HSETNX
	quit
	;
	;
HSETNX2	;@test ------------------
	quit
	;
	;
T13024	;@test with no parameters
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	;execute the call
	set ret=$$HSETNX^xider
	;
	; verify response
	do eq^%ut(ret,NoKey,"no key was supplied")
	;
	quit
	;
	;
T13025	;@test with an empty key
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	set xider(2)=""
	;
	;execute the call
	set ret=$$HSETNX^xider
	;
	; verify response
	do eq^%ut(ret,NoKey,"empty key was supplied")
	;
	quit
	;
	;
T13026	;@test with no field
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="setnxkey"
	;
	;execute the call
	set ret=$$HSETNX^xider
	;
	; verify response
	do eq^%ut(ret,NoField,"no field")
	;
	quit
	;
	;
T13027	;@test with an empty field
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="setnxkey"
	set xider(3)=""
	;
	;execute the call
	set ret=$$HSETNX^xider
	;
	; verify response
	do eq^%ut(ret,NoField,"an empty field")
	;
	quit
	;
	;
T13028	;@test with field / key > 900 chars
	new lField,lKey,ix,ret
	;
	; init the API
	do init^xider
	kill xider,xiderRet,xiderStatus
	;
	; build a long key
	set (lKey,lField)=""
	set $piece(lKey,"x",xiderKeyFieldMaxLength+2)=""
	set $piece(lField,"x",51)=""
	;
	; set the data
	set xider(2)=lKey
	set xider(3)=lField
	;
	;execute the call
	set ret=$$HSETNX^xider
	;
	; verify response
	do eq^%ut(ret,KeyFieldTooLong,"field + key length > 900")
	;
	quit
	;
	;
T13029	;@test with no value
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="setnxkey"
	set xider(3)="setnxfield"
	;
	;execute the call
	set ret=$$HSETNX^xider
	;
	; verify response
	do eq^%ut(ret,NoValue,"no value")
	;
	quit
	;
	;
T13030	;@test with an empty value
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="setnxkey"
	set xider(3)="setnxfield"
	set xider(4)=""
	;
	;execute the call
	set ret=$$HSETNX^xider
	;
	; verify response
	do eq^%ut(ret,Integer,"integer return type")
	do eq^%ut(xiderRet,1,"key not found, empty value")
	;
	quit
	;
	;
T13031	;@test with no existing key
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="hsetnxkey"
	set xider(3)="hsetnxfield"
	set xider(4)="hsetnxvalue"
	;
	;execute the call
	set ret=$$HSETNX^xider
	;
	; verify response
	do eq^%ut(ret,Integer,"integer return type")
	do eq^%ut(xiderRet,1,"set the key")
	;
	quit
	;
	;
T13032	;@test with existing key, but <string> data-type
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="stringkey"
	set xider(3)="stringvalue"
	;
	set ret=$$SET^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="stringkey"
	set xider(3)="setnxfield"
	set xider(4)="setnxvalue"
	;
	;execute the call
	set ret=$$HSETNX^xider
	;
	; verify response
	do eq^%ut(ret,WrongDataType,"key exists, but not hash data-type")
	;
	quit
	;
	;
T13033	;@test with existing key and existing field
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="hashkey"
	set xider(3)="hashfield1"
	set xider(4)="hashvalue1"
	;
	set ret=$$HSET^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="hashkey"
	set xider(3)="hashfield1"
	set xider(4)="setnxvalue"
	;
	;execute the call
	set ret=$$HSETNX^xider
	;
	; verify response
	do eq^%ut(ret,Integer,"integer return type")
	do eq^%ut(xiderRet,0,"field already exists")
	;
	quit
	;
	;
T13034	;@test with existing key, but no field
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="hashkey"
	set xider(3)="hashfield1"
	set xider(4)="hashvalue1"
	;
	set ret=$$HSET^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="hashkey"
	set xider(3)="hashfield2"
	set xider(4)="setnxvalue"
	;
	;execute the call
	set ret=$$HSETNX^xider
	;
	; verify response
	do eq^%ut(ret,Integer,"integer return type")
	do eq^%ut(xiderRet,1,"key found, no field")
	;
	quit
	;
	;
T13035	;@test as procedure
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	;execute the call
	do HSETNX^xider
	;
	; verify response
	do eq^%ut($data(xiderStatus),1,"status got populated")
	;
	quit
	;
	;
HGET0	;@test ------------------
	quit
	;
	;
HGET1	;@test --------------API <hash> HGET
	quit
	;
	;
HGET2	;@test ------------------
	quit
	;
	;
T13048	;@test with no parameters
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	;execute the call
	set ret=$$HGET^xider
	;
	; verify response
	do eq^%ut(ret,NoKey,"no key was supplied")
	;
	quit
	;
	;
T13049	;@test with an empty key
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	set xider(2)=""
	;
	;execute the call
	set ret=$$HGET^xider
	;
	; verify response
	do eq^%ut(ret,NoKey,"empty key was supplied")
	;
	quit
	;
	;
T13050	;@test with field / key > 900 chars
	new lField,lKey,ix,ret
	;
	; init the API
	do init^xider
	kill xider,xiderRet,xiderStatus
	;
	; build a long key
	set (lKey,lField)=""
	set $piece(lKey,"x",xiderKeyFieldMaxLength+2)=""
	set $piece(lField,"x",51)=""
	;
	; set the data
	set xider(2)=lKey
	set xider(3)=lField
	;
	;execute the call
	set ret=$$HGET^xider
	;
	; verify response
	do eq^%ut(ret,KeyFieldTooLong,"field + key length > 900")
	;
	quit
	;
	;
T13051	;@test with no field
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="setnxkey"
	;
	;execute the call
	set ret=$$HGET^xider
	;
	; verify response
	do eq^%ut(ret,NoField,"no field")
	;
	quit
	;
	;
T13052	;@test with an empty field
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="setnxkey"
	set xider(3)=""
	;
	;execute the call
	set ret=$$HGET^xider
	;
	; verify response
	do eq^%ut(ret,NoField,"an empty field")
	;
	quit
	;
	;
T13053	;@test with field > xiderKeyFieldMaxLength
	new lKey,ix,ret
	;
	; init the API
	do init^xider
	kill xider,xiderRet,xiderStatus
	;
	; build a long key
	set lKey=""
	set $piece(lKey,"x",xiderKeyFieldMaxLength+2)=""
	;
	; set the data
	set xider(2)="setnxkey"
	set xider(3)=lKey
	;
	;execute the call
	set ret=$$HGET^xider
	;
	; verify response
	do eq^%ut(ret,KeyFieldTooLong,"field length > xiderKeyFieldMaxLength")
	;
	quit
	;
	;
T13054	;@test with no existing key
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="setnx2key"
	set xider(3)="setnxfield"
	set xider(4)="setnxvalue"
	;
	;execute the call
	set ret=$$HGET^xider
	;
	; verify response
	do eq^%ut(ret,String,"key not found")
	do eq^%ut($data(xiderRet),0,"data is not present")
	;
	quit
	;
	;
T13055	;@test with existing key, but <string> data-type
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="stringkey"
	set xider(3)="stringvalue"
	;
	set ret=$$SET^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="stringkey"
	set xider(3)="setnxfield"
	;
	;execute the call
	set ret=$$HGET^xider
	;
	; verify response
	do eq^%ut(ret,WrongDataType,"key exists, but not hash data-type")
	;
	quit
	;
	;
T13056	;@test with non existing field
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="stringkey2"
	set xider(3)="stringfield"
	set xider(4)="stringvalue"
	;
	set ret=$$HSET^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="stringkey2"
	set xider(3)="setnxfield"
	;
	;execute the call
	set ret=$$HGET^xider
	;
	; verify response
	do eq^%ut(ret,String,"field doesn't exist")
	do eq^%ut($data(xiderRet),0,"data is not present")
	;
	quit
	;
	;
T13057	;@test with existing field
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="stringkey2"
	set xider(3)="stringfield"
	set xider(4)="stringvalue"
	;
	set ret=$$HSET^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="stringkey2"
	set xider(3)="stringfield"
	;
	;execute the call
	set ret=$$HGET^xider
	;
	; verify response
	do eq^%ut(ret,String,"data is in xiderRet")
	;
	quit
	;
	;
T13058	;@test as procedure
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	;execute the call
	do HGET^xider
	;
	; verify response
	do eq^%ut($data(xiderStatus),1,"status got populated")
	;
	quit
	;
	;
HDEL0	;@test ------------------
	quit
	;
	;
HDEL1	;@test --------------API <hash> HDEL
	quit
	;
	;
HDEL2	;@test ------------------
	quit
	;
	;
T13074	;@test with no parameters
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	;execute the call
	set ret=$$HDEL^xider
	;
	; verify response
	do eq^%ut(ret,NoKey,"no key was supplied")
	;
	quit
	;
	;
T13075	;@test with an empty key
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	set xider(2)=""
	;
	;execute the call
	set ret=$$HDEL^xider
	;
	; verify response
	do eq^%ut(ret,NoKey,"empty key was supplied")
	;
	quit
	;
	;
T13076	;@test with no fields
	new ret
	;
	; init the API
	do init^xider
	kill xider,xiderRet,xiderStatus
	;
	; set the key only
	set xider(2)="hashnofields"
	;
	;execute the call
	set ret=$$HDEL^xider
	;
	; verify response
	do eq^%ut(ret,NoField,"no fields")
	;
	quit
	;
	;
T13077	;@test with an empty field
	new ret
	;
	; init the API
	do init^xider
	kill xider,xiderRet,xiderStatus
	;
	; set the key only
	set xider(2)="hashnofields"
	set xider(3)=""
	;
	;execute the call
	set ret=$$HDEL^xider
	;
	; verify response
	do eq^%ut(ret,NoField,"an empty field")
	;
	quit
	;
	;
T13078	;@test with field > xiderKeyFieldMaxLength
	new lField,lKey,ix,ret
	;
	; init the API
	do init^xider
	kill xider,xiderRet,xiderStatus
	;
	; build a long key
	set (lField,lKey)=""
	set $piece(lField,"x",xiderKeyFieldMaxLength+2)=""
	set $piece(lKey,"x",51)=""
	;
	; set the fields
	set xider(2)=lKey
	set xider(3)=lField
	;
	;execute the call
	set ret=$$HDEL^xider
	;
	; verify response
	do eq^%ut(ret,KeyFieldTooLong,"field too long")
	;
	quit
	;
	;
T13079	;@test with bad key
	new ret
	;
	; init the API
	do init^xider
	kill xider,xiderRet,xiderStatus
	;
	; set the key only
	set xider(2)="hashnofields"
	set xider(3)="myfield"
	;
	;execute the call
	set ret=$$HDEL^xider
	;
	; verify response
	do eq^%ut(ret,Integer,"integer return type")
	do eq^%ut(xiderRet,0,"key not found")
	;
	quit
	;
	;
T13080	;@test with <string> key
	new ret
	;
	; init the API
	do init^xider
	;
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="mystringkey2"
	set xider(3)="mystrvalue"
	do SET^xider
	;
	; set the data
	set xider(2)="mystringkey2"
	set xider(3)="myfield"
	;
	;execute the call
	set ret=$$HDEL^xider
	;
	; verify response
	do eq^%ut(ret,WrongDataType,"key exists, but not hash data-type")
	;
	quit
	;
	;
T13081	;@test with 3 fields, delete only 2
	new ret
	;
	; init the API
	do init^xider
	;
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="T13081"
	set xider(3)="T13081-1"
	set xider(4)="T13081-1-d"
	set xider(5)="T13081-2"
	set xider(6)="T13081-2-d"
	set xider(7)="T13081-3"
	set xider(8)="T13081-3-d"
	;
	do HSET^xider
	;
	kill xider,xiderRet,xiderStatus
	;
	; set the data
	set xider(2)="T13081"
	set xider(3)="T13081-1"
	set xider(4)="T13081-2"
	;
	;execute the call
	set ret=$$HDEL^xider
	;
	; verify response
	do eq^%ut(ret,Integer,"integer return type")
	do eq^%ut(xiderRet,2,"2 records deleted")
	do eq^%ut(^%ydbxiderK("T13081"),1,"1 record left")
	;
	quit
	;
	;
T13082	;@test with 3 fields, delete last record, skip non existing
	new ret
	;
	; init the API
	do init^xider
	;
	kill xider,xiderRet,xiderStatus
	;
	; set the data
	set xider(2)="T13081"
	set xider(3)="T13081-1"
	set xider(4)="T13081-2"
	set xider(5)="T13081-3"
	;
	;execute the call
	set ret=$$HDEL^xider
	;
	; verify response
	do eq^%ut(ret,Integer,"integer return type")
	do eq^%ut(xiderRet,1,"1 records deleted")
	do eq^%ut($data(^%ydbxiderK("T13081")),0,"got deleted")
	;
	quit
	;
	;
T13083	;@test as procedure
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	;execute the call
	do HDEL^xider
	;
	; verify response
	do eq^%ut($data(xiderStatus),1,"status got populated")
	;
	quit
	;
	;
HLEN0	;@test ------------------
	quit
	;
	;
HLEN1	;@test --------------API <hash> HLEN
	quit
	;
	;
HLEN2	;@test ------------------
	quit
	;
	;
T13099	;@test with no parameters
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	;execute the call
	set ret=$$HLEN^xider
	;
	; verify response
	do eq^%ut(ret,NoKey,"no key was supplied")
	;
	quit
	;
	;
T13100	;@test with an empty key
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	set xider(2)=""
	;
	;execute the call
	set ret=$$HLEN^xider
	;
	; verify response
	do eq^%ut(ret,NoKey,"empty key was supplied")
	;
	quit
	;
	;
T13101	;@test with key > xiderKeyFieldMaxLength
	new lKey,ix,ret
	;
	; init the API
	do init^xider
	kill xider,xiderRet,xiderStatus
	;
	; build a long key
	set lKey=""
	set $piece(lKey,"x",xiderKeyFieldMaxLength+2)=""
	;
	; set the key only
	set xider(2)=lKey
	;
	;execute the call
	set ret=$$HLEN^xider
	;
	; verify response
	do eq^%ut(ret,KeyTooLong,"key length > xiderKeyFieldMaxLength")
	;
	quit
	;
	;
T13102	;@test with bad key
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="nonexisthlen"
	;execute the call
	set ret=$$HLEN^xider
	;
	; verify response
	do eq^%ut(ret,Integer,"integer return type")
	do eq^%ut(xiderRet,0,"key not found")
	;
	quit
	;
	;
T13103	;@test with key as string
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="mystringkey2"
	;
	;execute the call
	set ret=$$HLEN^xider
	;
	; verify response
	do eq^%ut(ret,WrongDataType,"key exists, but not hash data-type")
	;
	quit
	;
	;
T13104	;@test with 3 fields
	new ret
	;
	; init the API
	do init^xider
	;
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="T13081"
	set xider(3)="T13081-1"
	set xider(4)="T13081-1-d"
	set xider(5)="T13081-2"
	set xider(6)="T13081-2-d"
	set xider(7)="T13081-3"
	set xider(8)="T13081-3-d"
	;
	do HSET^xider
	;
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="T13081"
	;
	;execute the call
	set ret=$$HLEN^xider
	;

	; verify response
	do eq^%ut(ret,Integer,"integer return type")
	do eq^%ut(xiderRet,3,"3 records found")
	;
	quit
	;
	;
T13105	;@test as procedure
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	;execute the call
	do HLEN^xider
	;
	; verify response
	do eq^%ut($data(xiderStatus),1,"status got populated")
	;
	quit
	;
	;
HSTRLEN0	;@test ------------------
	quit
	;
	;
HSTRLEN1	;@test ------------API <hash> HSTRLEN
	quit
	;
	;
HSTRLEN2	;@test ------------------
	quit
	;
	;
T13124	;@test with no parameters
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	;execute the call
	set ret=$$HSTRLEN^xider
	;
	; verify response
	do eq^%ut(ret,NoKey,"no key was supplied")
	;
	quit
	;
	;
T13125	;@test with an empty key
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	set xider(2)=""
	;
	;execute the call
	set ret=$$HSTRLEN^xider
	;
	; verify response
	do eq^%ut(ret,NoKey,"empty key was supplied")
	;
	quit
	;
	;
T13126	;@test with no field
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="setnxkey"
	;
	;execute the call
	set ret=$$HSTRLEN^xider
	;
	; verify response
	do eq^%ut(ret,NoField,"no field")
	;
	quit
	;
	;
T13127	;@test with an empty field
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="setnxkey"
	set xider(3)=""
	;
	;execute the call
	set ret=$$HSTRLEN^xider
	;
	; verify response
	do eq^%ut(ret,NoField,"an empty field")
	;
	quit
	;
	;
T13128	;@test with key / field > xiderKeyFieldMaxLength
	new lKey,lField,ix,ret
	;
	; init the API
	do init^xider
	kill xider,xiderRet,xiderStatus
	;
	; build a long key
	set (lKey,lField)=""
	set $piece(lKey,"x",xiderKeyFieldMaxLength+2)=""
	set $piece(lField,"x",51)=""
	;
	; set the data
	set xider(2)=lKey
	set xider(3)=lField
	;
	;execute the call
	set ret=$$HSTRLEN^xider
	;
	; verify response
	do eq^%ut(ret,KeyFieldTooLong,"field length > xiderKeyFieldMaxLength")
	;
	quit
	;
	;
T13129	;@test with no existing key
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="setnx2key"
	set xider(3)="setnxfield"
	;
	;execute the call
	set ret=$$HSTRLEN^xider
	;
	; verify response
	do eq^%ut(ret,Integer,"integer return type")
	do eq^%ut(xiderRet,0,"key not found")
	;
	quit
	;
	;
T13130	;@test with existing key, but <string> data-type
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="stringkey"
	set xider(3)="stringvalue"
	;
	set ret=$$SET^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="stringkey"
	set xider(3)="setnxfield"
	;
	;execute the call
	set ret=$$HSTRLEN^xider
	;
	; verify response
	do eq^%ut(ret,WrongDataType,"key exists, but not hash data-type")
	;
	quit
	;
	;
T13131	;@test with non existing field
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="stringkey2"
	set xider(3)="stringfield"
	set xider(4)="stringvalue"
	;
	set ret=$$HSET^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="stringkey2"
	set xider(3)="setnxfield"
	;
	;execute the call
	set ret=$$HSTRLEN^xider
	;
	; verify response
	do eq^%ut(ret,Integer,"integer return type")
	do eq^%ut(xiderRet,0,"field doesn't exist")
	;
	quit
	;
	;
T13132	;@test with existing field
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="stringkey2"
	set xider(3)="stringfield"
	set xider(4)="stringvalue"
	;
	set ret=$$HSET^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="stringkey2"
	set xider(3)="stringfield"
	;
	;execute the call
	set ret=$$HSTRLEN^xider
	;
	; verify response
	do eq^%ut(ret,Integer,"integer return type")
	do eq^%ut(xiderRet,11,"data is in xiderRet")
	;
	quit
	;
	;
T13133	;@test as procedure
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	;execute the call
	do HSTRLEN^xider
	;
	; verify response
	do eq^%ut($data(xiderStatus),1,"status got populated")
	;
	quit
	;
	;
HKEYS0	;@test ------------------
	quit
	;
	;
HKEYS1	;@test ------------API <hash> HKEYS
	quit
	;
	;
HKEYS2	;@test ------------------
	quit
	;
	;
T13149	;@test with no parameters
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	;execute the call
	set ret=$$HKEYS^xider
	;
	; verify response
	do eq^%ut(ret,NoKey,"no key was supplied")
	;
	quit
	;
	;
T13150	;@test with an empty key
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	set xider(2)=""
	;
	;execute the call
	set ret=$$HKEYS^xider
	;
	; verify response
	do eq^%ut(ret,NoKey,"empty key was supplied")
	;
	quit
	;
	;
T13151	;@test with key > xiderKeyFieldMaxLength
	new lKey,ix,ret
	;
	; init the API
	do init^xider
	kill xider,xiderRet,xiderStatus
	;
	; build a long key
	set lKey=""
	set $piece(lKey,"x",xiderKeyFieldMaxLength+2)=""
	;
	; set the key only
	set xider(2)=lKey
	;
	;execute the call
	set ret=$$HKEYS^xider
	;
	; verify response
	do eq^%ut(ret,KeyTooLong,"key length > xiderKeyFieldMaxLength")
	;
	quit
	;
	;
T13152	;@test with no existing key
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="hkeykey"
	;
	;execute the call
	set ret=$$HKEYS^xider
	;
	; verify response
	do eq^%ut(ret,StringArray,"key not found")
	do eq^%ut($data(xiderRet),0,"data is not present")
	;
	quit
	;
	;
T13153	;@test with existing key, but <string> data-type
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="stringkey"
	set xider(3)="stringvalue"
	;
	set ret=$$SET^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="stringkey"
	;
	;execute the call
	set ret=$$HKEYS^xider
	;
	; verify response
	do eq^%ut(ret,WrongDataType,"key exists, but not hash data-type")
	;
	quit
	;
	;
T13154	;@test with 3 keys hash
	new ret
	;
	; init the API
	do init^xider
	kill xider,xiderRet,xiderStatus
	;
	; set the key
	set xider(2)="hkey key"
	;
	; set the data
	set xider(3)="myfield1"
	set xider(4)="myvalue1"
	set xider(5)="myfield2"
	set xider(6)="myvalue2"
	set xider(7)="myfield3"
	set xider(8)="myvalue3"
	;
	;execute the call
	set ret=$$HSET^xider
	;
	kill xider,xiderRet,xiderStatus
	;
	; set the key only
	set xider(2)="hkey key"
	;
	;execute the call
	set ret=$$HKEYS^xider
	;
	; verify response
	do eq^%ut(ret,StringArray,"string array return type")
	do eq^%ut(xiderRet(1),"myfield1","success")
	do eq^%ut(xiderRet(2),"myfield2","success")
	do eq^%ut(xiderRet(3),"myfield3","success")
	;
	quit
	;
	;
T13155	;@test as procedure
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	;execute the call
	do HKEYS^xider
	;
	; verify response
	do eq^%ut($data(xiderStatus),1,"status got populated")
	;
	quit
	;
	;
HVALS0	;@test ------------------
	quit
	;
	;
HVALS1	;@test ------------API <hash> HVALS
	quit
	;
	;
HVALS2	;@test ------------------
	quit
	;
	;
T13174	;@test with no parameters
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	;execute the call
	set ret=$$HVALS^xider
	;
	; verify response
	do eq^%ut(ret,NoKey,"no key was supplied")
	;
	quit
	;
	;
T13175	;@test with an empty key
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	set xider(2)=""
	;
	;execute the call
	set ret=$$HVALS^xider
	;
	; verify response
	do eq^%ut(ret,NoKey,"empty key was supplied")
	;
	quit
	;
	;
T13176	;@test with key > xiderKeyFieldMaxLength
	new lKey,ix,ret
	;
	; init the API
	do init^xider
	kill xider,xiderRet,xiderStatus
	;
	; build a long key
	set lKey=""
	set $piece(lKey,"x",xiderKeyFieldMaxLength+2)=""
	;
	; set the key only
	set xider(2)=lKey
	;
	;execute the call
	set ret=$$HVALS^xider
	;
	; verify response
	do eq^%ut(ret,KeyTooLong,"key length > xiderKeyFieldMaxLength")
	;
	quit
	;
	;
T13177	;@test with no existing key
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="hkeykey"
	;
	;execute the call
	set ret=$$HVALS^xider
	;
	; verify response
	do eq^%ut(ret,StringArray,"key not found")
	do eq^%ut($data(xiderRet),0,"data is not present")
	;
	quit
	;
	;
T13178	;@test with existing key, but <string> data-type
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="stringkey"
	set xider(3)="stringvalue"
	;
	set ret=$$SET^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="stringkey"
	;
	;execute the call
	set ret=$$HVALS^xider
	;
	; verify response
	do eq^%ut(ret,WrongDataType,"key exists, but not hash data-type")
	;
	quit
	;
	;
T13179	;@test with 3 keys hash
	new ret
	;
	; init the API
	do init^xider
	kill xider,xiderRet,xiderStatus
	;
	; set the key
	set xider(2)="hkey key"
	;
	; set the data
	set xider(3)="myfield1"
	set xider(4)="myvalue1"
	set xider(5)="myfield2"
	set xider(6)="myvalue2"
	set xider(7)="myfield3"
	set xider(8)="myvalue3"
	;
	;execute the call
	set ret=$$HSET^xider
	;
	kill xider,xiderRet,xiderStatus
	;
	; set the key only
	set xider(2)="hkey key"
	;
	;execute the call
	set ret=$$HVALS^xider
	;
	; verify response
	do eq^%ut(ret,StringArray,"string array return type")
	do eq^%ut(xiderRet(1),"myvalue1","success")
	do eq^%ut(xiderRet(2),"myvalue2","success")
	do eq^%ut(xiderRet(3),"myvalue3","success")
	;
	quit
	;
	;
T13180	;@test as procedure
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	;execute the call
	do HVALS^xider
	;
	; verify response
	do eq^%ut($data(xiderStatus),1,"status got populated")
	;
	quit
	;
	;
HEXISTS0	;@test ------------------
	quit
	;
	;
HEXISTS1	;@test --------------API <hash> HEXISTS
	quit
	;
	;
HEXISTS2	;@test ------------------
	quit
	;
	;
T13199	;@test with no parameters
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	;execute the call
	set ret=$$HEXISTS^xider
	;
	; verify response
	do eq^%ut(ret,NoKey,"no key was supplied")
	;
	quit
	;
	;
T13200	;@test with an empty key
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	set xider(2)=""
	;
	;execute the call
	set ret=$$HEXISTS^xider
	;
	; verify response
	do eq^%ut(ret,NoKey,"empty key was supplied")
	;
	quit
	;
	;
T13201	;@test with no field
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="setnxkey"
	;
	;execute the call
	set ret=$$HEXISTS^xider
	;
	; verify response
	do eq^%ut(ret,NoField,"no field")
	;
	quit
	;
	;
T13202	;@test with an empty field
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="setnxkey"
	set xider(3)=""
	;
	;execute the call
	set ret=$$HEXISTS^xider
	;
	; verify response
	do eq^%ut(ret,NoField,"an empty field")
	;
	quit
	;
	;
T13203	;@test with field > xiderKeyFieldMaxLength
	new lKey,lField,ix,ret
	;
	; init the API
	do init^xider
	kill xider,xiderRet,xiderStatus
	;
	; build a long key
	set (lField,lKey)=""
	set $piece(lKey,"x",xiderKeyFieldMaxLength+2)=""
	set $piece(lField,"x",51)=""
	;
	; set the data
	set xider(2)=lKey
	set xider(3)=lField
	;
	;execute the call
	set ret=$$HEXISTS^xider
	;
	; verify response
	do eq^%ut(ret,KeyFieldTooLong,"field length > xiderKeyFieldMaxLength")
	;
	quit
	;
	;
T13204	;@test with no existing key
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="setnx99key"
	set xider(3)="setnxfield"
	set xider(4)="setnxvalue"
	;
	;execute the call
	set ret=$$HEXISTS^xider
	;
	; verify response
	do eq^%ut(ret,Integer,"key not found")
	do eq^%ut(xiderRet,0,"key is not present")
	;
	quit
	;
	;
T13205	;@test with existing key, but <string> data-type
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="stringkey"
	set xider(3)="stringvalue"
	;
	set ret=$$SET^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="stringkey"
	set xider(3)="setnxfield"
	;
	;execute the call
	set ret=$$HEXISTS^xider
	;
	; verify response
	do eq^%ut(ret,WrongDataType,"key exists, but not hash data-type")
	;
	quit
	;
	;
T13206	;@test with non existing field
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="stringkey2"
	set xider(3)="stringfield"
	set xider(4)="stringvalue"
	;
	set ret=$$HSET^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="stringkey2"
	set xider(3)="setnxfield"
	;
	;execute the call
	set ret=$$HEXISTS^xider
	;
	; verify response
	do eq^%ut(ret,Integer,"field doesn't exist")
	do eq^%ut(xiderRet,0,"field is not present")
	;
	quit
	;
	;
T13207	;@test with existing field
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="stringkey2"
	set xider(3)="stringfield"
	set xider(4)="stringvalue"
	;
	set ret=$$HSET^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="stringkey2"
	set xider(3)="stringfield"
	;
	;execute the call
	set ret=$$HEXISTS^xider
	;
	; verify response
	do eq^%ut(ret,Integer,"integer return type")
	do eq^%ut(xiderRet,1,"field exists")
	;
	quit
	;
	;
T13208	;@test as procedure
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	;execute the call
	do HEXISTS^xider
	;
	; verify response
	do eq^%ut($data(xiderStatus),1,"status got populated")
	;
	quit
	;
	;
HMSET0	;@test ------------------
	quit
	;
	;
HMSET1	;@test ------------------API <hash> HMSET
	quit
	;
	;
HMSET2	;@test ------------------
	quit
	;
	;
T13224	;@test with no parameters
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	;execute the call
	set ret=$$HMSET^xider
	;
	; verify response
	do eq^%ut(ret,NoKey,"no key was supplied")
	;
	quit
	;
	;
T13225	;@test with an empty key
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	set xider(2)=""
	;
	;execute the call
	set ret=$$HMSET^xider
	;
	; verify response
	do eq^%ut(ret,NoKey,"empty key was supplied")
	;
	quit
	;
	;
T13226	;@test with no fields
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	; set the key only
	set xider(2)="hset key"
	;
	;execute the call
	set ret=$$HMSET^xider
	;
	; verify response
	do eq^%ut(ret,NoField,"no fields")
	;
	quit
	;
	;
T13227	;@test with an empty field
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	; set the key and an empty field
	set xider(2)="hset key"
	set xider(3)=""
	;
	;execute the call
	set ret=$$HMSET^xider
	;
	; verify response
	do eq^%ut(ret,NoField,"an empty field")
	;
	quit
	;
	;
T13228	;@test with data with no field
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	; set the key
	set xider(2)="hset key"
	;
	; set the data
	set xider(3)="myfield1"
	set xider(4)="myvalue1"
	set xider(6)="myvalue2"
	;
	;execute the call
	set ret=$$HMSET^xider
	;
	; verify response
	do eq^%ut(ret,NoField,"some data has no field")
	;
	quit
	;
	;
T13229	;@test with field > xiderKeyFieldMaxLength
	new lField,lKey,ix,ret
	;
	; init the API
	do init^xider
	kill xider,xiderRet,xiderStatus
	;
	; build a long key
	set (lKey,lField)=""
	set $piece(lField,"x",xiderKeyFieldMaxLength+2)=""
	set $piece(lKey,"x",51)=""
	;
	; set the key
	set xider(2)=lKey
	;
	; set the data
	set xider(3)="field1"
	set xider(4)="myvalue1"
	set xider(5)=lField
	set xider(6)="myvalue2"
	;l
	;execute the call
	set ret=$$HMSET^xider
	;
	; verify response
	do eq^%ut(ret,KeyFieldTooLong,"some field is too long")
	;
	quit
	;
	;
T13230	;@test with data with no data
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	; set the key
	set xider(2)="hset key"
	;
	; set the data
	set xider(3)="myfield1"
	set xider(4)="myvalue1"
	set xider(5)="myfield2"
	;
	;execute the call
	set ret=$$HMSET^xider
	;
	; verify response
	do eq^%ut(ret,NoValue,"some data has no value")
	;
	quit
	;
	;
T13231	;@test with data with empty data
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	; set the key
	set xider(2)="hmset key"
	;
	; set the data
	set xider(3)="myfield1"
	set xider(4)="myvalue1"
	set xider(5)="myfield2"
	set xider(6)=""
	;
	;execute the call
	set ret=$$HMSET^xider
	;
	; verify response
	do eq^%ut(ret,Integer,"integer return type")
	do eq^%ut(xiderRet,2,"2 records created")
	;
	quit
	;
	;
T13232	;@test with key as string data-type
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="strkey"
	set xider(3)="strvalue"
	set ret=$$SET^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	; set the key
	set xider(2)="strkey"
	;
	; set the data
	set xider(3)="myfield1"
	set xider(4)="myvalue1"
	;
	;execute the call
	set ret=$$HMSET^xider
	;
	; verify response
	do eq^%ut(ret,WrongDataType,"strkey exists, but not hash data-type")
	;
	quit
	;
	;
T13233	;@test with non-existing key
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	; set the key
	set xider(2)="hmsetkey"
	;
	; set the data
	set xider(3)="myfield1"
	set xider(4)="myvalue1"
	set xider(5)="myfield2"
	set xider(6)="myvalue2"
	;
	;execute the call
	set ret=$$HMSET^xider
	;
	; verify response
	do eq^%ut(ret,Integer,"integer return type")
	do eq^%ut(xiderRet,2,"2 records created")
	;
	quit
	;
	;
T13234	;@test with existing key and 1 existing record
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	; set the key
	set xider(2)="hmsetkey"
	;
	; set the data
	set xider(3)="myfield1"
	set xider(4)="myvalue1"
	set xider(5)="myfield3"
	set xider(6)="myvalue3"
	;
	;execute the call
	set ret=$$HMSET^xider
	;
	; verify response
	do eq^%ut(ret,Integer,"integer return type")
	do eq^%ut(xiderRet,1,"1 records created")
	;
	quit
	;
	;
T13235	;@test with existing key and existing records
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	; set the key
	set xider(2)="hsetkey"
	;
	; set the data
	set xider(3)="myfield1"
	set xider(4)="myvalue1"
	set xider(5)="myfield3"
	set xider(6)="myvalue3"
	;
	;execute the call
	set ret=$$HMSET^xider
	;
	; verify response
	do eq^%ut(ret,Integer,"integer return type")
	do eq^%ut(xiderRet,0,"0 records created")
	;
	quit
	;
	;
T13236	;@test as procedure
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	;execute the call
	do HMSET^xider
	;
	; verify response
	do eq^%ut($data(xiderStatus),1,"status got populated")
	;
	quit
	;
	;
HMGET0	;@test ------------------
	quit
	;
	;
HMGET1	;@test --------------API <hash> HMGET
	quit
	;
	;
HMGET2	;@test ------------------
	quit
	;
	;
T13249	;@test with no parameters
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	;execute the call
	set ret=$$HMGET^xider
	;
	; verify response
	do eq^%ut(ret,NoKey,"no key was supplied")
	;
	quit
	;
	;
T13250	;@test with an empty key
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	set xider(2)=""
	;
	;execute the call
	set ret=$$HMGET^xider
	;
	; verify response
	do eq^%ut(ret,NoKey,"empty key was supplied")
	;
	quit
	;
	;
T13251	;@test with no fields
	new ret
	;
	; init the API
	do init^xider
	kill xider,xiderRet,xiderStatus
	;
	; set the key only
	set xider(2)="hashnofields"
	;
	;execute the call
	set ret=$$HMGET^xider
	;
	; verify response
	do eq^%ut(ret,NoField,"no fields")
	;
	quit
	;
	;
T13252	;@test with an empty field
	new ret
	;
	; init the API
	do init^xider
	kill xider,xiderRet,xiderStatus
	;
	; set the key and an empty field
	set xider(2)="hashnofields"
	set xider(3)=""
	;
	;execute the call
	set ret=$$HMGET^xider
	;
	; verify response
	do eq^%ut(ret,NoField,"an empty field")
	;
	quit
	;
	;
T13253	;@test with field > xiderKeyFieldMaxLength
	new lField,lKey,ix,ret
	;
	; init the API
	do init^xider
	kill xider,xiderRet,xiderStatus
	;
	; build a long key
	set (lKey,lField)=""
	set $piece(lKey,"x",xiderKeyFieldMaxLength+2)=""
	set $piece(lField,"x",51)=""
	;
	; set the fields
	set xider(2)=lKey
	set xider(3)=lField
	;
	;execute the call
	set ret=$$HMGET^xider
	;
	; verify response
	do eq^%ut(ret,KeyFieldTooLong,"field too long")
	;
	quit
	;
	;
T13254	;@test with bad key
	new ret
	;
	; init the API
	do init^xider
	kill xider,xiderRet,xiderStatus
	;
	; set the key only
	set xider(2)="hashnofields"
	set xider(3)="myfield"
	;
	;execute the call
	set ret=$$HMGET^xider
	;
	; verify response
	do eq^%ut(ret,StringArray,"key not found")
	do eq^%ut($data(xiderRet),0,"data is not present")
	;
	quit
	;
	;
T13255	;@test with <string> key
	new ret
	;
	; init the API
	do init^xider
	;
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="mystringkey2"
	set xider(3)="mystrvalue"
	do SET^xider
	;
	; set the data
	set xider(2)="mystringkey2"
	set xider(3)="myfield"
	;
	;execute the call
	set ret=$$HMGET^xider
	;
	; verify response
	do eq^%ut(ret,WrongDataType,"key exists, but not hash data-type")
	;
	quit
	;
	;
T13256	;@test with <hash> key
	new ret
	;
	; init the API
	do init^xider
	;
	kill xider,xiderRet,xiderStatus
	;
	; set the data
	set xider(2)="hkey key"
	set xider(3)="myfield"
	set xider(4)="myfield1"
	set xider(5)="myfield3"
	;
	;execute the call
	set ret=$$HMGET^xider
	;
	; verify response
	do eq^%ut(ret,StringArray,"string array return type")
	do eq^%ut(xiderRet(2),"myvalue1","field found")
	do eq^%ut(xiderRet(3),"myvalue3","field found")
	;
	quit
	;
	;
T13257	;@test as procedure
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	;execute the call
	do HMGET^xider
	;
	; verify response
	do eq^%ut($data(xiderStatus),1,"status got populated")
	;
	quit
	;
	;
HGETALL0	;@test ------------------
	quit
	;
	;
HGETALL1	;@test --------------API <hash> HGETALL
	quit
	;
	;
HGETALL2	;@test ------------------
	quit
	;
	;
T13274	;@test with no parameters
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	;execute the call
	set ret=$$HGETALL^xider
	;
	; verify response
	do eq^%ut(ret,NoKey,"no key was supplied")
	;
	quit
	;
	;
T13275	;@test with an empty key
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	set xider(2)=""
	;
	;execute the call
	set ret=$$HGETALL^xider
	;
	; verify response
	do eq^%ut(ret,NoKey,"empty key was supplied")
	;
	quit
	;
	;
T13276	;@test with key > xiderKeyFieldMaxLength
	new lKey,ix,ret
	;
	; init the API
	do init^xider
	kill xider,xiderRet,xiderStatus
	;
	; build a long key
	set lKey=""
	set $piece(lKey,"x",xiderKeyFieldMaxLength+2)=""
	;
	; set the key only
	set xider(2)=lKey
	;
	;execute the call
	set ret=$$HGETALL^xider
	;
	; verify response
	do eq^%ut(ret,KeyTooLong,"key length > xiderKeyFieldMaxLength")
	;
	quit
	;
	;
T13277	;@test with bad key
	new ret
	;
	; init the API
	do init^xider
	kill xider,xiderRet,xiderStatus
	;
	; set the key only
	set xider(2)="hashnofields"
	set xider(3)="myfield"
	;
	;execute the call
	set ret=$$HGETALL^xider
	;
	; verify response
	do eq^%ut(ret,String,"key not found")
	do eq^%ut($data(xiderRet),0,"data is not present")
	;
	quit
	;
	;
T13278	;@test with <string> key
	new ret
	;
	; init the API
	do init^xider
	;
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="mystringkey2"
	set xider(3)="mystrvalue"
	do SET^xider
	;
	; set the data
	set xider(2)="mystringkey2"
	;
	;execute the call
	set ret=$$HGETALL^xider
	;
	; verify response
	do eq^%ut(ret,WrongDataType,"key exists, but not hash data-type")
	;
	quit
	;
	;
T13279	;@test with valid key
	new ret
	;
	; init the API
	do init^xider
	;
	kill xider,xiderRet,xiderStatus
	;
	; set the data
	set xider(2)="T13081"
	;
	;execute the call
	set ret=$$HGETALL^xider
	;
	; verify response
	do eq^%ut(ret,StringMap,"string array return type")
	do eq^%ut(xiderRet,3,"three entries")
	do eq^%ut(xiderRet("T13081-1"),"T13081-1-d","first entry")
	do eq^%ut(xiderRet("T13081-2"),"T13081-2-d","second entry")
	do eq^%ut(xiderRet("T13081-3"),"T13081-3-d","third entry")
	;
	quit
	;
	;
T13280	;@test as procedure
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	;execute the call
	do HGETALL^xider
	;
	; verify response
	do eq^%ut($data(xiderStatus),1,"status got populated")
	;
	quit
	;
	;
HRANDFIELD0	;@test ------------------
	quit
	;
	;
HRANDFIELD1	;@test --------------API <hash> HRANDFIELD
	quit
	;
	;
HRANDFIELD2	;@test ------------------
	quit
	;
	;
T13299	;@test with no parameters
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	;execute the call
	set ret=$$HRANDFIELD^xider
	;
	; verify response
	do eq^%ut(ret,NoKey,"no key was supplied")
	;
	quit
	;
	;
T13300	;@test with an empty key
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	set xider(2)=""
	;
	;execute the call
	set ret=$$HRANDFIELD^xider
	;
	; verify response
	do eq^%ut(ret,NoKey,"empty key was supplied")
	;
	quit
	;
	;
T13301	;@test with key > xiderKeyFieldMaxLength
	new lKey,ix,ret
	;
	; init the API
	do init^xider
	kill xider,xiderRet,xiderStatus
	;
	; build a long key
	set lKey=""
	set $piece(lKey,"x",xiderKeyFieldMaxLength+2)=""
	;
	; set the key only
	set xider(2)=lKey
	;
	;execute the call
	set ret=$$HRANDFIELD^xider
	;
	; verify response
	do eq^%ut(ret,KeyTooLong,"key length > xiderKeyFieldMaxLength")
	;
	quit
	;
	;
T13302	;@test with count as string
	new ret
	;
	; init the API
	do init^xider
	kill xider,xiderRet,xiderStatus
	;
	; set the key only
	set xider(2)="testkey"
	set xider(3)="this is a string"
	;
	;execute the call
	set ret=$$HRANDFIELD^xider
	;
	; verify response
	do eq^%ut(ret,ValueNotInteger,"invalid count")
	;
	quit
	;
	;
T13303	;@test with count as empty string
	new ret
	;
	; init the API
	do init^xider
	kill xider,xiderRet,xiderStatus
	;
	; set the key only
	set xider(2)="testkey"
	set xider(3)=""
	;
	;execute the call
	set ret=$$HRANDFIELD^xider
	;
	; verify response
	do eq^%ut(ret,ValueNotInteger,"invalid count")
	;
	quit
	;
	;
T13304	;@test with count as 0
	new ret
	;
	; init the API
	do init^xider
	kill xider,xiderRet,xiderStatus
	;
	; set the key only
	set xider(2)="T13081"
	set xider(3)=0
	;
	;execute the call
	set ret=$$HRANDFIELD^xider
	;
	; verify response
	do eq^%ut(ret,String,"string return type")
	do eq^%ut($data(xiderRet),0,"undefined")
	;
	quit
	;
	;
T13305	;@test with withValues and no count
	new ret
	;
	; init the API
	do init^xider
	kill xider,xiderRet,xiderStatus
	;
	; set the key only
	set xider(2)="testkey"
	set xider(4)="withvalues"
	;
	;execute the call
	set ret=$$HRANDFIELD^xider
	;
	; verify response
	do eq^%ut(ret,WithvaluesNeedsCount,"invalid count")
	;
	quit
	;
	;
T13306	;@test with bad key
	new ret
	;
	; init the API
	do init^xider
	kill xider,xiderRet,xiderStatus
	;
	; set the key only
	set xider(2)="hashnofields"
	;
	;execute the call
	set ret=$$HRANDFIELD^xider
	;
	; verify response
	do eq^%ut(ret,String,"key not found")
	do eq^%ut($data(xiderRet),0,"data is not present")
	;
	quit
	;
	;
T13307	;@test with <string> key
	new ret
	;
	; init the API
	do init^xider
	;
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="mystringkey2"
	set xider(3)="mystrvalue"
	do SET^xider
	;
	kill xider,xiderRet,xiderStatus
	; set the data
	set xider(2)="mystringkey2"
	;
	;execute the call
	set ret=$$HRANDFIELD^xider
	;
	; verify response
	do eq^%ut(ret,WrongDataType,"key exists, but not hash data-type")
	;
	quit
	;
	;
T13308	;@test with valid key, no count
	new ret
	;
	; init the API
	do init^xider
	kill xider,xiderRet,xiderStatus
	;
	; set the key only
	set xider(2)="T13081"
	;
	;execute the call
	set ret=$$HRANDFIELD^xider
	;
	; verify response
	do eq^%ut(ret,String,"string return type")
	do eq^%ut($data(xiderRet),1,"success")
	;
	quit
	;
	;
T13309	;@test with valid key and positive count > # of fields
	new ret
	;
	; init the API
	do init^xider
	kill xider,xiderRet,xiderStatus
	;
	; add more entries
	set xider(2)="T13081"
	set xider(3)="T13081-4"
	set xider(4)="T13081-4-d"
	set xider(5)="T13081-5"
	set xider(6)="T13081-5-d"
	set xider(7)="T13081-6"
	set xider(8)="T13081-6-d"
	set xider(9)="T13081-7"
	set xider(10)="T13081-7-d"
	set xider(11)="T13081-8"
	set xider(12)="T13081-8-d"
	set xider(13)="T13081-9"
	set xider(14)="T13081-9-d"
	set xider(15)="T13081-10"
	set xider(16)="T13081-10-d"
	set ret=$$HSET^xider()
	;
	kill xider,xiderRet,xiderStatus
	set xider(2)="T13081"
	set xider(3)=20
	;execute the call
	set ret=$$HRANDFIELD^xider
	;
	; verify response
	do eq^%ut(ret,StringArray,"string array return type")
	do eq^%ut(xiderRet(1),"T13081-1","success")
	do eq^%ut(xiderRet(2),"T13081-10","success")
	do eq^%ut(xiderRet(3),"T13081-2","success")
	do eq^%ut(xiderRet(4),"T13081-3","success")
	do eq^%ut(xiderRet(5),"T13081-4","success")
	do eq^%ut(xiderRet(6),"T13081-5","success")
	do eq^%ut(xiderRet(7),"T13081-6","success")
	do eq^%ut(xiderRet(8),"T13081-7","success")
	do eq^%ut(xiderRet(9),"T13081-8","success")
	do eq^%ut(xiderRet(10),"T13081-9","success")
	;
	quit
	;
	;
T13310	;@test with valid key and positive count < # of fields
	new ret
	;
	; init the API
	do init^xider
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="T13081"
	set xider(3)=5
	;execute the call
	set ret=$$HRANDFIELD^xider
	;
	; verify response
	do eq^%ut(ret,StringArray,"string array return type")
	do eq^%ut($data(xiderRet),11,"success")
	;
	quit
	;
	;
T13311	;@test with valid key and negative count
	new ret,cnt
	;
	; init the API
	do init^xider
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="T13081"
	set xider(3)=-55
	;execute the call
	set ret=$$HRANDFIELD^xider
	;
	; verify response
	do eq^%ut(ret,StringArray,"string array return type")
	set cnt=0,ix="" for  set ix=$order(xiderRet(ix)) quit:ix=""  set cnt=cnt+1
	do eq^%ut(cnt,-xider(3),"success")
	;
	quit
	;
	;
T13312	;@test with count > # of fields && withValues
	new ret
	;
	; init the API
	do init^xider
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="T13081"
	set xider(3)=20
	set xider(4)="withvalues"
	;
	;execute the call
	set ret=$$HRANDFIELD^xider
	;
	; verify response
	do eq^%ut(ret,StringMapOrdered,"string map return type")
	do eq^%ut(xiderRet(1,"T13081-1"),"T13081-1-d","success")
	do eq^%ut(xiderRet(2,"T13081-10"),"T13081-10-d","success")
	do eq^%ut(xiderRet(3,"T13081-2"),"T13081-2-d","success")
	do eq^%ut(xiderRet(4,"T13081-3"),"T13081-3-d","success")
	do eq^%ut(xiderRet(5,"T13081-4"),"T13081-4-d","success")
	do eq^%ut(xiderRet(6,"T13081-5"),"T13081-5-d","success")
	do eq^%ut(xiderRet(7,"T13081-6"),"T13081-6-d","success")
	do eq^%ut(xiderRet(8,"T13081-7"),"T13081-7-d","success")
	do eq^%ut(xiderRet(9,"T13081-8"),"T13081-8-d","success")
	do eq^%ut(xiderRet(10,"T13081-9"),"T13081-9-d","success")
	;
	quit
	;
	;
T13313	;@test with count < # of fields && withValues
	new ret
	;
	; init the API
	do init^xider
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="T13081"
	set xider(3)=5
	set xider(4)="withvalues"
	;
	;execute the call
	set ret=$$HRANDFIELD^xider
	;
	; verify response
	do eq^%ut(ret,StringMapOrdered,"string map return type")
	do eq^%ut($zlength(xiderRet(1,$order(xiderRet(1,""))))>0,1,"success")
	do eq^%ut($zlength(xiderRet(2,$order(xiderRet(2,""))))>0,1,"success")
	do eq^%ut($zlength(xiderRet(3,$order(xiderRet(3,""))))>0,1,"success")
	do eq^%ut($zlength(xiderRet(4,$order(xiderRet(4,""))))>0,1,"success")
	do eq^%ut($zlength(xiderRet(5,$order(xiderRet(5,""))))>0,1,"success")
	;
	quit
	;
	;
T13314	;@test with negative count && withValues
	new ret,cnt,ix
	;
	; init the API
	do init^xider
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="T13081"
	set xider(3)=-55
	set xider(4)="withvalues"
	;execute the call
	set ret=$$HRANDFIELD^xider
	;
	; verify response
	do eq^%ut(ret,StringMapOrdered,"string map return type")
	set cnt=0,ix="" for  set ix=$order(xiderRet(ix)) quit:ix=""  set cnt=cnt+1
	do eq^%ut(cnt,-xider(3),"success")
	do eq^%ut($zlength(xiderRet(1,$order(xiderRet(1,""))))>0,1,"success")
	do eq^%ut($zlength(xiderRet(cnt,$order(xiderRet(cnt,""))))>0,1,"success")
	;
	quit
	;
	;
T13315	;@test as procedure
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	;execute the call
	do HRANDFIELD^xider
	;
	; verify response
	do eq^%ut($data(xiderStatus),1,"status got populated")
	;
	quit
	;
	;
HINCRBY0	;@test ------------------
	quit
	;
	;
HINCRBY1	;@test --------------API <hash> HINCRBY
	quit
	;
	;
HINCRBY2	;@test ------------------
	quit
	;
	;
T13323	;@test with no parameters
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	;execute the call
	set ret=$$HINCRBY^xider
	;
	; verify response
	do eq^%ut(ret,NoKey,"no key was supplied")
	;
	quit
	;
	;
T13324	;@test with an empty key
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	set xider(2)=""
	;
	;execute the call
	set ret=$$HINCRBY^xider
	;
	; verify response
	do eq^%ut(ret,NoKey,"empty key was supplied")
	;
	quit
	;
	;
T13325	;@test with no field
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="setnxkey"
	;
	;execute the call
	set ret=$$HINCRBY^xider
	;
	; verify response
	do eq^%ut(ret,NoField,"no field")
	;
	quit
	;
	;
T13326	;@test with an empty field
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="setnxkey"
	set xider(3)=""
	;
	;execute the call
	set ret=$$HINCRBY^xider
	;
	; verify response
	do eq^%ut(ret,NoField,"an empty field")
	;
	quit
	;
	;
T13327	;@test with field > xiderKeyFieldMaxLength
	new lKey,lField,ix,ret
	;
	; init the API
	do init^xider
	kill xider,xiderRet,xiderStatus
	;
	; build a long key
	set (lKey,lField)=""
	set $piece(lKey,"x",xiderKeyFieldMaxLength+2)=""
	set $piece(lField,"x",51)=""
	;
	; set the data
	set xider(2)=lKey
	set xider(3)=lField
	;
	;execute the call
	set ret=$$HINCRBY^xider
	;
	; verify response
	do eq^%ut(ret,KeyFieldTooLong,"field length > xiderKeyFieldMaxLength")
	;
	quit
	;
	;
T13328	;@test no increment provided
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="setnxkey"
	set xider(3)="incrtest"
	;
	;execute the call
	set ret=$$HINCRBY^xider
	;
	; verify response
	do eq^%ut(ret,NoIncrement,"no increment")
	;
	quit
	;
	;
T13329	;@test empty increment provided
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="setnxkey"
	set xider(3)="incrtest"
	set xider(4)=""
	;
	;execute the call
	set ret=$$HINCRBY^xider
	;
	; verify response
	do eq^%ut(ret,ValueNotInteger,"increment is not an integer")
	;
	quit
	;
	;
T13330	;@test increment as string
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="setnxkey"
	set xider(3)="incrtest"
	set xider(4)="test"
	;
	;execute the call
	set ret=$$HINCRBY^xider
	;
	; verify response
	do eq^%ut(ret,ValueNotInteger,"increment is a string")
	;
	quit
	;
	;
T13331	;@test increment as empty string
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="setnxkey"
	set xider(3)="incrtest"
	set xider(4)=""
	;
	;execute the call
	set ret=$$HINCRBY^xider
	;
	; verify response
	do eq^%ut(ret,ValueNotInteger,"not a valid increment")
	;
	quit
	;
	;
T13332	;@test increment as 0
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="setnxkey"
	set xider(3)="incrtest"
	set xider(4)=0
	;
	;execute the call
	set ret=$$HINCRBY^xider
	;
	; verify response
	do eq^%ut(ret,Integer,"integer return type")
	do eq^%ut(xiderRet,0,"value is 0")
	;
	quit
	;
	;
T13333	;@test against a string key
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="mystringkey2"
	set xider(3)="incrtest"
	set xider(4)=2
	;
	;execute the call
	set ret=$$HINCRBY^xider
	;
	; verify response
	do eq^%ut(ret,WrongDataType,"data-type not a hash")
	;
	quit
	;
	;
T13334	;@test against a string value
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="T13081"
	set xider(3)="T13081-1"
	set xider(4)=2
	;
	;execute the call
	set ret=$$HINCRBY^xider
	;
	; verify response
	do eq^%ut(ret,HashNotInteger,"hash not integer")
	;
	quit
	;
	;
T13340	;@test increment by 1 on non ex field in not ex key
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="hincrbykey"
	set xider(3)="hincrbyfield"
	set xider(4)=1
	;
	;execute the call
	set ret=$$HINCRBY^xider
	;
	; verify response
	do eq^%ut(ret,Integer,"integer return type")
	do eq^%ut(xiderRet,1,"value is 1")
	do eq^%ut(^%ydbxiderK("hincrbykey","hincrbyfield"),1,"value is 1")
	;
	quit
	;
	;
T13341	;@test increment by 5 on existing node
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="hincrbykey"
	set xider(3)="hincrbyfield"
	set xider(4)=5
	;
	;execute the call
	set ret=$$HINCRBY^xider
	;
	; verify response
	do eq^%ut(ret,Integer,"integer return type")
	do eq^%ut(xiderRet,6,"value is 6")
	do eq^%ut(^%ydbxiderK("hincrbykey","hincrbyfield"),6,"value is 6")

	;
	quit
	;
	;
T13342	;@test decrement by 3 on existing node
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="hincrbykey"
	set xider(3)="hincrbyfield"
	set xider(4)=-3
	;
	;execute the call
	set ret=$$HINCRBY^xider
	;
	; verify response
	do eq^%ut(ret,Integer,"integer return type")
	do eq^%ut(xiderRet,3,"value is 3")
	do eq^%ut(^%ydbxiderK("hincrbykey","hincrbyfield"),3,"value is 3")

	;
	quit
	;
	;
T13343	;@test as procedure
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	;execute the call
	do HINCRBY^xider
	;
	; verify response
	do eq^%ut($data(xiderStatus),1,"status got populated")
	;
	quit
	;
	;
HINCRBYFLOAT0	;@test ------------------
	quit
	;
	;
HINCRBYFLOAT1	;@test --------------API <hash> HINCRBYFLOAT
	quit
	;
	;
HINCRBYFLOAT2	;@test ------------------
	quit
	;
	;
T13348	;@test with no parameters
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	;execute the call
	set ret=$$HINCRBYFLOAT^xider
	;
	; verify response
	do eq^%ut(ret,NoKey,"no key was supplied")
	;
	quit
	;
	;
T13349	;@test with an empty key
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	set xider(2)=""
	;
	;execute the call
	set ret=$$HINCRBYFLOAT^xider
	;
	; verify response
	do eq^%ut(ret,NoKey,"no key was supplied")
	;
	quit
	;
	;
T13350	;@test with no field
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="setnxkey"
	;
	;execute the call
	set ret=$$HINCRBYFLOAT^xider
	;
	; verify response
	do eq^%ut(ret,NoField,"no field")
	;
	quit
	;
	;
T13351	;@test with an empty field
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="setnxkey"
	set xider(3)=""
	;
	;execute the call
	set ret=$$HINCRBYFLOAT^xider
	;
	; verify response
	do eq^%ut(ret,NoField,"an empty field")
	;
	quit
	;
	;
T13352	;@test with field > xiderKeyFieldMaxLength
	new lKey,lField,ix,ret
	;
	; init the API
	do init^xider
	kill xider,xiderRet,xiderStatus
	;
	; build a long key
	set (lField,lKey)=""
	set $piece(lKey,"x",xiderKeyFieldMaxLength+2)=""
	set $piece(lField,"x",51)=""
	;
	; set the data
	set xider(2)=lKey
	set xider(3)=lField
	;
	;execute the call
	set ret=$$HINCRBYFLOAT^xider
	;
	; verify response
	do eq^%ut(ret,KeyFieldTooLong,"field length > xiderKeyFieldMaxLength")
	;
	quit
	;
	;
T13353	;@test no increment provided
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="setnxkey"
	set xider(3)="incrtest"
	;
	;execute the call
	set ret=$$HINCRBYFLOAT^xider
	;
	; verify response
	do eq^%ut(ret,NoIncrement,"no increment")
	;
	quit
	;
	;
T13354	;@test empty increment provided
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="setnxkey"
	set xider(3)="incrtest"
	set xider(4)=""
	;
	;execute the call
	set ret=$$HINCRBYFLOAT^xider
	;
	; verify response
	do eq^%ut(ret,ValueNotFloat,"increment not a float")
	;
	quit
	;
	;
T13355	;@test increment as string
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="setnxkey"
	set xider(3)="incrtest"
	set xider(4)="test"
	;
	;execute the call
	set ret=$$HINCRBYFLOAT^xider
	;
	; verify response
	do eq^%ut(ret,ValueNotFloat,"increment is a string")
	;
	quit
	;
	;
T13356	;@test increment as empty string
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="setnxkey"
	set xider(3)="incrtest"
	set xider(4)=""
	;
	;execute the call
	set ret=$$HINCRBYFLOAT^xider
	;
	; verify response
	do eq^%ut(ret,ValueNotFloat,"not a valid increment")
	;
	quit
	;
	;
T13357	;@test increment as 0
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="setnxkey"
	set xider(3)="incrtest"
	set xider(4)=0
	;
	;execute the call
	set ret=$$HINCRBYFLOAT^xider
	;
	; verify response
	do eq^%ut(ret,String,"string return type")
	do eq^%ut(xiderRet,0,"value is 0")
	;
	quit
	;
	;
T13358	;@test against a string key
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="mystringkey2"
	set xider(3)="incrtest"
	set xider(4)=2.5
	;
	;execute the call
	set ret=$$HINCRBYFLOAT^xider
	;
	; verify response
	do eq^%ut(ret,WrongDataType,"data-type not a hash")
	;
	quit
	;
	;
T13359	;@test against a string value
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="T13081"
	set xider(3)="T13081-1"
	set xider(4)=2.5
	;
	;execute the call
	set ret=$$HINCRBYFLOAT^xider
	;
	; verify response
	do eq^%ut(ret,HashNotFloat,"hash not float")
	;
	quit
	;
	;
T13360	;@test increment by 1.5 on non ex field in not ex key
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="hincrbykey2"
	set xider(3)="hincrbyfield2"
	set xider(4)=1.5
	;
	;execute the call
	set ret=$$HINCRBYFLOAT^xider
	;
	; verify response
	do eq^%ut(ret,String,"string return type")
	do eq^%ut(xiderRet,1.5,"value is 1.5")
	do eq^%ut(^%ydbxiderK("hincrbykey2","hincrbyfield2"),1.5,"value is 1.5")
	;
	quit
	;
	;
T13361	;@test increment by 5.5 on existing node
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="hincrbykey2"
	set xider(3)="hincrbyfield2"
	set xider(4)=5.5
	;
	;execute the call
	set ret=$$HINCRBYFLOAT^xider
	;
	; verify response
	do eq^%ut(ret,String,"string return type")
	do eq^%ut(xiderRet,7,"value is 7")
	do eq^%ut(^%ydbxiderK("hincrbykey2","hincrbyfield2"),7,"value is 7")

	;
	quit
	;
	;
T13362	;@test decrement by 1.5 on existing node
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	set xider(2)="hincrbykey2"
	set xider(3)="hincrbyfield2"
	set xider(4)=-1.5
	;
	;execute the call
	set ret=$$HINCRBYFLOAT^xider
	;
	; verify response
	do eq^%ut(ret,String,"string return type")
	do eq^%ut(xiderRet,5.5,"value is 5.5")
	do eq^%ut(^%ydbxiderK("hincrbykey2","hincrbyfield2"),5.5,"value is 5.5")

	;
	quit
	;
	;
T13363	;@test as procedure
	new ret
	;
	; init the API
	do init^xider
	;
	; kill shared array
	kill xider,xiderRet,xiderStatus
	;
	;execute the call
	do HINCRBYFLOAT^xider
	;
	; verify response
	do eq^%ut($data(xiderStatus),1,"status got populated")
	;
	quit
	;
	;
