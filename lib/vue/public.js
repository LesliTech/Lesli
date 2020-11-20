/*
Copyright (c) 2020, all rights reserved.

All the information provided by this platform is protected by international laws related  to 
industrial property, intellectual property, copyright and relative international laws. 
All intellectual or industrial property rights of the code, texts, trade mark, design, 
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/


// · Loading core framework and libraries
import Vue from "vue"
import Buefy from "buefy"
import VueRouter from "vue-router"



// · Loading app plugins
import pluginUrl from "LesliCoreVue/plugins/url"
import pluginHttp from "LesliCoreVue/plugins/http"



// · Loading app functions
import debug from "lesli-js-debug-message/browser"
import document from "LesliCoreVue/functions/document.js"



// · Initializing frameworks, libraries and tools
Vue.use(Buefy)
Vue.use(pluginUrl, lesli.url)
Vue.use(pluginHttp)



// · Vue app
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · module: Main module
// · app: List of individual apps loaded
// · base_path: for vue router
// · example: app("CloudHelp", "[list|new|edit|show]", "help/tickets", [])

export default (app) => {

    // · Building Vue cloud app
    let cloud = new Vue(app)


    // · Mount app once DOM is ready
    document.ready(() => {

        cloud.$mount("#lesli-cloud-application")

        //if (leslicloud_app_mode_production) debug.userWarningMessage()
        //if (leslicloud_app_mode_development) debug.info(`${base_path} ${apps}`, module)

    })

}
