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
    [
        {
            email: 'dev@lesli.cloud',
            password: 'lesli2020'
        },
        {
            email: 'dev@lesli.cloud',
            password: 'lesli2020'
        },
        {
            email: 'dev@lesli.cloud',
            password: 'lesli2020'
        },
        {
            email: 'dev@lesli.cloud',
            password: 'lesli2020'
        },
        {
            email: 'dev@lesli.cloud',
            password: 'lesli2020'
        },
    ].map(user => flow1('http://0.0.0.0:3000', user.email, user.password))
})();



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
            for (let index = 0; index <= 10; index++) {
                await page.goto(`${base_url}/crm/projects`);
                await page.waitForTimeout(1000);
                await page.goto(`${base_url}/crm/tasks`);
                await page.fill('input[name=global_search]', 'Wolf')
                await page.waitForTimeout(2000);
            }
            await page.waitForTimeout(5500);
            await browser.close();
        } catch (error) {
            console.log(error)
        }
    })();
}
