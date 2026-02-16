## Global scoped variables

Yhe global scoped variables is a list of variables / arrays that contain data that you may need available through
multiple subsequent calls.

These variables are `app` related, meaning the Mind server can have multiple apps, each with different variable lists,
and each connected
session will initialize and expose the list related to its `appName`, all at the same time.

There is no limit in how many variables can be declared, BUT if the list is greater than 10 names, then the
`exclusive new` can not be used
and all variable names will be leaked to your procedures (although they are all prefixed with `%mind`).


