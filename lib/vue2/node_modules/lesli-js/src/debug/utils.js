/*
Lesli

Copyright (c) 2021, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.

Lesli JS - JavaScript utilities for JavaScript applications

Powered by LesliTech
Building a better future, one line of code at a time.

@contact  <hello@lesli.tech>
@website  <https://lesli.tech>
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/


var dayjs = require("dayjs")


// · 
class Utils {

    // · 
    buildDate() {

        return dayjs().format("MM/DD HH:mm").toString()

    }

    // · 
    buildMessage(message, module, level) {

        // desire output format
        // [2010-01-17 11:43:37] [ERROR] (cheese module) - Cheese is too ripe!
        // [2010-01-17 11:43:37] [FATAL] (cheese module) - Cheese was breeding ground for listeria.
        let newMessage = `[${this.buildDate()}] [${level.toUpperCase()}]`

        if (module) {
            newMessage += ` (${module})`
        }

        newMessage = newMessage.concat(" - ").concat(message)

        return newMessage

    }

    // · 
    stylesForBrowser(type) {

        let lineheight="1.5;"
        let fontsize="14px;"
        let padding="2px;"

        let info = "background-color:#3498db;color:#ffffff;"
        let warn = "background-color:#f1c40f;color:#000000;"
        let error = "background-color:#e74c3c;color:#ffffff;"
        let fatal = "background-color:#c0392b;color:#fff394;"

        let style = ""

        switch (type) {
            case "info": style = info; break;
            case "warn": style = warn; break;
            case "error": style = error; break;
            case "fatal": style = fatal; break;
        }

        style += "padding:" + padding
        style += "font-size:" + fontsize
        style += "line-height:" + lineheight

        return style

    }

    // · 
    print_r (data, level = 1) {

        let isArray = Array.isArray(data);

        let comma = ","
        let string = ""
        let padding_key = ""
        let padding_prop = ""
        let newline = "\n"

        for(let i=0;i<(4*level);i++) {
            padding_prop += " "
        }

        if (level > 1) {
            padding_key = padding_prop.slice(0, padding_prop.length - 4)
        }

        if (typeof data == "object" && !Array.isArray(data)) {

            string += padding_key + "{" + newline

            for(let property in data) {

                if (typeof data[property] == "object") {
                    string += padding_prop + property + ": " + this.print_r(data[property], level+1) + comma + newline
                } else {
                    string += padding_prop + property + ": " + data[property] + comma + newline
                }
                
            }

            string += padding_key + "}"

        } 

        if (typeof data == "object" && Array.isArray(data)) {

            string += "[" + newline

            for(let property in data) {

                if (typeof data[property] == "object") {
                    string += this.print_r(data[property], level+1) + comma + newline
                } else {
                    string += padding_prop + data[property] + newline
                }

            }

            string += padding_key + "]"

        }

        // trying to remove last comma if is the end of object or array
        //string = string.replace(/,\n/g, "0")

        return string

    }

}

module.exports = new Utils
