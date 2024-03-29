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


// · Loading core framework and libraries
import { createApp } from "vue"


// · Loading app functions
import { useLesliDebug } from "lesli-vue/composables"
const debug = useLesliDebug()


// · Loading app plugins
import { useLesliUrl, useLesliHttp } from "lesli-vue/composables"


// · module: Engine name
// · base_path: Engine mounth path 
// · apps: List of controllers apps loaded
// · routes: Array of routes for Vue 
// · data: Object for the state management 
// · example: app("CloudHelp", "/help", "[dashboard|tickets|catalogs|etc]", [], {})
export default (appbuilder) => {


    // · Building Vue cloud app
    let app = createApp(appbuilder)


    // · Using plugins
    app.use({ install: (app) => { app.config.globalProperties.url = useLesliUrl() }})
    app.use({ install: (app) => { app.config.globalProperties.http = useLesliHttp() }})


    // · Mount app once DOM is ready
    document.addEventListener("DOMContentLoaded", () => {

        app.mount("#lesli-application")

        // · development message about vue app loaded
        if (lesli_application_development) { 
            debug.info("Lesli application", "vue/public") 
        }

        // · console production message
        if (lesli_application_production) { 
            console.clear()
            debug.lesli_message_warning(Lesli?.company?.name) 
            debug.info("Lesli application", lesli_application_version) 
        }

    });

}
