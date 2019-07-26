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
var gulp = require('gulp')
var webpack = require('webpack')
var babel = require('gulp-babel')
var rename = require('gulp-rename')
var webpackConfig = require('./webpack.config.js')


//  · Compiling vue app
// ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
gulp.task('vue', () => {

    // source files
    let sourceFiles = [
        './**/assets/js/*.js', 
        '!./**/assets/js/*.min.js',
        '!./**/assets/js/*.babel.js',
        '!./node_modules/**',
        '!./Template/**',
        '!./crow/**'
    ]

    // webpack settings for production
    webpackConfig.watch = false
    webpackConfig.mode = "production"

    // compile javascript app
    webpack(webpackConfig, () => {

        // Compile JS to lower version
        let task = gulp
        .src(sourceFiles)
        .pipe(babel({"presets":["es2015"],compact:false}))
        .pipe(gulp.dest('./'))

    })

    // production
    if (lesliConfig.live) {

        webpackConfig.resolve.alias.vue = 'vue/dist/vue.min.js'
        webpackConfig.optimization.minimize = true

        // compile javascript for production
        webpack(webpackConfig, () => {

            let suffix = ('.' + lesliConfig.website.version + '.min')

            // Compile JS to lower version
            let task = gulp
            .src(sourceFiles)
            .pipe(babel({"presets":["es2015"],comments:false,compact:true}))
            .pipe(rename({ suffix: suffix }))
            .pipe(gulp.dest('./'))

        })

    }

})


//  · Build frontend
// ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
gulp.task('frontend', ['vue'])

