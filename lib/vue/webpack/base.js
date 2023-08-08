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

Lesli · Ruby on Rails Development Platform.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/


// · Including plugins and dependencies
var path = require("path")
var dayjs = require("dayjs")
var webpack = require("webpack")
var TerserPlugin = require("terser-webpack-plugin")
var { VueLoaderPlugin } = require("vue-loader")


// · 
module.exports = env => {

    return {

        watch: env.watch == "true",
        mode: env.production ? "production" : "development",


        // Show only necessary stats when compiling
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
    

        // Set max size limit for JS bundles to 0.98 MB
        performance: {
            maxAssetSize: 1100000,
            maxEntrypointSize: 1100000,
            assetFilter: function(assetFilename) {
                return !(['cloud_development/application.js'].includes(assetFilename));
            }
        },
    
        
        // Use a custom plugin to remove all the comments
        // from the javascript files
        optimization: {
            minimize: env.production,
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
        entry: { },
    
    
        // Set the name of the compiled javascript files
        output: {
            path: "",
            filename: "[name].js"
        },
    
    
        // resolvers & path alias
        resolve: {
    
            // include folder so we can import direct from node modules
            modules: [path.resolve("node_modules")],
            alias: {
    
                vue: "vue/dist/vue.esm-bundler.js",
    
                // Set aliases as shortcuts to import modules
                Lesli: path.resolve("lib", "vue"), 
                LesliApp: path.resolve("app", "vue"),
    
                CloudAdmin: path.resolve("app", "vue", "administration"),
                CloudBell: path.resolve("engines", "cloud_bell", "lib", "vue"),
                CloudTalk: path.resolve("engines", "cloud_talk", "lib", "vue"),
                CloudTeam: path.resolve("engines", "cloud_team", "lib", "vue"),
                CloudTime: path.resolve("engines", "cloud_time", "lib", "vue"),
                CloudHelp: path.resolve("engines", "cloud_help", "lib", "vue"),
                CloudWork: path.resolve("engines", "cloud_work", "lib", "vue"),
                CloudAudit: path.resolve("engines", "cloud_audit", "lib", "vue"),
                CloudBabel: path.resolve("engines", "cloud_babel", "lib", "vue"),
                CloudFocus: path.resolve("engines", "cloud_focus", "lib", "vue"),
                CloudMailer: path.resolve("engines", "cloud_mailer", "lib", "vue"),
                CloudDriver: path.resolve("engines", "cloud_driver", "lib", "vue"),
                CloudSocial: path.resolve("engines", "cloud_social", "lib", "vue"),
                CloudShared: path.resolve("engines", "cloud_shared", "lib", "vue"),
                CloudScraper: path.resolve("engines", "cloud_scraper", "lib", "vue"),
                CloudAuthority: path.resolve("engines", "cloud_authority", "lib", "vue"),

                LesliBuilder: path.resolve("engines", "lesli_builder", "lib", "vue")
            }
        },
        module: {
            rules: [{
                test: /\.vue$/,
                use: {
                    loader: "vue-loader",
                    options: {
                        compilerOptions: {
                            // ignore custom html components & elements
                            isCustomElement: tag => tag === 'trix-editor'
                        }
                    }
                }
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
                lesli_application_production: JSON.stringify(env.production),
                lesli_application_development: JSON.stringify(!env.production),
                lesli_application_version: JSON.stringify(dayjs().format("YYMMDD.HHmm")),
                __VUE_OPTIONS_API__: true,
                __VUE_PROD_DEVTOOLS__: true
            })
        ]
    }
}
