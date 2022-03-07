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


// ·  Loading node modules
const chalk = require("chalk")
const utils = require("./utils")



// ·
class DebugMessageNodeJS {

    build(message, modulo, level) {
        return utils.buildMessage(message, modulo, level)
    }

    // · write informatie message
    log(message, module = null) {

        message = utils.buildMessage(message, module, "log")
        console.log(message)

    }

    // · write informatie message
    msg(message, module = null) {

        message = utils.buildMessage(message, module, "msg")
        console.log(message)

    }


    // · write informatie message
    info(message, module = null) {

        message = utils.buildMessage(message, module, "info")
        console.log(chalk.whiteBright.bgBlue(message))

    }


    // · write warning message
    warn(message, module = null) {

        message = utils.buildMessage(message, module, "warn")
        console.log(chalk.black.bgYellowBright(message))

    }


    // · write warning message
    error(message, module = null) {

        message = utils.buildMessage(message, module, "error")
        console.log(chalk.whiteBright.bgRedBright(message))

    }


    // · write warning message
    fatal(message, module = null) {

        message = utils.buildMessage(message, module, "fatal")
        console.log(chalk.black.bgRedBright(message))

    }

    hr(size=10) {
        console.log('-·-     '.repeat(size))
    }

}


// · 
module.exports = new DebugMessageNodeJS()
