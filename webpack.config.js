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
@version  0.1.0-alpha

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/


// · Including plugins and dependencies
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
var fs = require('fs')
var path = require('path')  
var VueLoaderPlugin = require('vue-loader/lib/plugin')

var webpackConfig = []

// · 
var webpackbase = {
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

webpackConfig.push(webpackbase)

// · get engines
fs.readdirSync('./engines').forEach(engine => {

    let webpackEngine = Object.assign({}, webpackbase)
    webpackEngine.output = Object.assign({}, webpackbase.output)
    webpackEngine.output.filename = "app/assets/javascripts/apps/[name].js"
    webpackEngine.entry = {}

    // remove entries from previous engine
    webpackEngine.entry = {}
    webpackEngine.output.filename = ""
    
    // if engine is not a dir
    if (['.gitkeep'].includes(engine)) {
        return
    }

    // get app directories
    fs.readdirSync(path.join('./engines', engine, 'app', 'vue')).forEach(app => {

        // get app files
        fs.readdirSync(path.join('./engines', engine, 'app', 'vue', app)).forEach(file => {

            let filePath = './'+path.join('./engines', engine, 'app', 'vue', app, file)
            let fileName = [app, file].join('-').replace('.js','')

            webpackEngine.entry[fileName] = filePath

        })

    })
    
    if (Object.keys(webpackEngine.entry).length > 0) {

        // javascripts engine folder
        let javascripts_engine_folder = engine.replace(/[\w]([A-Z])/g, function(m) { return m[0] + "_" + m[1]; })
        javascripts_engine_folder = javascripts_engine_folder.toLowerCase()

        // set new output to engine app folder
        webpackEngine.output.filename = `./engines/${engine}/app/assets/javascripts/${javascripts_engine_folder}/apps/[name].js`

        // Configuration object for every engine
        webpackConfig.push(webpackEngine)

    }

})

// · 
module.exports = webpackConfig
