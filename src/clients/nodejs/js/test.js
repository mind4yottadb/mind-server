import {exit} from 'node:process'
import mind from './index.js'

const ydb = new mind


await ydb.connect('127.0.0.1', 10000, "admin", "admin").catch(err => {
        console.log('Error is: ' + err)
        exit()
    }
)

//console.log(ydb.server.hostName)
//ydb.server.hostName='tetetet'

//ydb.server.pid=55

//console.dir(ydb)

ydb.on('error', err => console.log('custom error: ' + err))
ydb.on('disconnected', err => console.log('disconnected'))

//await ydb.fs.writeFile('/test.txt2', 'this is the data I write')
//await ydb.fs.appendFile('/test.txt2', 'and then append')

//console.log(await ydb.fs.readFile('/test.txt2').catch(e => console.log(e)))


//console.log(await ydb.process.cwd)
//await ydb.process.cwdSet('/opt')


//console.log(await ydb.process.cwdGet())

console.dir(await ydb.fs.readdir('/opt/yottadb/current', ''))

//await ydb.fs.renameFile('/tmp/stef/aaa.txt', '/tmp/stef/a')
//await ydb.fs.removeFile('/tmp/stef/aaa.txt')

//console.dir(ydb, {width: 5})
ydb.disconnect()
/*
ydb.connect('127.0.0.1', 10000, "admin", "admin").then(() => {
    console.log('Logged in ok')
}).catch((err) =>console.log(err))

 */

//await ydb.disconnect()