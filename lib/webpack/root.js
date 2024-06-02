"use strict"
/*
Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Ruby on Rails SaaS Development Framework.

Made with ♥ by LesliTech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/


// · 
const fs = require("fs")
const path = require("path")
const engine_dir = path.resolve("../", "../", "lib")


// · 
module.exports = (env, requestedEngines) => {

    var entries = []

    var config = {

        entry: {
        },

        // javascript output only,
        // the output for stylesheets is defined in the webpack file itself
        output: {
            path: path.resolve("../", "../", "app", "assets"),
            filename: "javascripts/[name].js"
        }
    }

    // scan the vue folder to get all the vue apps
    const vueFolder = path.resolve("../", "../", "lib", "vue")


    if (!fs.existsSync(vueFolder)) {
        return config
    } 


    // filter to remove the folders to get only .js files
    const files = fs.readdirSync(vueFolder, { withFileTypes: true })
        .filter(item => !item.isDirectory())
        .map(item => item.name)


    // register every vue app found
    files.forEach(file => {

        // path to the vue app main mount file
        const appPath = path.resolve(vueFolder, file)

        // stop process if vue app does not exists
        if (!fs.existsSync(appPath)) { return; }

        const appname = path.parse(file).name

        // add vue apps found into the webpack compilation pipeline
        config.entry[(`${appname}`)] = [
            `${engine_dir}/vue/${appname}.js`,
            `${engine_dir}/scss/${appname}.scss`
        ]

    })


    // check if the engine has vue apps to compile
    if (Object.keys(config.entry).length <= 0) { return }

    entries.push({ code: "root", dir: engine_dir, config })

    // do not include the core apps if specific engines were requested
    if (requestedEngines.length > 0 && !requestedEngines.includes("root")) {
        config.entry = {}
    }

    return config

}
