const readline = require('readline')
const fs = require('fs')
const summary = require('./companies/summary')

var stdio = readline.createInterface({
    input: process.stdin,
    output: process.stdout
})

var configuration = {
    url:   'http://localhost:3000',
    email:       'crm.admin@deutsche-leibrenten.de',
    password:   ""
}

function getStdinData(message){
    return new Promise((response)=>{
        stdio.question(message, function(data){
            response(data.trim())
        })
    })
}

async function executeTests(){
    console.log(' ----------------------------------------------------------------------------')
    console.log(' ----------------------- Deutsche Leibrenten GUI Test -----------------------')
    console.log(' ----------------------------------------------------------------------------')
    console.log('')

    let url = await getStdinData(`Test url [blank for default value (${configuration.url})]: `)
    if(url){
        configuration.url = url
    }

    let email = await getStdinData(`Test username [blank for default value (${configuration.email})]: `)
    if(email){
        configuration.email = email
    }

    let password = await getStdinData(`Test password [blank for default value (${configuration.password})]: `)
    if(password){
        configuration.password = password
    }
    
    try {

        await new Promise(function(resolve, reject){
            summary.execute(configuration)
            .catch((error)=>{
                console.log('\x1b[41m', `Summary test failed`)
                console.log('============================================================================')
                console.log(error)
                process.exit(1)
            }).then(()=>{
                console.log('All tests successfully passed')
                process.exit(0)
            })

            setTimeout(reject, 60000)
        }).catch((error)=>{
            console.log('\x1b[41m', `Summary test is taking too long`)
            console.log('============================================================================')
            console.log(error)
            process.exit(1)
        })
    } catch(e) {
        console.log(e)
    }


    stdio.close()
}

executeTests()

