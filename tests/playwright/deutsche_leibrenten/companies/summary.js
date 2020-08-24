/**
Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

Lesli - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  <hello@lesli.tech>
@website  <https://lesli.tech>
@license  Propietary - all rights reserved.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/

// · 
const playwright = require('playwright')
const random = require('../random')

async function checkCooperationAgreement(configuration){
    const browserType = "chromium"
    const browser = await playwright[browserType].launch({ headless: false });
    const context = await browser.newContext();
    const page = await context.newPage();
    
    await page.goto(`${configuration.url}/login`);
    await page.fill('input[name=user_email]', configuration.email)
    await page.fill('input[name=user_password]', configuration.password)
    await page.click('input[type=submit]')
    await page.waitForTimeout(3000)

    for(let i = 0; i < 2; i++){
        let company_id = random.randomCompanyId()
        await page.goto(`${configuration.url}/crm/companies/${company_id}`)
        await page.waitForTimeout(3000)
        await page.click('span[name=tab-company-subtab-contract-data]')
        await page.waitForTimeout(200)
        
        let summary_element = await page.$('p[name=summary-cooperation-agreement]')
        summary_element = (await summary_element.innerText()).trim()

        let form_element = await page.$('div[name=container-cooperation-agreement]')
        form_element = await form_element.$('input:checked')
        form_element = await form_element.getAttribute('name')

        if(summary_element != form_element){
            throw `Cooperation agreement in company ${company_id} is different in summary and form`
        }
    }

    await browser.close()
}

async function execute(configuration){
    configuration.url = configuration.url || "https://intern.deutsche-leibrenten.de"
    configuration.email = configuration.email || ""
    configuration.password = configuration.password || ""

    await checkCooperationAgreement(configuration)
}

module.exports = {
    execute
}
