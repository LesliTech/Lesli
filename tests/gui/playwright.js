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
const playwright = require('playwright');

(async () => {

    var credentials = {
        url: "https://intern.deutsche-leibrenten.de",
        email: "crm.admin@deutsche-leibrenten.de",
        password: "dl$2019**"
    }

    /*
    credentials = {
        url: "http://0.0.0.0:3000",
        email: "dev@lesli.cloud",
        password: "lesli2020",
        email: "crm.admin@deutsche-leibrenten.de",
        password: "dl$2019**"
    }
    */
    for (let index = 0; index < 10; index++) {
        flow1(credentials.url, credentials.email, credentials.password)
    }
    
})();

const possible_project_codes = [
    '201907108', '201907109',
    '201907110','201907111',
    '201907112','201907116',
    '201907124','201907131',
    '201907138','201907142',
    '201907150','201907160',
    '201907170','201907176',
    '201907184','201907190',
    '201907192','201907193',
    '201907194','201907195',
    '201907196','201907198',
    '201907200','201907203',
    '201907204','201907206',
    '201907208','201907212',
    '201907215','201907218',
    '201907221','201907224',
    '201907227','201907233',
    '201907237','201907248',
    '201907252','20200713041',
    '20200713040','20200713039',
    '20200713038','20200713037',
    '20200713036','20200713035',
    '20200713034','20200713033',
    '20200713032','20200713031',
    '20200713030','20200713029',
    '20200713028','20200713027',
    '20200713026','20200713025',
    '20200713024','20200713023',
    '20200713021','20200713020',
    '20200713019','20200713018'
]

const possible_company_ids = [
    85,78,67,35,
    54,40,80,10,
    34,83,68,42,
    8,9,23,53,
    21,77,24,14,
    79,28,33,7,
    49,19,6,37,
    55,13,1,18,
    30,51,26,27,
    81,29,17,11,
    69,31,44,43,
    39,22,5,57,
    32,41,87,74,
    63,59,52,46
]

const possible_search_texts = [
    'heine',
    'mueller',
    'Mue-',
    'Tonna',
    'Berlin',
    '2020',
    '202008',
    '2020 a',
    'Ober',
    'an',
    'Vallendar',
    '23626',
    'Mar',
    'Alex',
    'Fr',
    'man 3',
    'wolf',
    'Hans Rese 1'
]

function random_project_code(){
    return possible_project_codes[Math.floor(Math.random() * possible_project_codes.length)]
}

function random_company_id(){
    return possible_company_ids[Math.floor(Math.random() * possible_company_ids.length)]
}

function random_search_text(){
    return possible_search_texts[Math.floor(Math.random() * possible_search_texts.length)]
}

function flow1 (base_url, email, password) {
    (async () => {
        const browserType = "chromium"
        const browser = await playwright[browserType].launch({ headless: false });
        const context = await browser.newContext();
        const page = await context.newPage();
        try {
            await page.goto(`${base_url}/login`);
            await page.fill('input[name=user_email]', email)
            await page.fill('input[name=user_password]', password)
            await page.click('input[type=submit]')
            await page.waitForTimeout(3000);
            await page.click("a[href='/crm/projects']")
            for (let index = 0; index <= 15; index++) {
                await page.goto(`${base_url}/crm/projects`);
                await page.waitForTimeout(4000);
                await page.goto(`${base_url}/crm/projects/${random_project_code()}`);
                await page.waitForTimeout(4000);
                await page.goto(`${base_url}/crm/companies/${random_company_id()}`);
                await page.waitForTimeout(4000);
                await page.goto(`${base_url}/crm/tasks`);
                await page.waitForTimeout(4000);
                await page.fill('input[name=global_search]', random_search_text())
                await page.waitForTimeout(4000);
            }
            await page.waitForTimeout(5500);
            await browser.close();
        } catch (error) {
            console.log(error)
        }
    })();
}
