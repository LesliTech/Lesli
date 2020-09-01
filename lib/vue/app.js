/**
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

@contact  <hello@lesli.tech>
@website  <https://lesli.tech>
@license  Propietary - all rights reserved.

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
import pluginBus from 'LesliVue/plugins/bus'
import pluginUrl from 'LesliVue/plugins/url'
import pluginHttp from 'LesliVue/plugins/http'
import pluginDate from 'LesliVue/plugins/date'
import pluginLesli from 'LesliVue/plugins/lesli'
import pluginStore from 'LesliVue/plugins/store'
import pluginStorage from 'LesliVue/plugins/storage'
import pluginAbilities from 'LesliVue/plugins/abilities'
import pluginObjectUtils from 'LesliVue/plugins/object-utils'


// · Loading app functions
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
import debug from 'lesli-js-debug-message/browser'
import document from 'LesliVue/functions/document.js'



// · Loading app layout
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
import componentApplicationModule from 'LesliVue/layout/application-module.vue'
import componentApplicationHeader from 'LesliVue/layout/application-header.vue'
import componentApplicationSearch from 'LesliVue/layout/application-search.vue'
import componentApplicationChatbox from 'LesliVue/layout/application-chatbox.vue'
import componentApplicationSidebar from 'LesliVue/layout/application-sidebar.vue'
import componentApplicationNotification from 'LesliVue/layout/application-notification.vue'

import componentDataEmpty from "LesliVue/layout/data-empty.vue"
import componentDataLoading from "LesliVue/layout/data-loading.vue"
import componentToolbar from "LesliVue/layout/component-toolbar.vue"
import componentHeader from "LesliVue/layout/component-header.vue"


// · Initializing plugins
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
Vue.use(VueRouter)
Vue.use(pluginBus)
Vue.use(pluginUrl, lesli.url)
Vue.use(pluginHttp)
Vue.use(pluginDate)
Vue.use(pluginLesli, lesli)
Vue.use(pluginAbilities, lesli.current_user, lesli.app)
Vue.use(pluginObjectUtils)
Vue.use(Buefy, { defaultIconPack: 'fas' })

Vue.use(pluginStorage, lesli.view_id, lesli.current_user)



// · Adding global components
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
Vue.component('component-header', componentHeader)
Vue.component('component-toolbar', componentToolbar)
Vue.component('component-data-empty', componentDataEmpty)
Vue.component('component-data-loading', componentDataLoading)



// · Vue app
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · module: Main module
// · app: List of individual apps loaded
// · base_path: for vue router
// · example: app("CloudHelp", "[list|new|edit|show]", "help/tickets", [])
export default (module, apps, base_path, routes=[], store={}) => {

    Vue.use(pluginStore, store)

    // · Vue app configuration container
    let cloud_builder = { }


    // · Default and custom components for logged users
    cloud_builder['components'] = { 
        'application-component-module': componentApplicationModule,
        'application-component-header': componentApplicationHeader,
        'application-component-search': componentApplicationSearch,
        'application-component-chatbox': componentApplicationChatbox,
        'application-component-sidebar': componentApplicationSidebar,
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

        cloud.$mount("#lesli-application")

        // · Defined in webpack.config.js
        if (leslicloud_app_mode_production) debug.lesli_message_warning(leslicloud_app_company.name.toUpperCase(), leslicloud_app_company.email)
        if (leslicloud_app_mode_development) debug.info(`${base_path} ${apps}`, module)

    })

}
