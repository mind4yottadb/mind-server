## method

---

A method is a function which is a property of an object. It may or may not return a value.
when the method `name` is invoked in the client, it will execute the related `entryPoint` and, eventually, return a
value.

If parameters are declared, the passed values will be automatically converted to an M value.

Objects are automatically converted to and from JSON / JDOM (the M representation of a JSON structure)

````js
 const obj = mind.banking.clients.getClientsByCity(city)
 ````

A method have the following properties:

- `name`
- `entryPoint`
- `paramters`
- `returns`
- `description`
- `showDescription`
- `showSignature`

<BR>

Property: **name** as `string`

---

The `name` is MANDATORY and must follow these rules:

- It must be at least three characters long
- The first character must be either an underscore (`_`) or a lower or upper case letter.
- The remaining characters may be either an underscore (`_`), a number or a lower or upper case letter.

The name is the method name that will be invoked in the client. This name is linked to the routine function or
procedures, declared in the `entryPoint` property.

<BR>

Property: **entryPoint** as `string`

---

The `entryPoint` is MANDATORY and must point to a `label^routine`. The routine does not need to be in the uApi
directory, can be any routine resolved by the `$zroutines`.

When the method having the `name` is called, the `entryPoint` is automatically invoked.


<BR>

Property: **parameters** as `array`

---

The `paramters` property is NOT mandatory and it is an array of `parameters`. It can be as long as needed.

Parameters are validated in the client for datatype correctness and length.

Passed arguments are available in the M function / procedure through the array `%args`. A parameters called `filename`
will have its value available in M through:

````mumps
set my file=%args("filename")
````

and the entry will always exist, even if an empty value is passed.



<BR>

Property: **returns** as `string`

---

The `returns` property is NOT mandatory and it define what kind of data is returned, if any.

It can be any of these values:

- `string`
- `int`
- `float`
- `boolean`
- `null`
- `object`

There are M helpers to automatically convert and return value in the specific datatypes.
Objects requires an array (passed by reference) to describe the object in JDOM format. Server and client conversion will
happen automatically, behind the scene.



<BR>

Property: **description** as `string`

---

The `description` property is NOT mandatory and it is used to describe the functionality of the method.

The description can be pushed to the client namespace, providing extra information to the client programmer.



<BR>

Property: **showDescription** as `boolean`

---

When `true`, it will include the method description in the client namespace, displayed as a property, named
as: <methodName>_description.



<BR>

Property: **showSignature** as `boolean`

---

When `true`, it will include the method signature in the client namespace, displayed as a property, named
as: <methodName>_signature.

The signature includes the return datatype, if present, the method name and the parameter names and related datatype, if
listed.


---

### Examples

A simple method, with no parameters and no return value

````json
{
    "client": [
        {
            "name": "firstLevel",
            "methods": [
                {
                    "name": "myMethod",
                    "entryPoint": "myLabel^myRoutine"
                }
            ]
        }
    ]
}

````

<BR>

A method with return value as string

````json
{
    "client": [
        {
            "name": "firstLevel",
            "methods": [
                {
                    "name": "myMethod",
                    "entryPoint": "myLabel^myRoutine",
                    "returns": "string"
                }
            ]
        }
    ]
}

````

<BR>


A method with return value as boolean and one parameter with datatype as object

````json
{
    "client": [
        {
            "name": "firstLevel",
            "methods": [
                {
                    "name": "myMethod",
                    "entryPoint": "myLabel^myRoutine",
                    "parameters": [
                        {
                            "name": "par1",
                            "datatype": "object"
                        }
                    ],
                    "returns": "boolean"
                }
            ]
        }
    ]
}

````

The above method can be called as follows:

````js
const isValid = mind.firstLevel.myMethod({
    name: 'this is the name',
    age: 23,
    extraArray: [
        'string1',
        'string2'
        // etc
    ]
})

````

<BR>

With description and signature shown...

````json
{
    "client": [
        {
            "name": "firstLevel",
            "methods": [
                {
                    "name": "myMethod",
                    "entryPoint": "myLabel^myRoutine",
                    "parameters": [
                        {
                            "name": "par1",
                            "datatype": "object"
                        }
                    ],
                    "returns": "boolean",
                    "description": "Validate the object and returns true is successful",
                    "showDescription": true,
                    "showSignature": true
                }
            ]
        }
    ]
}

````

On the client this will look like:

````js
mind.firstLevel = {
    myMethod: [Function(anonymous)],
    myMethod_signature: 'boolean = myMethod(par1 as object)',
    myMethod_description: 'Validate the object and returns true is successful'
}

````