const playwright = require('playwright');

(async () => {
    for (const browserType of ['chromium', 'firefox', 'webkit']) {
        const browser = await playwright[browserType].launch();
        const context = await browser.newContext();
        const page = await context.newPage();
        await page.goto("http://0.0.0.0:3000/login");
        await page.click("input[type=submit]")
        await page.screenshot({ path: `storage/example-${browserType}.png` });
        await browser.close();
    }
})();
