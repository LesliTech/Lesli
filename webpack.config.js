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

@dev      Luis Donis <ldonis@lesli.tech>
@author   LesliTech <hello@lesli.tech>
@license  Propietary - all rights reserved.
@version  GIT: 0.1.0 alpha

// ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
//  · 
*/


//  · Including plugins and dependencies
// ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
var fs = require('fs')
var path = require('path')  
var VueLoaderPlugin = require('vue-loader/lib/plugin')


// ·
var webpackConfig = {
    watch: false,
    mode: "development",
    optimization: { minimize: false },
    performance: { hints: false },
    entry: {"lesli": "./app/vue/apps/lesli.js",},
    output: {
        path: __dirname,
        filename: "app/assets/javascripts/[name].js"
    },
    resolve: {
        alias: {

            // resolve vuejs
            vue: 'vue/dist/vue.js',

            // Resolve alias necessary to load vue components from TheCrow
            LesliCloud: path.resolve(__dirname, './app')

        },
        extensions: [".js"]
    },
    module:{
        rules:[{
            test: /\.vue$/,
            loader: 'vue-loader'
        },{
            test: /\.css$/,
            use: [
                'style-loader', // creates style nodes from JS strings
                'css-loader',   // translates CSS into CommonJS
            ]
        },{
            test: /\.scss$/,
            use: [
                'style-loader', // creates style nodes from JS strings
                'css-loader',   // translates CSS into CommonJS
                {
                    loader: 'sass-loader', // compiles Sass to CSS, using Node Sass by default
                    options: {
                        data: '@import "component.scss";',
                        includePaths: [
                            path.resolve(__dirname, "TheCrow/scss/")
                        ]
                    }
                }
            ]
        }]
    },
    watchOptions: {
        poll: 1000,
        aggregateTimeout: 300,
        ignored: /node_modules/
    },
    plugins:[
        new VueLoaderPlugin()
    ]
}


//  · Load directory apps 
// ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
/*
let directories = fs.readdirSync('./app/vue/apps').filter(file => {

    // get only directories
    if (fs.statSync('./' + file).isDirectory()) {
        return true
    }

    return false

})

directories.forEach(directory => {

    // standard vue startpoint
    let vuepath = './' + path.join(directory, 'vue', directory + '.js')

    // vue app exists?
    if (fs.existsSync(vuepath)) {

        webpackConfig.entry[directory] = vuepath

    }

})
*/


// ·
module.exports = webpackConfig
