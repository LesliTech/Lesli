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
var path = require("path")
var dayjs = require("dayjs")
var webpack = require("webpack")
var TerserPlugin = require("terser-webpack-plugin")
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const RemoveEmptyScriptsPlugin = require('webpack-remove-empty-scripts');


// · 
module.exports = env => ({

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


    // Set max size limit for JS bundles to 1.5 MiB
    performance: {
        maxAssetSize: 1572864,
        maxEntrypointSize: 1572864
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

            // Set aliases as shortcuts to import core modules
            Lesli: path.resolve("lib"), 
            LesliVue: path.resolve("lib", "vue"), 
            LesliStyle: path.resolve("lib", "scss"), 

            // Set aliases as shortcuts to import engine modules
            LesliBell: path.resolve("../", "LesliBell", "lib"),
            LesliAdmin: path.resolve("../", "LesliAdmin", "lib"),
            LesliAudit: path.resolve("../", "LesliAudit", "lib"),
            LesliBabel: path.resolve("../", "LesliBabel", "lib"),
            LesliShield: path.resolve("../", "LesliShield", "lib"),
            LesliLetter: path.resolve("../", "LesliLetter", "lib"),
            LesliSupport: path.resolve("../", "LesliSupport", "lib"),
            LesliSecurity: path.resolve("../", "LesliSecurity", "lib"),
            LesliCalendar: path.resolve("../", "LesliCalendar", "lib"),
            LesliDashboard: path.resolve("../", "LesliDashboard", "lib"),

            LesliView: path.resolve("../", "LesliView", "lib", "lesli_view"),

            // Set aliases as shortcuts to import root modules
            Root: path.resolve("../", "../", "lib")
        }
    },
    module: {
        rules: [{
            test: /\.(scss)$/,
            use: [
                MiniCssExtractPlugin.loader, 
                {
                    loader:'css-loader',
                    options: { url: false } 
                }, 
                'sass-loader' // required to compile sass files with webpack
            ]
        }]
    },
    plugins: [
        new RemoveEmptyScriptsPlugin(),

        new MiniCssExtractPlugin({
            filename: 'stylesheets/[name].css'
        }),

        // custom constants
        new webpack.DefinePlugin({
            lesli_application_production: JSON.stringify(env.production),
            lesli_application_development: JSON.stringify(!env.production),
            lesli_application_version: JSON.stringify(dayjs().format("YYMMDD.HHmm")),
            __VUE_OPTIONS_API__: true,
            __VUE_PROD_DEVTOOLS__: false,
            __VUE_PROD_HYDRATION_MISMATCH_DETAILS__: false
        })
    ]
})
