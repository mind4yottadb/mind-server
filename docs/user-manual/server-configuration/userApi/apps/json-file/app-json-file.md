# App JSON file

The app JSON file is located in the uApi directory, which is located, as standard, in $ydb_dist/plugin/etc/mind/uApi,
but the location can
be overwritten in the configuration file or the command line.

This directory can contain as many JSON file as needed.

Each JSON file describe a "group of methods and properties" that will be available to the client, when the app name is
selected.

The same M function / procedure can be described in multiple JSON files, giving you the flexibility to group and arrange
methods and properties in different namespace structures.

The JSON file name (without the .json extension) is the `app name`.

The JSON file describes the following:

- Client
    - The namespaces, up to three levels. There is no limit in how many sub-namespaces, methods or properties are
      described.
    - The methods, as they will appear in the client. Additionally, a method describes the following:
        - Parameters, including name and datatype
        - Returns datatype (or nothing)
    - The properties, describing their names and datatypes.
- Server
    - A list of global variables that will be declared as global in this specific session and will be available to your
      code. Up to 20 variables can be listed.

## Detailed description

At the root of the JSON file we have two main entries:

- `server`
- `client`

The `server` node is optional and can be omitted.
The `client` node is NOT optional and must be present.

The JSON files got parsed when the mind server starts up. If any error is found, the error location is dumped on the
console and the app will not be available to the clients.

`This is an example of a simple JSON file`

### The `client` section

The `client` section is made up of arrays of the following objects:

- [`namespace`](app-namespace.md)
- `property`
- `method`
- `parameter`

### property

---


<br>

### method

---





<br>

### parameter

---

### The `server` section

The server section can have the following nodes:

- `vars`
- `code`
- `hooks`
    - `onInit`
    - `onTerminate`
    - `onError`


