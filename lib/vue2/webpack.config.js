/*

Copyright (c) 2021, all rights reserved.

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
var dayjs = require("dayjs")
var debug = require("lesli-js/debug-browser")
var webpack = require("webpack")
var TerserPlugin = require("terser-webpack-plugin")
var VueLoaderPlugin = require("vue-loader/lib/plugin")
var webpackConfig = []



// ·
module.exports = env => {


    // get specific modules to work with, example: npm run webpack -- babel bell
    var requested_modules = process.argv.slice(5)


    // set mode
    env.mode = env.mode ? env.mode : "development"
    env.watch = env.watch ? env.watch : false


    // set production boolean
    var production = env.mode == "production" ? true : false


    // default webpack configuration
    // IMPORTANT: engines will duplicate this configuration to compile their own vue apps
    var webpackbase = {
        watch: env.watch == "true",
        mode: production ? "production" : "development",
        performance: { hints: false },
        optimization: {
            minimize: false
        },
        entry: {

            "accounts/application": "../../app/vue2/accounts/app.js",
            "account/cronos_application": "../../app/vue2/account_cronos/app.js",
            "account/settings_application": "../../app/vue2/account_settings/app.js",
            "account/currencies_application": "../../app/vue2/account_currencies/app.js",
            "account/integrations_application": "../../app/vue2/account_integrations/app.js",
            "account/currency_exchange_rates_application": "../../app/vue2/account_exchange_rates/app.js",

            "dashboards/application": "../../app/vue2/dashboards/app.js",
            "profiles/application": "../../app/vue2/profiles/app.js",
            "websites/application": "../../app/vue2/websites/app.js",
            "abouts/application": "../../app/vue2/abouts/app.js",
            "users/application": "../../app/vue2/users/app.js",
            "roles/application": "../../app/vue2/roles/app.js",
            "role_descriptors/application": "../../app/vue2/role_descriptors/app.js",

            "invites/application": "../../app/vue2/invites/app.js",
            "passes/application": "../../app/vue2/passes/app.js",
            "otps/application": "../../app/vue2/otps/app.js",

            "users/sessions": "../../app/vue2/users/sessions.js",
            "users/passwords": "../../app/vue2/users/passwords.js",
            "users/registrations": "../../app/vue2/users/registrations.js",
            "users/confirmations": "../../app/vue2/users/confirmations.js",
            "onboardings/application": "../../app/vue2/onboardings/app.js",

            "errors/application": "../../app/vue2/errors/app.js"

        },
        output: {
            path: __dirname,
            filename: "../../app/assets/javascripts/[name].js"
        },
        resolve: {
            modules: [path.resolve(__dirname, 'node_modules')],
            alias: {

                // resolve vuejs
                vue: production ? "vue/dist/vue.min.js" : "vue/dist/vue.js",

                // DEPRECATED
                LesliCloud: path.resolve(__dirname, "./app"),
                LesliCoreVue: path.resolve(__dirname, "./vue"),
                LesliCloudHouse: path.resolve(__dirname, "./engines/cloud_house/app"),
                LesliCloudFocus: path.resolve(__dirname, "./engines/cloud_focus/app"),
                LesliCloudDriver: path.resolve(__dirname, "./engines/cloud_driver/app"),
                LesliDeutscheLeibrenten: path.resolve(__dirname, "./engines/deutsche_leibrenten/app"),


                // Resolve alias for core resources
                Lesli: path.resolve(__dirname, "../../app"),
                LesliVue: path.resolve(__dirname, "./vue"),
                LesliWidgets: path.resolve(__dirname, "./widgets"),


                // Resolve alias for module resources
                CloudWork: path.resolve(__dirname, "../../engines/cloud_work/app"),
                CloudHelp: path.resolve(__dirname, "../../engines/cloud_help/app"),
                CloudHouse: path.resolve(__dirname, "../../engines/cloud_house/app"),
                CloudFocus: path.resolve(__dirname, "../../engines/cloud_focus/app"),
                CloudDriver: path.resolve(__dirname, "../../engines/cloud_driver/app"),
                CloudStorage: path.resolve(__dirname, "../../engines/cloud_storage/app"),
                DeutscheLeibrenten: path.resolve(__dirname, "../../engines/deutsche_leibrenten/app")

            },
            extensions: [".js"]
        },

        module: {

            rules:[{
                test: /\.vue$/,
                loader: "vue-loader"
            }, {
                test: /\.css$/,
                use: [
                    "style-loader", // creates style nodes from JS strings
                    "css-loader",   // translates CSS into CommonJS
                ]
            }, {
                test: /\.scss$/,
                use: [
                    "style-loader", // creates style nodes from JS strings
                    "css-loader",   // translates CSS into CommonJS
                    {
                        loader: "sass-loader", // compiles Sass to CSS, using Node Sass by default
                    }
                ]
            }, {
                test: /\.m?js$/,
                exclude: /(node_modules|bower_components)/,
                use: {
                    loader: "babel-loader",
                    options: {
                        presets: [["@babel/preset-env", { "targets": "defaults" }]]
                    }
                }
            }]

        },

        watchOptions: {
            poll: 1000,
            aggregateTimeout: 300,
            ignored: /node_modules/
        },

        plugins: [
            new VueLoaderPlugin(),
            new webpack.DefinePlugin({
                lesli_app_mode_production: JSON.stringify(production),
                lesli_app_mode_development: JSON.stringify(!production),
                lesli_app_compilation: JSON.stringify(
                    `[BUILD] (core) ${dayjs().format("YYMMDD.HHmm").toString()} `
                )
            })
        ]

    }


    // push webpack configuration for core app
    webpackConfig.push(webpackbase)


    // exit configuration builder if no engines installed
    if (!fs.existsSync("../../engines")) { return webpackConfig; }

    
    // iterate over installed engines (only folders)
    let engines = fs.readdirSync("../../engines")
    .filter(directory => directory != ".gitkeep")
    .filter(engine => {

        // get and parse engine information files (lesli.yml)
        let engine_info_file_path = `../../engines/${engine}/lesli.yml`

        // exit configuration builder if no lesli.yml found
        if (!fs.existsSync(engine_info_file_path)) { return false }

        // load raw file content
        let rawdata = fs.readFileSync(engine_info_file_path)

        // parse file content
        let engine_info = yaml.load(rawdata)

        // exit configuration builder if engine is not setted to load
        if (engine_info.info.load == false) { return false }

        // build engine code from engine name
        engine_info.info["code"] = engine_info.info["name"].split(/(?=[A-Z])/).join('_').toLowerCase()

        // check if user sent specific modules to work with
        if (requested_modules.length > 0) {

            // check if current engine belongs to the list of desire engines
            if (!requested_modules.includes(engine_info.info.code.replace("cloud_", ""))) {

                // if the engine to exclude is not a builder
                if (engine_info.info.type != "builder") {
                    return false
                }

            }

        }

        // check if vue folder exists for given engine
        if (!fs.existsSync(path.join("../../engines", engine, "app", "vue2"))) {
            return
        }

        // include engine into the collections of active engines
        return engine_info.info.code == engine

    })


    // Build webpack configuration for every installed engine
    engines.forEach(engine => {

        // clone webpack base configuration (shallow copy) 
        let webpackEngine = Object.assign({}, webpackbase)

        // ensure to clone output configuration (shallow copy) 
        webpackEngine.output = Object.assign({}, webpackbase.output)

        //
        let bm = `[BUILD] (${engine}) ${dayjs().format("YYMMDD.HHmm").toString()} `
        webpackEngine.plugins[1].definitions.lesli_app_compilation = JSON.stringify(bm)

        // remove entry files from previous engine
        webpackEngine.output.path = path.resolve(__dirname, `../../engines/${engine}/app/assets/javascripts`)
        webpackEngine.output.filename = ""
        webpackEngine.entry = {}

        let filePath = "./"+path.join("../../engines", engine, "app", "vue2", "app.js")
        let fileName = "application"

        if (!fs.existsSync(filePath)) {
            return
        }

        webpackEngine.entry[fileName] = filePath

        if (Object.keys(webpackEngine.entry).length > 0) {

            // javascripts engine folder
            let javascripts_engine_folder = engine.replace(/[\w]([A-Z])/g, m => { return [m[0], m[1]].join("_") })
            javascripts_engine_folder = javascripts_engine_folder.toLowerCase()

            // set new output to engine app folder
            webpackEngine.output.filename = `${javascripts_engine_folder}/[name].js`

            // Configuration object for every engine
            webpackConfig.push(webpackEngine)

        }

    })

    return webpackConfig

}
