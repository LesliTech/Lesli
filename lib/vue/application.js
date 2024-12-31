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

Made with ♥ by LesliTech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/


// · Loading core framework and libraries
import { createPinia } from "pinia"
import { createApp, nextTick } from "vue"
import { createWebHistory, createRouter } from "vue-router";
import { useLesliDebug } from "lesli-vue/composables"
const debug = useLesliDebug()


// custom console.log implementation for Lesli
window.debug = debug


// · Loading application layout components
import lesliApplicationHeader from "Lesli/vue/layouts/application-header.vue"
import lesliApplicationEngines from "Lesli/vue/layouts/application-engines.vue"
import lesliApplicationContainer from "Lesli/vue/layouts/application-container.vue"
import lesliApplicationComponent from "Lesli/vue/layouts/application-component.vue"

/*
import componentApplicationFooter from "Lesli/vue/layouts/application-footer.vue"
import componentApplicationSearch from "Lesli/vue/layouts/application-search.vue"
import componentApplicationSidebar from "Lesli/vue/layouts/application-sidebar.vue"
import componentApplicationAnnouncement from "Lesli/vue/layouts/application-announcements.vue"
import componentApplicationPanelTasks from "Lesli/vue/panels/panel-tasks.vue"
import componentApplicationPanelFiles from "Lesli/vue/panels/panel-files.vue"
import componentApplicationPanelProfile from "Lesli/vue/panels/panel-profile.vue"
import componentApplicationPanelNotifications from "Lesli/vue/panels/panel-notifications.vue"
import componentApplicationPanelAnnouncements from "Lesli/vue/panels/panel-announcements.vue"
*/

import componentApplicationPanelSupportTickets from "Lesli/vue/panels/panel-support-tickets.vue"
import componentApplicationPanelBellNotifications from "Lesli/vue/panels/panel-bell-notifications.vue"


// · Loading global layout components
import { 
    // lesliElementAutocomplete, 
    LesliAvatar,
    LesliButton, 
    // lesliElementButtonLink,
    LesliCalendar, 
    LesliCard, 
    // lesliElementCollapse, 
    LesliColumn,
    LesliColumns,
    LesliControl, 
    LesliInput, 
    // lesliElementDropdown, 
    LesliEmpty, 
    LesliForm, 
    LesliHeader, 
    LesliField,
    // lesliElementIcon, 
    // lesliElementInput, 
    // lesliElementInputTag, 
    LesliLink, 
    LesliLoading, 
    // lesliElementMap, 
    LesliNavbar, 
    // lesliElementFileUploader,
    // lesliElementNavigationList, 
    LesliPagination, 
    LesliPanel, 
    LesliSelect, 
    LesliTable, 
    LesliTabs, 
    LesliTabItem, 
    LesliToggle, 
    LesliToolbar 
} from "lesli-vue/elements"



// · Loading vue/pinia plugins as composables
import { 
    useLesliMsg, 
    useLesliUrl, 
    useLesliDate, 
    useLesliHttp, 
    useLesliUtils, 
    useLesliDialog 
} from "lesli-vue/composables"




// · engine: Engine name
// · routes: Array of routes for Vue 
export default (engine, routes=[]) => {

    // · Base path for the engines/core url's
    const base_path = "/";


    // · Vue app configuration container
    let appbuilder = { }


    // · Loading Lesli local layout components
    appbuilder["components"] = { 
        "lesli-application-header": lesliApplicationHeader,
        "lesli-application-engines": lesliApplicationEngines,
        "application-panel-support-tickets": componentApplicationPanelSupportTickets,
        "application-panel-bell-notifications": componentApplicationPanelBellNotifications
        /*
        "application-component-footer": componentApplicationFooter,
        "application-component-search": componentApplicationSearch,
        "application-component-sidebar": componentApplicationSidebar,
        "application-component-announcements": componentApplicationAnnouncement,
        "application-component-panel-tasks": componentApplicationPanelTasks,
        "application-component-panel-files": componentApplicationPanelFiles,
        "application-component-panel-profile": componentApplicationPanelProfile,
        "application-component-panel-announcements": componentApplicationPanelAnnouncements
        */
    }


    // · Use pinia as app state management
    const pinia = createPinia()


    // · Loading pinia handmade plugins
    pinia.use(() => ({ msg: useLesliMsg() }))
    pinia.use(() => ({ url: useLesliUrl(Lesli) }))
    pinia.use(() => ({ http: useLesliHttp() }))
    pinia.use(() => ({ date: useLesliDate() }))
    pinia.use(() => ({ utils: useLesliUtils() }))
    pinia.use(() => ({ dialog: useLesliDialog() }))

    
    // · Global vue router
    const router = createRouter({
        history: createWebHistory(base_path),
        routes: routes.map(route => {
            // concat the base path to all routes
            // this allow to use the rails route constants
            // example: projects_path is equal to /crm/projects
            route.path = base_path.concat(lesli.engine_paths[engine]).concat(route.path)
            return route
        })
    })


    // · 
    router.afterEach((to, from) => {

        // Use next tick to handle router history correctly
        nextTick(() => {

            // update the page title according to the working app
            document.title = `${lesli?.company?.name} · ${(to.path.substring(1) || 'Dashboard')}`;

            // default class for the specific instance
            document.body.className = lesli?.instance

            // using the path as class id for the body
            // the class will be: "engine-controller"
            var cssclass = to.path
            .substring(1)         // remove the first slash
            .split("/")           // create an array splited by slashes
            .filter(e => e != "") // remove empty strings
            .slice(0, 2)          // get the first two items of the array
            .join("-");           // create a string joined by dashes

            // add the css class to the body
            if (cssclass) { document.body.classList.add("lesli-".concat(cssclass)) }

        })
    })


    // · Create a beautiful Vue 3 app
    const application = createApp(appbuilder)


    // · Provide composables to make them available in all the components
    application.provide('msg', useLesliMsg())
    application.provide('url', useLesliUrl())
    application.provide('http', useLesliHttp())
    application.provide('date', useLesliDate()())
    application.provide('utils', useLesliUtils())
    application.provide('dialog', useLesliDialog())


    // · Extending vue
    application.use(pinia)
    application.use(router)


    // · Register global layouts
    application.component("lesli-application-container", lesliApplicationContainer)
    application.component("lesli-application-component", lesliApplicationComponent)

    
    // · Loading Lesli handmade global components
    // application.component("lesli-icon", lesliElementIcon)
    application.component("lesli-avatar", LesliAvatar)
    application.component("lesli-empty", LesliEmpty)
    application.component("lesli-header", LesliHeader)
    application.component("lesli-select", LesliSelect)
    application.component("lesli-toolbar", LesliToolbar)
    application.component("lesli-loading", LesliLoading)
    application.component("lesli-table", LesliTable)
    // application.component("lesli-collapse", lesliElementCollapse)
    application.component("lesli-column", LesliColumn)
    application.component("lesli-columns", LesliColumns)
    application.component("lesli-card", LesliCard)
    application.component("lesli-control", LesliControl)
    application.component("lesli-input", LesliInput)
    application.component("lesli-field", LesliField)
    application.component("lesli-tabs", LesliTabs)
    application.component("lesli-tab-item", LesliTabItem)
    application.component("lesli-panel", LesliPanel)
    application.component("lesli-button", LesliButton)
    // application.component("lesli-button-link", lesliElementButtonLink)
    application.component("lesli-calendar", LesliCalendar)
    // application.component("lesli-input-tag", lesliElementInputTag)
    // application.component("lesli-file-uploader", lesliElementFileUploader)
    // application.component("lesli-navigation-list", lesliElementNavigationList)
    application.component("lesli-navbar", LesliNavbar)
    application.component("lesli-toggle", LesliToggle)
    // application.component("lesli-dropdown", lesliElementDropdown)
    // application.component("lesli-map", lesliElementMap)
    // //application.component("lesli-gallery", lesliElementGallery)
    // application.component("lesli-autocomplete", lesliElementAutocomplete)
    application.component("lesli-pagination", LesliPagination)
    application.component("lesli-form", LesliForm)
    // application.component("lesli-input", lesliElementInput)
    application.component("lesli-link", LesliLink)
    


    // · Mount app once DOM is ready
    document.addEventListener("DOMContentLoaded", () => {

        // · mount the app on the main html tag
        application.mount("#lesli-application")

        // · development message about vue app loaded
        if (lesli_application_development) { 
            debug.info(`${engine} --> ${lesli.engine_paths[engine]}`, "vue/application")
        }

        // · console production message
        if (lesli_application_production) { 
            console.clear()
            debug.lesli_message_warning(lesli?.company?.name) 
            debug.info("Lesli application", lesli_application_version) 
        }

    });

    return application;
}
