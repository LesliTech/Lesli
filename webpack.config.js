/*
Lesli

Copyright (c) 2019, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

LesliCloud - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@author   LesliTech <hello@lesli.tech>
@license  Propietary - all rights reserved.
@version  0.1.0-alpha

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/


// · Including plugins and dependencies
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
var fs = require('fs')
var path = require('path')  
var webpack = require("webpack")
var TerserPlugin = require('terser-webpack-plugin')
var VueLoaderPlugin = require('vue-loader/lib/plugin')
var webpackConfig = []

function webpackConfigBuilder(compilationMode) {

    var production = compilationMode == "production" ? true : false

    // · 
    var webpackbase = {
        watch: !production,
        mode: production ? "production" : "production",
        performance: { hints: false },
        optimization: !production ? { minimize: false } :  {
            minimizer: [
                new TerserPlugin({
                    terserOptions: {
                        output: {
                            comments: false
                        }
                    }
                })
            ]
        },
        entry: {
            "accounts_new": "./app/vue/accounts/new.js",
            "websites_landing": "./app/vue/websites/landing.js",
            "users/sessions_new": "./app/vue/users/sessions_new.js",
            "users/passwords_new": "./app/vue/users/passwords_new.js",
            "users/passwords_edit": "./app/vue/users/passwords_edit.js",
            "users/registrations_new": "./app/vue/users/registrations_new.js",
            "users/confirmations_new": "./app/vue/users/confirmations_new.js",
            "dashboards/empty": "./app/vue/dashboards/empty.js"
        },
        output: {
            path: __dirname,
            filename: "app/assets/javascripts/[name].js"
        },
        resolve: {
            alias: {

                // resolve vuejs
                vue: production ? 'vue/dist/vue.min.js' : 'vue/dist/vue.js',

                // Resolve alias necessary to load vue components from LesliCloud
                LesliCloud: path.resolve(__dirname, './app'),
                CloudDriver:  path.resolve(__dirname, './engines/CloudDriver/app')

            },
            extensions: [".js"]
        },

        module: {

            rules:[{
                test: /\.vue$/,
                loader: 'vue-loader'
            }, {
                test: /\.css$/,
                use: [
                    'style-loader', // creates style nodes from JS strings
                    'css-loader',   // translates CSS into CommonJS
                ]
            }, {
                test: /\.scss$/,
                use: [
                    'style-loader', // creates style nodes from JS strings
                    'css-loader',   // translates CSS into CommonJS
                    {
                        loader: 'sass-loader', // compiles Sass to CSS, using Node Sass by default
                        options: {
                            data: '@import "component.scss";',
                            includePaths: [
                                path.resolve(__dirname, "LesliCloud/scss/")
                            ]
                        }
                    }
                ]
            }, {
                test: /\.m?js$/,
                exclude: /(node_modules|bower_components)/,
                use: {
                    loader: 'babel-loader',
                    options: {
                        presets: ['@babel/preset-env']
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

    // · get engines
    fs.readdirSync('./engines').forEach(engine => {

        let webpackEngine = Object.assign({}, webpackbase)
        webpackEngine.output = Object.assign({}, webpackbase.output)

        // remove entries from previous engine
        webpackEngine.output.filename = ""
        webpackEngine.entry = {}
        
        // if engine is not a dir
        if (['.gitkeep'].includes(engine)) {
            return
        }

        // check if vue folder exists for given engine
        if (!fs.existsSync(path.join('./engines', engine, 'app', 'vue'))) {
            return
        }

        // get app directories
        fs.readdirSync(path.join('./engines', engine, 'app', 'vue')).forEach(app => {

            fs.readdirSync(path.join('./engines', engine, 'app', 'vue', app)).forEach(action => {

                if (!action.endsWith('.js')) {
                    return
                }

                let filePath = './'+path.join('./engines', engine, 'app', 'vue', app, action)
                let fileName = [app, action.replace('.js','')].join('_')

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

    })

    return webpackConfig

}

// · 
module.exports = webpackConfigBuilder
