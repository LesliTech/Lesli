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


// · Including plugins and dependencies
const path = require("path")
const version = require("./lib/webpack/version")
const { useLesliDebug } = require("lesli-vue/composables")


// · Including webpack configuration
const webpackBase = require("./lib/webpack/base")
const webpackRoot = require("./lib/webpack/root")
const webpackCore = require("./lib/webpack/core")
const webpackEngines = require("./lib/webpack/engines")


// get specific modules to work with, example: npm run webpack -- babel bell
const requestedEngines = process.argv.slice(5)

const debug = useLesliDebug()

// · 
module.exports = env => {
    
    
    // set mode
    env.mode = env.mode ? env.mode : "development"
    env.watch = env.watch ? env.watch : false
    env.production = (env.mode == "production" ? true : false)
    

    // webpack "threads"
    var webpackConfig = []

    
    // Root vue applications
    webpackConfig.push(Object.assign({}, webpackBase(env), webpackRoot(env, requestedEngines)))
    //version(env, { code: "root", dir: "Root" })


    // Core vue applications
    webpackConfig.push(Object.assign({}, webpackBase(env), webpackCore(env, requestedEngines)))
    version(env, { code: "lesli", dir: "Lesli" })
    

    // Engines vue applications
    webpackEngines(env, requestedEngines).forEach(engine => {
        webpackConfig.push(Object.assign({}, webpackBase(env), engine.config))
        version(env, engine)
    })


    debug.hr()


    // show a nice debug message for every installed engine and root vue applications :) 
    webpackConfig.forEach(config => {
        for (let [name, assets] of Object.entries(config.entry)) {

            // "assets" contain the list of individual assets in the queue
            // to be compiled, if strings is found we most convert this to 
            // an array so we can forEach to print a nice console message
            if (typeof assets == "string") {
                assets = [assets]
            }

            // print a nice console message for every asset in the queue
            // the replace part is to keep compatibility for root apps
            assets.forEach(assetPath => {
                debug.info(assetPath.replace(path.resolve("..", "..", ".."), ""))
            })
        }
    })


    debug.hr()
    //debug.br()
    console.log('')

    
    return webpackConfig
}
