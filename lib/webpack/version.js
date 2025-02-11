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


// · 
const fs = require("fs")
const dayjs = require("dayjs")
const advancedFormat = require("dayjs/plugin/advancedFormat")

// · 
dayjs.extend(advancedFormat)


// · Update compilation version for frontend and backend
module.exports = (env, engine) => {
        
    // do not change if development
    if (env.mode != "production") {
        return 
    }


    // set the path to the engine version file by default
    let engine_version_file = `../../engines/${engine.dir}/lib/${engine.code}/version.rb`


    // 
    fs.readFile(engine_version_file, "utf8", (err, data) => {

        if (err) {
            return console.log(err)
        }

        // Unix Timestamp in second
        let build = dayjs().format("X")

        data = data.split("\n")
        data[2] = `  BUILD = "${build}\"`

        fs.writeFile(engine_version_file, data.join("\n"), "utf8", function (err) {
            if (err) return console.log(err)
        })

        console.log(`update version of: ${engine.dir}, to: ${build}`)

    })
}
