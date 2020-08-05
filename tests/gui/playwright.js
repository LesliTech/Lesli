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
    const browserType = "chromium"
    const browser = await playwright[browserType].launch({ headless: false });
    const context = await browser.newContext();
    const page = await context.newPage();
    await page.goto("http://0.0.0.0:3000/login");
    await page.fill('input[name=user_email]', 'dev@lesli.cloud')
    await page.fill('input[name=user_password]', 'lesli2020')
    await page.click('input[type=submit]')
    await page.waitForTimeout(1000);
    await page.click("a[href='/crm/projects']")
    for (let index = 0; index <= 20; index++) {
        await page.goto("http://0.0.0.0:3000/crm/projects");
        await page.goto("http://0.0.0.0:3000/crm/tasks");
    }
    await page.waitForTimeout(3000);
    await browser.close();
})();
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
    const browserType = "chromium"
    const browser = await playwright[browserType].launch({ headless: false });
    const context = await browser.newContext();
    const page = await context.newPage();
    await page.goto("http://0.0.0.0:3000/login");
    await page.fill('input[name=user_email]', 'dev@lesli.cloud')
    await page.fill('input[name=user_password]', 'lesli2020')
    await page.click('input[type=submit]')
    await page.waitForTimeout(1000);
    await page.click("a[href='/crm/projects']")
    for (let index = 0; index <= 20; index++) {
        await page.goto("http://0.0.0.0:3000/crm/projects");
        await page.goto("http://0.0.0.0:3000/crm/tasks");
    }
    await page.waitForTimeout(3000);
    await browser.close();
})();
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
    const browserType = "chromium"
    const browser = await playwright[browserType].launch({ headless: false });
    const context = await browser.newContext();
    const page = await context.newPage();
    await page.goto("http://0.0.0.0:3000/login");
    await page.fill('input[name=user_email]', 'dev@lesli.cloud')
    await page.fill('input[name=user_password]', 'lesli2020')
    await page.click('input[type=submit]')
    await page.waitForTimeout(1000);
    await page.click("a[href='/crm/projects']")
    for (let index = 0; index <= 20; index++) {
        await page.goto("http://0.0.0.0:3000/crm/projects");
        await page.goto("http://0.0.0.0:3000/crm/tasks");
    }
    await page.waitForTimeout(3000);
    await browser.close();
})();
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
    const browserType = "chromium"
    const browser = await playwright[browserType].launch({ headless: false });
    const context = await browser.newContext();
    const page = await context.newPage();
    await page.goto("http://0.0.0.0:3000/login");
    await page.fill('input[name=user_email]', 'dev@lesli.cloud')
    await page.fill('input[name=user_password]', 'lesli2020')
    await page.click('input[type=submit]')
    await page.waitForTimeout(1000);
    await page.click("a[href='/crm/projects']")
    for (let index = 0; index <= 20; index++) {
        await page.goto("http://0.0.0.0:3000/crm/projects");
        await page.goto("http://0.0.0.0:3000/crm/tasks");
    }
    await page.waitForTimeout(3000);
    await browser.close();
})();
