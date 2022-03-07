/*
Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

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


// · Loading node modules
let utils = require("./utils")


// · 
class browserDebugService {

    build(message, modulo, level) {
        return utils.buildMessage(message, modulo, level)
    }

    // · write informatie message
    log(message, modulo = null) {
        console.log(utils.buildMessage(message, modulo, "log"))
    }

    // · write informatie message
    msg(message, modulo = null) {
        console.log(utils.buildMessage(message, modulo, "msg"))
    }

    // · write informatie message
    info(message, modulo = null) {
        console.info("%c"+utils.buildMessage(message, modulo, "info"), utils.stylesForBrowser("info"))
    }

    // · write warning message
    warn(message, modulo = null) {
        console.warn("%c"+utils.buildMessage(message, modulo, "warn"), utils.stylesForBrowser("warn"))
    }

    // · write warning message
    error(message, modulo = null) {
        console.error("%c"+utils.buildMessage(message, modulo, "error"), utils.stylesForBrowser("error"))
    }

    // · write warning message
    fatal(message, modulo = null) {
        console.error("%c"+utils.buildMessage(message, modulo, "error"), utils.stylesForBrowser("fatal"))
    }

    message(title, messages, more_information=null) {

        console.log("%c"+title, "color:#3689e6;font-size:35px;font-weight:600;line-height:1;")

        if (typeof messages === "string") messages = [ messages ]

        console.log("%c"+messages.join("\n"), "background-color:#ffffff;color:#1a1a1a;font-size:18px;font-weight:400;line-height:1.1;")    

        if (more_information) {
            console.log("%c"+more_information, "background-color:#ffffff;color:#1a1a1a;font-size:14px;font-weight:400;line-height:2;")
        }
        
    }

    lesli_message_warning(title="LESLI", support="For mor information contact your system administrator") {
        this.message(title, [
            "This is a browser feature intended for developers.",
            "For security reasons, DO NOT copy or paste any information, text, or code here."
        ], support)
    }

}

// · 
module.exports = new browserDebugService()
