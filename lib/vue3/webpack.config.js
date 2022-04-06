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
var path = require("path")
var webpack = require("webpack")
var { VueLoaderPlugin } = require("vue-loader")


// · 
module.exports = env => {


    // get specific modules to work with, example: npm run webpack -- babel bell
    var requested_modules = process.argv.slice(5)


    // set mode
    env.mode = env.mode ? env.mode : "development"
    env.watch = env.watch ? env.watch : false


    // set production boolean
    var production = env.mode == "production" ? true : false


    // Base webpack configuration, this includes only core assets
    var config = {

        watch: env.watch == "true",
        mode: production ? "production" : "development",
        entry: {
            "invites/application": "Lesli/vue3/invites/app.js",
        },
        output: {
            path: __dirname,
            filename: "../../app/assets/javascripts/[name].js"
        },
        resolve: {
            modules: [path.resolve(__dirname, "node_modules")],
            alias: {

                vue: "vue/dist/vue.esm-bundler.js",

                // Resolve alias for core resources
                Lesli: path.resolve(__dirname, "../../app"),
                LesliVue: path.resolve(__dirname, "./vue"),

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
                test: /\.scss$/,
                use: [
                    "style-loader", // creates style nodes from JS strings
                    "css-loader",   // translates CSS into CommonJS
                    {
                        loader: "sass-loader", // compiles Sass to CSS, using Node Sass by default
                    }
                ]
            }]
        },
        plugins: [
            new VueLoaderPlugin(),
            new webpack.DefinePlugin({
                lesli_app_mode_production: JSON.stringify(production),
                lesli_app_mode_development: JSON.stringify(!production)
            })
        ]

    }

    return config

}
