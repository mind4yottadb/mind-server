import mind from './index.js'

const ydb = new mind


try {
    await ydb.connect('127.0.0.1', 10000, "admin", "admin")



    console.log(ydb.server.hostName)
    //ydb.server.hostName='tetetet'

    //ydb.server.pid=55

    console.dir(ydb)

    ydb.on('error', err => console.error('custom error: ' + err))
} catch (err) {
    console.log('Error is: ' + err)
}

ydb.fs.readFile()

/*
ydb.connect('127.0.0.1', 10000, "admin", "admin").then(() => {
    console.log('Logged in ok')
}).catch((err) =>console.log(err))

 */

//await ydb.disconnect()