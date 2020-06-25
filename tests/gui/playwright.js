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
    await page.waitForTimeout(3000);
    await page.click("a[href='/crm/projects']")
    await page.waitForTimeout(3000);
    await browser.close();
    /*
    for (const browserType of ['chromium', 'firefox', 'webkit']) {
        const browser = await playwright[browserType].launch();
        const context = await browser.newContext();
        const page = await context.newPage();
        await page.screenshot({ path: `test-${browserType}1.png` });
        await page.goto("http://0.0.0.0:3000/login");
        await page.screenshot({ path: `test-${browserType}2.png` });
        await page.click("input[type=submit]")
        await page.screenshot({ path: `test-${browserType}3.png` });
        await browser.close();
    }
    */
})();
