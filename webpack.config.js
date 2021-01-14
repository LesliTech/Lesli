/**
Copyright (c) 2020, all rights reserved.

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
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
var fs = require("fs")
var path = require("path")  
var yaml = require("js-yaml")
var webpack = require("webpack")
var TerserPlugin = require("terser-webpack-plugin")
var VueLoaderPlugin = require("vue-loader/lib/plugin")
var webpackConfig = []

// · 
module.exports = env => {

    // set mode
    env.mode = env.mode ? env.mode : "development"
    env.watch = env.watch ? env.watch : false

    // set mode boolean
    var production = env.mode == "production" ? true : false

    // · 
    var webpackbase = {
        watch: env.watch == "true",
        mode: production ? "production" : "development",
        performance: { hints: false },
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
        entry: {
            "accounts/app": "./app/vue/accounts/app.js",
            "account/integrations_app": "./app/vue/account_integrations/app.js",
            "users/app": "./app/vue/users/app.js",
            "roles/app": "./app/vue/roles/app.js",            
            "abouts/app": "./app/vue/abouts/app.js",
            "users/sessions": "./app/vue/users/sessions.js",
            "users/passwords": "./app/vue/users/passwords.js",
            "users/registrations": "./app/vue/users/registrations.js",
            "errors/app": "./app/vue/errors/app.js",
            "websites/app": "./app/vue/websites/app.js",
            "profiles/app": "./app/vue/profiles/app.js",
            "dashboards/app": "./app/vue/dashboards/app.js",
            "settings/workflows_app": "./app/vue/settings/workflows/app.js"
        },
        output: {
            path: __dirname,
            filename: "app/assets/javascripts/[name].js"
        },
        resolve: {
            alias: {

                // resolve vuejs
                vue: production ? "vue/dist/vue.min.js" : "vue/dist/vue.js",

                // DEPRECATED
                LesliCloud: path.resolve(__dirname, "./app"),           
                LesliCoreVue: path.resolve(__dirname, "./lib/vue"),
                LesliCloudHouse: path.resolve(__dirname, "./engines/cloud_house/app"),
                LesliCloudFocus: path.resolve(__dirname, "./engines/cloud_focus/app"),
                LesliCloudDriver: path.resolve(__dirname, "./engines/cloud_driver/app"),
                LesliDeutscheLeibrenten: path.resolve(__dirname, "./engines/deutsche_leibrenten/app"),


                // Resolve alias for core resources
                Lesli: path.resolve(__dirname, "./app"), 
                LesliVue: path.resolve(__dirname, "./lib/vue"), 
                
                // Resolve alias for module resources
                CloudHouse: path.resolve(__dirname, "./engines/cloud_house/app"),
                CloudFocus: path.resolve(__dirname, "./engines/cloud_focus/app"),
                CloudDriver: path.resolve(__dirname, "./engines/cloud_driver/app"),
                CloudHelp: path.resolve(__dirname, "./engines/cloud_help/app"),
                DeutscheLeibrenten: path.resolve(__dirname, "./engines/deutsche_leibrenten/app")

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
                        /*
                        options: {
                            data: "@import "component.scss";",
                            includePaths: [
                                path.resolve(__dirname, "LesliCloud/scss/")
                            ]
                        }
                        */
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
                leslicloud_app_mode_production: JSON.stringify(production),
                leslicloud_app_mode_development: JSON.stringify(!production)
            })
        ]
        
    }

    webpackConfig.push(webpackbase)

    if (!fs.existsSync("./engines")) {
        return webpackConfig
    }

    // get & parse engine information files (lesli.yml)
    let engines = fs.readdirSync("./engines").filter(directory => directory != ".gitkeep").filter(engine => {

        let engine_info_file_path = `./engines/${engine}/lesli.yml`

        if (!fs.existsSync(engine_info_file_path)) {
            return false
        }

        // load raw file content
        let rawdata = fs.readFileSync(engine_info_file_path)

        // parse file content 
        let engine_info = yaml.load(rawdata)

        // update company name in global variable
        if (engine_info.info.type && engine_info.info.type == "builder") {
            webpackConfig[0].plugins[1].definitions.leslicloud_app_info = JSON.stringify(engine_info.info)
            webpackConfig[0].plugins[1].definitions.leslicloud_app_company = JSON.stringify(engine_info.account.company)
        }

        if (engine_info.info.load == false) {
            return false
        }

        return engine_info.info.code == engine

    })

    engines.forEach(engine => {

        let webpackEngine = Object.assign({}, webpackbase)
        webpackEngine.output = Object.assign({}, webpackbase.output)

        // remove entries from previous engine
        webpackEngine.output.filename = ""
        webpackEngine.entry = {}
        
        // if engine is not a dir
        if ([".gitkeep"].includes(engine)) {
            return
        }

        // check if vue folder exists for given engine
        if (!fs.existsSync(path.join("./engines", engine, "app", "vue"))) {
            return
        }

        // get app directories
        fs.readdirSync(path.join("./engines", engine, "app", "vue")).forEach(app => {

            fs.readdirSync(path.join("./engines", engine, "app", "vue", app)).forEach(action => {

                if (!action.endsWith(".js")) {
                    return
                }

                let filePath = "./"+path.join("./engines", engine, "app", "vue", app, action)
                let fileName = [app, action.replace(".js","")].join("_")

                webpackEngine.entry[fileName] = filePath

            })

        })
        
        if (Object.keys(webpackEngine.entry).length > 0) {

            // javascripts engine folder
            let javascripts_engine_folder = engine.replace(/[\w]([A-Z])/g, m => { return [m[0], m[1]].join("_") })
            javascripts_engine_folder = javascripts_engine_folder.toLowerCase()

            // set new output to engine app folder
            webpackEngine.output.filename = `./engines/${engine}/app/assets/javascripts/${javascripts_engine_folder}/[name].js`

            // Configuration object for every engine
            webpackConfig.push(webpackEngine)

        }

        update_software_version(engine, env)

    })


    // · Update compilation version for frontend and backend
    // · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
    function update_software_version(engine, env) {

        // do not change if development
        if (env.mode != "production") {
            return 
        }

        //let engine_info = JSON.parse(webpackConfig[0].plugins[1].definitions.leslicloud_app_info)
        let engine_version_file = `./engines/${engine}/lib/${engine}/version.rb`

        fs.readFile(engine_version_file, "utf8", (err, data) => {

            if (err) {
                return console.log(err)
            }

            data = data.split("\n")

            var date = new Date()

            var build_date = `${date.getFullYear().toString().substr(2, 2)}.${date.getMonth()+1}.${date.getDate()}`
            var build_time = date.getHours().toString().concat(".").concat(date.getMinutes().toString())

            data[2] = `BUILD = \"${build_date}-${build_time}\"`

            fs.writeFile(engine_version_file, data.join("\n"), "utf8", function (err) {
                if (err) return console.log(err)
            })

        })

    }

    return webpackConfig

}
