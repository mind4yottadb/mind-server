## property

---

The property is a read-only value that will be listed in the current namespace and can be addressed directly.

I.e. a property called `bankId` in the namespace `banking.clients` can be accessed as follows:

````js
 const bankId = mind.banking.clients.bankId
 ````

A property have the following properties:

- `name`
- `datatype`
- `value`

<BR>

Property: **name**

---

The `name` is MANDATORY and must follow these rules:

- It must be at least three characters long
- The first character must be either an underscore (`_`) or a lower or upper case letter.
- The remaining characters may be either an underscore (`_`), a numer or a lower or upper case letter.

<BR>

Property: **datatype**

---

The `datatype` is MANDATORY and must be one of these values:

- `string`
- `int`
- `float`
- `boolean`

<BR>

Property: **value**

---

The `value` is MANDATORY and must reflect the selected datatype


<BR>

---

### Examples

````json
{
    "client": [
        {
            "name": "firstLevel",
            "properties": [
                {
                    "name": "prop1",
                    "datatype": "string",
                    "value": "this is a string"
                },
                {
                    "name": "prop2",
                    "datatype": "int",
                    "value": 1966
                },
                {
                    "name": "prop3",
                    "datatype": "float",
                    "value": 123.567
                },
                {
                    "name": "prop4",
                    "datatype": "boolean",
                    "value": true
                }
            ],
            "children": [
                {
                    "name": "secondLevel",
                    "properties": [
                        {
                            "name": "prop21",
                            "datatype": "string",
                            "value": "another string"
                        }
                    ]
                }
            ]
        }
    ]
}

````

On the client this will look like:

````js
mind.firstLevel = {
    prop1: 'this is a string',
    prop2: 1966,
    prop3: 123.567,
    prop4: true,
    secondLevel: {
        prop21: 'another string'
    }
}

````