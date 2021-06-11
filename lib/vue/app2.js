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
import VueCurrencyInput from "vue-currency-input"


// · Loading app plugins
import pluginWss from "LesliVue/plugins/wss"
import pluginBus from "LesliVue/plugins/bus"
import pluginUrl from "LesliVue/plugins/url"
import pluginMsg from "LesliVue/plugins/msg"
import pluginData from "LesliVue/plugins/data"
import pluginHttp from "LesliVue/plugins/http"
import pluginDate from "LesliVue/plugins/date"
import pluginLesli from "LesliVue/plugins/lesli"
import pluginStorage from "LesliVue/plugins/storage"
import pluginAbilities from "LesliVue/plugins/abilities"
import pluginObjectUtils from "LesliVue/plugins/object-utils"



// · Loading app functions
import debug from "lesli-js-debug-message/browser"
import document from "LesliVue/functions/document.js"



// · Loading layout application
import componentApplicationHeader from "LesliVue/layout/application-header.vue"
import componentApplicationSearch from "LesliVue/layout/application-search.vue"
import componentApplicationSearchDos from "LesliVue/layout/application-search-dos.vue"
import componentApplicationChatbox from "LesliVue/layout/application-chatbox.vue"
import componentApplicationSidebar from "LesliVue/layout/application-sidebar.vue"



// · Loading panel layout application
import componentApplicationPanelTasks from "LesliVue/panels/panel-task.vue"
import componentApplicationPanelNotifications from "LesliVue/panels/panel-notification.vue"
import componentApplicationPanelEngine from "LesliVue/panels/panel-engine.vue"
import componentApplicationPanelSupport from "LesliVue/panels/panel-support.vue"



// · Loading global layout components
import componentDataEmpty from "LesliVue/layout/data-empty.vue"
import componentDataLoading from "LesliVue/layout/data-loading.vue"
import componentDataPagination from "LesliVue/layout/data-pagination.vue"
import componentToolbar from "LesliVue/layout/component-toolbar.vue"
import componentHeader from "LesliVue/layout/component-header.vue"



// · Initializing plugins
Vue.use(VueRouter)
Vue.use(pluginWss, lesli)
Vue.use(pluginBus)
Vue.use(pluginMsg)
Vue.use(pluginHttp)
Vue.use(pluginDate)
Vue.use(pluginLesli, lesli)
Vue.use(pluginUrl, lesli.url)
Vue.use(pluginAbilities, lesli.current_user, lesli.app)
Vue.use(pluginStorage, lesli.view_id, lesli.current_user)
Vue.use(pluginObjectUtils)
Vue.use(Buefy, { defaultIconPack: "fas" })
Vue.use(VueCurrencyInput, {globalOptions: {...lesli.settings.currency, currency: lesli.settings.currency.symbol}})



// · Adding global components
Vue.component("component-header", componentHeader)
Vue.component("component-toolbar", componentToolbar)
Vue.component("component-data-empty", componentDataEmpty)
Vue.component("component-data-loading", componentDataLoading)
Vue.component("component-data-pagination", componentDataPagination)



// · module: Main module
// · app: List of individual apps loaded
// · base_path: for vue router
// · example: app("CloudHelp", "[list|new|edit|show]", "help/tickets", [])
export default (module, base_path, apps, routes=[], data={}) => {


    // · Simple state management
    Vue.use(pluginData, data)
    

    // · Vue app configuration container
    let cloud_builder = { }


    // · Default and custom components for logged users
    cloud_builder["components"] = { 
        "application-component-header": componentApplicationHeader,
        "application-component-search": componentApplicationSearch,
        "application-component-search-dos": componentApplicationSearchDos,
        "application-component-chatbox": componentApplicationChatbox,
        "application-component-sidebar": componentApplicationSidebar,
        "application-component-panel-task": componentApplicationPanelTasks,
        "application-component-panel-notification": componentApplicationPanelNotifications,
        "application-component-panel-engine": componentApplicationPanelEngine,
        "application-component-panel-support": componentApplicationPanelSupport
    }

    
    // · Routes for SPAs
    cloud_builder["router"] = new VueRouter({
        linkExactActiveClass: "route-is-active",
        linkActiveClass: "is-active",
        base: "/",
        mode: "history",
        routes: routes.map(route => {
            // concat the base path to all routes
            // this allow to use the rails route constants
            // example: projects_path is equal to /crm/projects
            route.path = base_path.concat(route.path)
            return route
        })
    })


    // · Building Vue cloud app
    let cloud = new Vue(cloud_builder)


    // · Mount app once DOM is ready
    document.ready(() => {

        cloud.$mount("#lesli-application")

        // · app mode is defined in webpack.config.js
        if (lesli_app_mode_development) { debug.info(`${base_path} ${apps}`, module) }
        if (lesli_app_mode_production) { 
            debug.lesli_message_warning(lesli?.company?.name, lesli?.company?.public_email) 
            debug.msg(lesli_app_compilation)
        }

    })

}
