

var path = require("path")


module.exports =  {
    entry: {

        // devise apps
        "users/sessions": "LesliApp/users/sessions.js",
        "users/passwords": "LesliApp/users/passwords.js",
        "users/registrations": "LesliApp/users/registrations.js",
        "users/confirmations": "LesliApp/users/confirmations.js",


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
    output: {
        path: path.resolve("app", "assets", "javascripts")
    }
}
