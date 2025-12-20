import mind from './index.js'

const ydb = new mind

console.dir(ydb)

await ydb.connect('127.0.0.1', 10000, "admin", "admin")

console.dir(ydb)

console.log(ydb.process.pid)

ydb.on('error', err => console.error('custom error: ' + err))

//await ydb.disconnect()