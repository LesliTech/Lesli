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

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/


// · Including plugins and dependencies
var fs = require("fs")
var path = require("path")
var yaml = require("js-yaml")


// · set the path to the engines folder
const pathEngines = path.resolve("../")


// · Get and validate engines
function installedEngines(requestedEngines) {

    // exit configuration builder if no engines installed
    if (!fs.existsSync(pathEngines)) { return []; }


    // get the installed engines
    let engines = fs.readdirSync(pathEngines);


    // remove the keep file from the engines directory
    engines = engines.filter(directory => directory != ".gitkeep")


    // filter found engines to get only the ones that are ready to work with vue
    engines = engines.map(engine => {

        if (engine === "Lesli") { return }

        // Get engine code from engine folder name
        const engine_code = engine.replace(/([a-z])([A-Z])/g, '$1_$2').toLowerCase()

        // Get engine code from engine folder name
        const engine_name = engine.replace(/([a-z])([A-Z])/g, '$1 $2')

        // check if valid Rails Engine
        let lesliConfigPath = path.resolve(pathEngines, engine, `${ engine_code }.gemspec`)

        // exit if rails_engine.gemspec does not exists
        if (!fs.existsSync(lesliConfigPath)) { return }

        // check if user sent specific modules to work with through "webpack -- engine1 engine2 etc.."
        if (requestedEngines.length > 0) {

            // check if current engine belongs to the list of desire engines
            if (!requestedEngines.includes(engine_code)) {

                return

            }

        }


        // check if vue folder exists for given engine
        if (!fs.existsSync(path.resolve(pathEngines, engine, "lib", "vue"))) {
            return 
        }

        // include engine into the collections of active engines
        return {
            code: engine_code,
            name: engine_name,
            dir: engine
        }

    }).filter(item => item !== undefined);

    return engines

}


// · 
module.exports = (env, requestedEngines) => {

    var entries = []

    var engines = installedEngines(requestedEngines)

    engines.forEach(engine => {

        var config = {
            entry: {},
            output: {
                path: path.resolve(pathEngines, engine.dir, "app", "assets", "javascripts")
            }
        }


        // scan the vue folder to get all the vue apps
        const vueFolder = path.resolve(pathEngines, engine.dir, "lib", "vue")


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
            config.entry[(`${engine.code}/${appname}`)] = `${engine.dir}/${appname}`

        })


        // check if the engine has vue apps to compile
        if (Object.keys(config.entry).length <= 0) { return }


        entries.push({ code: engine.dir, config })

    })

    return entries

}
