## namespace

---

The namespace is a piece of the path needed to execute a method or read a property.

I.e. one namespace called `banking` having one namespace child called `interest`, having a method called `post()` will
be accessed,
in the client, as:

````js
mind.banking.interest.post()
````

A namespace have the following properties:

- `name`
- `properties`
- `methods`
- `children`

<BR>

Property: **name** as `string`

---

The `name` is MANDATORY and must follow these rules:

- It must be at least three characters long
- The first character must be either an underscore (`_`) or a lower or upper case letter.
- The remaining characters may be either an underscore (`_`), a number or a lower or upper case letter.

<BR>

Property: **properties** as `array`

---

The `properties` is an ARRAY of property objects.

It is not mandatory, but the last namespace in the chain must have at least one method or one property.


<BR>


Property: **methods** as `array`

---

The `methods` is an ARRAY of method objects.

It is not mandatory, but the last namespace in the chain must have at least one method or one property.


<BR>

Property: **children** as `array`

---

The `children` is an ARRAY of namespace objects.

It is not mandatory.

The maximum nesting level is THREE. Still, you can have as many children as you want in the first and second level,
allowing you to build a complex tree structure.

<br>


---

### Examples

Three levels deep namespaces

````json
{
    "client": [
        {
            "name": "firstLevel",
            "children": [
                {
                    "name": "secondLevel",
                    "children": [
                        {
                            "name": "thirdLevel",
                            "methods": [
                                // your methods here
                            ]
                        }
                    ]
                }
            ]
        }
    ]
}

````

Two levels with multiple branches

````json
{
    "client": [
        {
            "name": "firstLevel",
            "children": [
                {
                    "name": "secondLevel_1",
                    "methods": [
                        {
                            "name": "method21",
                            "entryPoint": "aaa^bbb"
                        }
                    ]
                },
                {
                    "name": "secondLevel_2",
                    "methods": [
                        {
                            "name": "method22",
                            "entryPoint": "aaa^bbb"
                        }
                    ]
                }
            ],
            "methods": [
                {
                    "name": "method1",
                    "entryPoint": "aaa^bbb"
                },
                {
                    "name": "method2",
                    "entryPoint": "aaa2^bbb2"
                }
            ]
        }
    ]
}


````