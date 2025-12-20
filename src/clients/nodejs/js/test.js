import mind from './index.js'

const ydb = new mind

console.dir(ydb)

await ydb.connect('127.0.0.1', 10000)

console.dir(ydb)

console.log(ydb.process.pid)
ydb.process.pid = 33

await ydb.disconnect()