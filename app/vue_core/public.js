/*
Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

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

@license  Propietary - all rights reserved.
@version  0.1.0-alpha

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/


// · Loading core framework and libraries
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
import Vue from 'vue'
import Buefy from 'buefy'
import VueRouter from 'vue-router'



// · Loading app plugins
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
import pluginUrl from 'LesliCoreVue/plugins/url'
import pluginHttp from 'LesliCoreVue/plugins/http'



// · Loading app functions
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
import debug from 'lesli-js-debug-message/browser'
import document from 'LesliCoreVue/functions/document.js'



// · Initializing frameworks, libraries and tools
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
Vue.use(Buefy)
Vue.use(VueRouter)
Vue.use(pluginUrl)
Vue.use(pluginHttp)



// · Vue app
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · module: Main module
// · app: List of individual apps loaded
// · base_path: for vue router
// · example: app("CloudHelp", "[list|new|edit|show]", "help/tickets", [])
export default (module, apps, base_path, routes=[]) => {

    // · Building Vue cloud app
    let cloud = new Vue({
        router: new VueRouter({
            linkActiveClass: 'is-active',
            base: base_path,
            mode: "history",
            routes: routes
        })
    })


    // · Mount app once DOM is ready
    document.ready(() => {

        cloud.$mount("#lesli-cloud-app")

        if (leslicloud_app_mode_production) debug.userWarningMessage()
        if (leslicloud_app_mode_development) debug.info(`${base_path} ${apps}`, module)

    })

}
