import mind from './index.js'

const ydb = new mind

console.dir(ydb)

await ydb.connect('127.0.0.1', 10000, "admin", "admin")

console.dir(ydb)


console.log(ydb.server.hostName)
//ydb.server.hostName='tetetet'

//ydb.server.pid=55


ydb.on('error', err => console.error('custom error: ' + err))

//await ydb.disconnect()