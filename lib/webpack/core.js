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

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/


// · 
var path = require("path")


// · 
module.exports = (env, requestedEngines) => {

    var config = {

        entry: {

            // devise apps
            "users/sessions": "LesliApp/users/sessions.js",
            "users/passwords": "LesliApp/users/passwords.js",
            "users/registrations": "LesliApp/users/registrations.js",
            


            // alternative logins 
            "mfas/application": "LesliApp/mfas/application.js",
            "otps/application": "LesliApp/otps/application.js",
            "passes/application": "LesliApp/passes/application.js",
            //"feedback/application": "LesliApp/invites/app.js",


            // core apps
            "administration/application": "LesliApp/administration/application.js",
            "onboardings/application": "LesliApp/onboarding/application.js",
            "websites/application": "LesliApp/websites/application.js",
            //"errors/application": "LesliApp/errors/app.js"
        },
        entry: {
            "lesli/users/registrations": "Lesli/devise/registrations.js",
            "lesli/users/confirmations": "Lesli/devise/confirmations.js",
            "lesli/users/passwords": "Lesli/devise/passwords.js"
        },
        entry: {
            "lesli/templates/public": "Lesli/scss/templates/public.scss",
            "lesli/templates/application": "Lesli/scss/templates/application.scss",

            "lesli/users/passwords": ["Lesli/vue/devise/passwords.js", "Lesli/scss/devise/passwords.scss"],
            "lesli/users/sessions": ["Lesli/vue/devise/sessions.js", "Lesli/scss/devise/sessions.scss"]
            
        },
        output: {
            // the output for stylesheets is defined in the webpack file itself
            path: path.resolve("app", "assets"),
            filename: 'javascripts/[name].js'
        }
    }

    // do not include the core apps if specific engines were requested
    if (requestedEngines.length > 0 && !requestedEngines.includes("core")) {
        config.entry = {}
    }

    return config

}
