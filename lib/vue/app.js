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
import pluginBus from 'LesliCoreVue/plugins/bus'
import pluginUrl from 'LesliCoreVue/plugins/url'
import pluginHttp from 'LesliCoreVue/plugins/http'
import pluginDate from 'LesliCoreVue/plugins/date'
import pluginLesli from 'LesliCoreVue/plugins/lesli'
import pluginAbilities from 'LesliCoreVue/plugins/abilities'
import pluginObjectUtils from 'LesliCoreVue/plugins/object-utils'


// · Loading app functions
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
import debug from 'lesli-js-debug-message/browser'
import document from 'LesliCoreVue/functions/document.js'



// · Loading app layout
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
import componentApplicationHeader from 'LesliCoreVue/layout/application-header.vue'
import componentApplicationChatbox from 'LesliCoreVue/layout/application-chatbox.vue'
import componentApplicationNavigation from 'LesliCoreVue/layout/application-navigation.vue'
import componentApplicationNotification from 'LesliCoreVue/layout/application-notification.vue'
import componentApplicationGlobalSearch from 'LesliCoreVue/layout/application-global-search.vue'

import componentDataLoading from 'LesliCoreVue/layout/data-loading.vue'
import componentDataEmpty from 'LesliCoreVue/layout/data-empty.vue'
import componentHeader from "LesliCoreVue/layout/component-header.vue"
import componentToolbar from "LesliCoreVue/layout/component-toolbar.vue"



// · Initializing frameworks, libraries and tools
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
Vue.use(VueRouter)
Vue.use(pluginBus)
Vue.use(pluginUrl, lesli.url)
Vue.use(pluginHttp)
Vue.use(pluginDate)
Vue.use(pluginLesli)
Vue.use(pluginAbilities, lesli.current_user)
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
        'application-component-navigation': componentApplicationNavigation,
        'application-component-notification': componentApplicationNotification,
        'application-component-global-search': componentApplicationGlobalSearch
    }

    
    // · Routes for SPAs
    cloud_builder['router'] = new VueRouter({
        linkActiveClass: 'is-active',
        base: base_path,
        mode: "history",
        routes: routes
    })

    cloud_builder['data'] = {
        lesli_cloud_application_css_classes: "layout-standard"
    }

    cloud_builder['methods'] = {
        change_layout() {

            switch (this.lesli_cloud_application_css_classes) {
                case "layout-standard":
                    this.lesli_cloud_application_css_classes = "layout-full"
                    break;
                case "layout-full":
                    this.lesli_cloud_application_css_classes = "layout-standard"
                    break;
                default:
                    this.lesli_cloud_application_css_classes = "layout-standard"
                    break;
            }
            
        }
    }


    // · Building Vue cloud app
    let cloud = new Vue(cloud_builder)


    // · Mount app once DOM is ready
    document.ready(() => {

        cloud.$mount("#lesli-cloud-application")

        // · Defined in webpack.config.js
        if (leslicloud_app_mode_production) debug.lesli_message_warning(leslicloud_app_company.name.toUpperCase(), leslicloud_app_company.email)
        if (leslicloud_app_mode_development) debug.info(`${base_path} ${apps}`, module)

    })

}
