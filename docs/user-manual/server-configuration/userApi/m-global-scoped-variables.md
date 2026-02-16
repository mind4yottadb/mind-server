## Global scoped variables

Yhe global scoped variables is an array of M variables / arrays names that contain data that you may need available
through
multiple subsequent calls.

These variables are `app` related, meaning the Mind server can have multiple apps, each with different variable lists,
and each connected
session will initialize and expose the list related to its `appName`, all at the same time.

There is no limit in how many variables can be declared, BUT if the list is greater than 10 names, then the
`exclusive new` can not be used
and all variable names will be leaked to your procedures (although they are all prefixed with `%mind`).

````json
{
    "server": {
        "vars": [
            "userInfo",
            "lastTransactionId"
        ]
    }
}

````

Each var must follow the M syntax or a parsing error will occur when starting the Mind server.

