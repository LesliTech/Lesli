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

Lesli - Your Smart Business Assistant

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



// · Loading icon required libraries
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// Cambie los iconos de fontawesome de node, por unos construidos para ruby con sass...
// esto debido a que sprocket no toma los iconos de node en el pipeline de compilacion para produccion
// pueden leer aqui: https://github.com/FortAwesome/font-awesome-sass



// · Loading app plugins
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
import pluginBus from 'LesliCoreVue/plugins/bus'
import pluginUrl from 'LesliCoreVue/plugins/url'
import pluginHttp from 'LesliCoreVue/plugins/http'
import pluginDate from 'LesliCoreVue/plugins/date'
import pluginObjectUtils from 'LesliCoreVue/plugins/object-utils'



// · Loading app functions
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
import debug from 'lesli-js-debug-message/browser'
import document from 'LesliCoreVue/functions/document.js'



// · Loading app layout
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
import componentApplicationHeader from 'LesliCoreVue/layouts/application-header.vue'
import componentApplicationChatbox from 'LesliCoreVue/layouts/application-chatbox.vue'
import componentApplicationNotification from 'LesliCoreVue/layouts/application-notification.vue'

import componentDataLoading from 'LesliCoreVue/layouts/data-loading.vue'
import componentDataEmpty from 'LesliCoreVue/layouts/data-empty.vue'
import componentHeader from "LesliCoreVue/layouts/component-header.vue"
import componentToolbar from "LesliCoreVue/layouts/component-toolbar.vue"


// · Initializing frameworks, libraries and tools
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
Vue.use(VueRouter)
Vue.use(pluginBus)
Vue.use(pluginUrl)
Vue.use(pluginHttp)
Vue.use(pluginDate)
Vue.use(pluginObjectUtils)
Vue.use(Buefy, { defaultIconPack: 'fas' })

Vue.component('component-data-empty', componentDataEmpty)
Vue.component('component-data-loading', componentDataLoading)
Vue.component('component-header', componentHeader)
Vue.component('component-toolbar', componentToolbar)



// · Vue app
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · module: Main module
// · app: List of individual apps loaded
// · base_path: for vue router
// · example: app("CloudHelp", "[list|new|edit|show]", "help/tickets", [])
export default (module, apps, base_path, routes=[]) => {


    // · Vue app configuration container
    let cloud_builder = { }


    // · Default and custom components for logged users
    cloud_builder['components'] = { 
        'application-component-header': componentApplicationHeader,
        'application-component-chatbox': componentApplicationChatbox,
        'application-component-notification': componentApplicationNotification
    }

    
    // · Routes for SPAs
    cloud_builder['router'] = new VueRouter({
        linkActiveClass: 'is-active',
        base: base_path,
        mode: "history",
        routes: routes
    })


    // · Building Vue cloud app
    let cloud = new Vue(cloud_builder)


    // · Mount app once DOM is ready
    document.ready(() => {

        cloud.$mount("#lesli-cloud-application")

        // · Defined in webpack.config.js
        if (leslicloud_app_mode_production) debug.userWarningMessage()
        if (leslicloud_app_mode_development) debug.info(`${base_path} ${apps}`, module)

    })

}
