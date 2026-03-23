# uApi small example

This is a small example of a JSON describing a method and a property.

````json
{
    "server": {
        "vars": [
            "userInfo",
            "lastTransactionId"
        ]
    },
    "client": [
        {
            "name": "interest",
            "properties": [
                {
                    "name": "bank_UID",
                    "datatype": "string",
                    "value": "INGB07"
                }
            ],
            "methods": [
                {
                    "name": "accrual",
                    "entryPoint": "accr^bankInterest",
                    "parameters": [
                        {
                            "name": "bankAccount",
                            "datatype": "int"
                        },
                        {
                            "name": "value",
                            "datatype": "int"
                        }
                    ],
                    "returns": "booleans"
                }
            ]
        }
    ]
}

````

<br>


If the json file is called: `banking.json`, we can connect using its name as app.name in the client:

````js
    await mind.connect('127.0.0.1', 10000, "admin", "admin", {
    app: {
        name: "banking",
    }
})
````

<BR>
After the connect / login process, we can show the dynamically generated namespace and methods/properties:

````js
console.log(mind.interest)

````

<BR>

````js
interest: {
    accrual: [Function(anonymous)],
        bank_UID
:
    'INGB07'
}

````

<BR>

And we can call the function right away:

````js
const ret = mind.interest.accrual(CustomerbankAccount, accrualValue)

````