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

// · Loading icon required libraries
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
import { fas } from '@fortawesome/free-solid-svg-icons'
import { library } from '@fortawesome/fontawesome-svg-core'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'



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
import componentLayoutAppHeader from 'LesliCoreVue/layouts/app-header.vue'
import componentLayoutAppChatbox from 'LesliCoreVue/layouts/app-chatbox.vue'
import componentLayoutDataEmpty from 'LesliCoreVue/layouts/data-empty.vue'
import componentLayoutDataLoading from 'LesliCoreVue/layouts/data-loading.vue'
import componentLayoutModuleNavigation from 'LesliCoreVue/layouts/module-navigation.vue'
import componentLayoutNotification from 'LesliCoreVue/layouts/notification.vue'



// · Initializing frameworks, libraries and tools
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
library.add(fas)

Vue.use(VueRouter)
Vue.use(pluginBus)
Vue.use(pluginUrl)
Vue.use(pluginHttp)
Vue.use(pluginDate)
Vue.use(pluginObjectUtils)
Vue.use(Buefy, { defaultIconPack: 'fas' })
Vue.component('font-awesome-icon', FontAwesomeIcon)
Vue.component('component-layout-data-empty', componentLayoutDataEmpty)
Vue.component('component-layout-data-loading', componentLayoutDataLoading)



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
        'component-layout-app-header': componentLayoutAppHeader,
        'component-layout-app-chatbox': componentLayoutAppChatbox,
        'component-layout-module-navigation': componentLayoutModuleNavigation,
        'component-layout-notification': componentLayoutNotification
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

        cloud.$mount("#lesli-cloud-app")

        // · Defined in webpack.config.js
        if (leslicloud_app_mode_production) debug.userWarningMessage()
        if (leslicloud_app_mode_development) debug.info(`${base_path} ${apps}`, module)

    })

}
