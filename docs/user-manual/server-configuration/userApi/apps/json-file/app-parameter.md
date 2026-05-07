## parameter

---

A parameter object describes a method parameters. Once declared, its presence and datatype will be required in the
client for the method to be executed.

Parameters data will be automatically converted to their M equivalent.

A parameter have the following properties:

- `name`
- `datatype`

<BR>

Property: **name** as `string`

---

The `name` is MANDATORY and must follow these rules:

- It must be at least three characters long
- The first character must be either an underscore (`_`) or a lower or upper case letter.
- The remaining characters may be either an underscore (`_`), a number or a lower or upper case letter.

The parameter argument will be available in the M function / procedure as subscript in the %mindArgs array.

So, a parameter called `filename` will be available in M as `%mindArgs("filename")`


<BR>

Property: **datatype** as `string`

---

The `datatype` is MANDATORY and must be one of the following:

- `string` it will return a M string
- `int` it will return an M number
- `float` it will return an M number
- `boolean` it will return 1 or 0
- `object` it will return an array with the JDOM representation of the object





