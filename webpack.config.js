"use strict"
/*

Copyright (c) 2022, all rights reserved.

All the information provided by this platform is protected by international laws related  to 
industrial property, intellectual property, copyright and relative international laws. 
All intellectual or industrial property rights of the code, texts, trade mark, design, 
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

*/


// · Including plugins and dependencies
var fs = require("fs")
var path = require("path")
var yaml = require("js-yaml")
var webpack = require("webpack")
var debug = require("lesli-js/debug/nodejs")
var TerserPlugin = require("terser-webpack-plugin")
var { VueLoaderPlugin } = require("vue-loader")


// · set the path to the engines folder
const pathEngines = path.resolve("engines")

// get specific modules to work with, example: npm run webpack -- babel bell
const requestedModules = process.argv.slice(5)

var webpackConfig = []

// · 
module.exports = env => {


    // set mode
    env.mode = env.mode ? env.mode : "development"
    env.watch = env.watch ? env.watch : false


    // set production boolean
    var production = env.mode == "production" ? true : false


    // Base webpack configuration, this includes only core assets
    var configCore = {

        watch: env.watch == "true",
        mode: production ? "production" : "development",

        stats: {
            all: false,
            assets: true,
            assetsSort: '!size',
            env: true,
            errors: true,
            errorDetails: true,
            errorsCount: true,
            warnings: true,
        },

        // Use a custom plugin to remove all the comments
        // from the javascript files
        optimization: {
            minimize: production,
            minimizer: [
                new TerserPlugin({
                    terserOptions: {
                        format: {
                            comments: false,
                        },
                    },
                    extractComments: false,
                    parallel: true
                })
            ]
        },


        // Defined the core apps as main entry apps
        // engine javascript apps are defined dynamically
        entry: {
            
            "users/sessions": "Lesli/vue3/users/sessions.js",
            "users/passwords": "Lesli/vue3/users/passwords.js",
            "users/registrations": "Lesli/vue3/users/registrations.js",

            "mfas/application": "Lesli/vue3/mfas/app.js",
            "otps/application": "Lesli/vue3/otps/app.js",
            "passes/application": "Lesli/vue3/passes/app.js",
            "invites/application": "Lesli/vue3/invites/app.js",

            "onboardings/application": "Lesli/vue3/onboarding/app.js",
            
            "administration/application": "Lesli/vue3/administration/app.js"

        },


        // Set the name of the compiled javascript files
        output: {
            path: path.resolve("app", "assets", "javascripts"),
            filename: "[name].js"
        },


        // resolvers & path alias
        resolve: {

            // include folder so we can import direct from node modules
            modules: [path.resolve("node_modules")],
            alias: {

                vue: "vue/dist/vue.esm-bundler.js",

                // Set aliases as shortcuts to import modules
                Lesli: path.resolve("app"),
                LesliVue: path.resolve("lib", "vue3"), 

                LesliCore: path.resolve("app", "vue3"),
                CloudBell: path.resolve("engines", "cloud_bell", "app", "vue3"),
                CloudTalk: path.resolve("engines", "cloud_talk", "app", "vue3"),
                CloudAudit: path.resolve("engines", "cloud_audit", "app", "vue3"),
                CloudBabel: path.resolve("engines", "cloud_babel", "app", "vue3"),
                CloudDriver: path.resolve("engines", "cloud_driver", "app", "vue3"),
                CloudDevelopment: path.resolve("engines", "cloud_development", "app", "vue3"),

                MitwerkenCloud: path.resolve("engines", "mitwerken_cloud", "app", "vue3"),

            }
        },
        module: {
            rules: [{
                test: /\.vue$/,
                use: "vue-loader"
            }, {
                test: /\.css$/,
                use: [
                    "style-loader", // creates style nodes from JS strings
                    "css-loader",   // translates CSS into CommonJS
                ]
            }, {
                test: /\.m?js$/,
                exclude: /(node_modules)/,
                use: {
                    loader: "babel-loader",
                    options: {
                        presets: [["@babel/preset-env", { "targets": "defaults" }]]
                    }
                }
            }]
        },
        plugins: [
            new VueLoaderPlugin(),

            // custom constants
            new webpack.DefinePlugin({
                lesli_app_mode_production: JSON.stringify(production),
                lesli_app_mode_development: JSON.stringify(!production),
                __VUE_OPTIONS_API__: true,
                __VUE_PROD_DEVTOOLS__: true,
            })
        ]

    }


    // push webpack configuration for core app
    webpackConfig.push(configCore)


    // exit configuration builder if no engines installed
    if (!fs.existsSync(pathEngines)) { return webpackConfig; }


    // get the installed engines
    let engines = fs.readdirSync(pathEngines);

    // remove the keep file from the engines directory
    engines = engines.filter(directory => directory != ".gitkeep")

    // filter found engines to get only the ones that are ready to work with vue3
    engines = engines.filter(engine => {

        // get and parse engine information files (lesli.yml)
        let lesliConfigPath = path.resolve(pathEngines, engine, "lesli.yml")

        // exit if lesli.yml does not exists
        if (!fs.existsSync(lesliConfigPath)) { return false }

        // load LesliConfig
        let lesliConfig = yaml.load(fs.readFileSync(lesliConfigPath))

        // exit if engine does not have to be loaded
        if (lesliConfig.info.load == false) { return false }

        // build engine code from engine name
        lesliConfig.info["code"] = lesliConfig.info["name"].split(/(?=[A-Z])/).join('_').toLowerCase()

        // check if user sent specific modules to work with through "webpack -- engine1 engine2 etc.."
        if (requestedModules.length > 0) {

            // check if current engine belongs to the list of desire engines
            if (!requestedModules.includes(lesliConfig.info.code.replace("cloud_", ""))) {

                // if the engine to exclude is not a builder
                if (lesliConfig.info.type != "builder") {
                    return false
                }

            }

        }

        // check if vue folder exists for given engine
        if (!fs.existsSync(path.resolve(pathEngines, engine, "app", "vue3"))) {
            return
        }

        // include engine into the collections of active engines
        return lesliConfig.info.code == engine

    })


    engines.forEach(engine => {

        // clone webpack core configuration (shallow copy) 
        let configEngine = Object.assign({}, configCore)

        // ensure to clone output configuration (shallow copy) 
        configEngine.output = Object.assign({}, configCore.output)

        // remove config used for core, so we can add specific configuration for the engines
        configEngine.output.path = path.resolve(pathEngines, engine, "app", "assets", "javascripts")
        configEngine.entry = {}

        // path to the vue app main mount file
        var appPath = path.resolve(pathEngines, engine, "app", "vue3", "app.js")

        // stop process if vue3 app does not exists
        if (!fs.existsSync(appPath)) { return; }

        // add vue3 apps found into the webpack compilation pipeline
        configEngine.entry[(`${engine}/application`)] = appPath

        // set new output to engine app folder
        configEngine.output.filename = "[name].js"

        // check if the engine has vue3 apps to compile
        if (Object.keys(configEngine.entry).length <= 0) { return }

        // push the engine configuration to the webpack config
        webpackConfig.push(configEngine)

    })


    // show a nice debug message :) 
    webpackConfig.forEach(config => {
        for (let [name, path] of Object.entries(config.entry)) {
            debug.info(path.replace(pathEngines, ""))
        }
    })


    return webpackConfig

}
