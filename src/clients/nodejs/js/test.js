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

await ydb.fs.writeFile('/test.txt', 'this is the data')

console.log(await ydb.fs.readFile('/test.txt').catch(e => console.log(e)))


//ydb.disconnect()
/*
ydb.connect('127.0.0.1', 10000, "admin", "admin").then(() => {
    console.log('Logged in ok')
}).catch((err) =>console.log(err))

 */

//await ydb.disconnect()