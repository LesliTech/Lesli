/*

Copyright (c) 2022, all rights reserved.

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
import { createPinia } from "pinia"
import { createApp, nextTick } from "vue"
import { createWebHistory, createRouter } from "vue-router";
import debug from "lesli-js/debug/browser"


// custom console.log implementation for Lesli
window.debug = debug


// · Loading application layout components
import componentApplicationHeader from "LesliVue/layout/application-header.vue"
import componentApplicationFooter from "LesliVue/layout/application-footer.vue"
import componentApplicationSearch from "LesliVue/layout/application-search.vue"
import componentApplicationSidebar from "LesliVue/layout/application-sidebar.vue"
import componentApplicationEngines from "LesliVue/layout/application-engines.vue"
import componentApplicationAnnouncement from "LesliVue/layout/application-announcements.vue"

import componentApplicationPanelTasks from "LesliVue/panels/panel-tasks.vue"
import componentApplicationPanelFiles from "LesliVue/panels/panel-files.vue"
import componentApplicationPanelTickets from "LesliVue/panels/panel-tickets.vue"
import componentApplicationPanelNotifications from "LesliVue/panels/panel-notifications.vue"
import componentApplicationPanelAnnouncements from "LesliVue/panels/panel-announcements.vue"



// · Loading global layout components
import componentLesliIcon from "LesliVue/lesli/components/icon/Icon.vue"
import componentLesliEmpty from "LesliVue/lesli/components/empty/Empty.vue"
import componentLesliTable from "LesliVue/lesli/components/table/Table.vue"
import componentLesliHeader from "LesliVue/lesli/components/header/Header.vue"
import componentLesliSelect from "LesliVue/lesli/components/select/Select.vue"
import componentLesliToolbar from "LesliVue/lesli/components/toolbar/Toolbar.vue"
import componentLesliLoading from "LesliVue/lesli/components/loading/Loading.vue"
import componentLesliCollapse from "LesliVue/lesli/components/collapse/Collapse.vue"
import componentLesliTabItem from "LesliVue/lesli/components/tabs/TabItem.vue"
import componentLesliTabs from "LesliVue/lesli/components/tabs/Tabs.vue"
import componentLesliPanel from "LesliVue/lesli/components/panel/Panel.vue"
import componentLesliButton from "LesliVue/lesli/components/button/Button.vue"
import componentLesliInputTag from "LesliVue/lesli/components/inputTag/InputTag.vue"
import componentLesliCalendar from "LesliVue/lesli/components/calendar/Calendar.vue"
import componentLesliFileUploader from "LesliVue/lesli/components/fileUploader/FileUploader.vue"
import componentLesliNavigationList from "LesliVue/lesli/components/navigation/NavigationList.vue"
import componentLesliAvatar from "LesliVue/lesli/components/avatar/Avatar.vue"
import componentLesliToggle from "LesliVue/lesli/components/toggle/Toggle.vue"
import componentLesliDropdown from "LesliVue/lesli/components/dropdown/Dropdown.vue"
import componentLesliMap from "LesliVue/lesli/components/map/Map.vue"
import componentLesliGallery from "LesliVue/lesli/components/gallery/Gallery.vue"
import componentLesliAutocomplete from "LesliVue/lesli/components/autocomplete/Autocomplete.vue"
import componentLesliPagination from "LesliVue/lesli/components/pagination/Pagination.vue"
import componentLesliInput from "LesliVue/lesli/components/input/Input.vue"



// · Loading vue/pinia plugins as composables
import { useMsg } from "./composables/msg"
import { useUrl } from "./composables/url"
import { useDate } from "./composables/date"
import { useAxios } from "./composables/axios"
import { useDialog } from "./composables/dialog"
import pluginUrl from "LesliVue/plugins/url"


// · engine: List of controllers apps loaded
// · routes: Array of routes for Vue 
// · example: app("CloudAudit", [])
export default (engine, routes=[]) => {



    // use the same routes we use for the rails routes
    // this is harcoded due routes in rails not change so often, please have in mind
    // that if you add more engines or change the mount path of rails engines you must
    // update the paths here and the url plugin.
    const engine_paths = {
        "LesliCloud": "",
        "MitwerkenCloud": "",
        "DeutscheLeibrenten": "",
        "CloudBell": "bell",
        "CloudTeam": "team",
        "CloudTalk": "talk",
        "CloudHelp": "help",
        "CloudWork": "work",
        "CloudWord": "word",
        "CloudAudit": "audit",
        "CloudBabel": "babel",
        "CloudDriver": "driver",
        "CloudSocial": "social",
        "CloudShared": "shared",
        "CloudDevelopment": "development",
        "CloudScraper": "scraper",
        "Administration": "administration",
        "Onboarding": "onboarding"
    }



    // · Base path for the engines/core url's
    const base_path = "/";



    // · Vue app configuration container
    let appbuilder = { }



    // · Loading Lesli local layout components
    appbuilder["components"] = { 
        "application-component-header": componentApplicationHeader,
        "application-component-footer": componentApplicationFooter,
        "application-component-search": componentApplicationSearch,
        "application-component-sidebar": componentApplicationSidebar,
        "application-component-engines": componentApplicationEngines,
        "application-component-announcements": componentApplicationAnnouncement,
        
        "application-component-panel-tasks": componentApplicationPanelTasks,
        "application-component-panel-files": componentApplicationPanelFiles,
        "application-component-panel-tickets": componentApplicationPanelTickets,
        "application-component-panel-announcements": componentApplicationPanelAnnouncements,
        "application-component-panel-notifications": componentApplicationPanelNotifications,
    }

    // · Use pinia as app state management
    const pinia = createPinia()



    // · Loading pinia handmade plugins
    pinia.use(() => ({ msg: useMsg() }))
    pinia.use(() => ({ url: useUrl() }))
    pinia.use(() => ({ date: useDate() }))
    pinia.use(() => ({ http: useAxios() }))
    pinia.use(() => ({ dialog: useDialog() }))


    
    // · Global vue router
    var router = createRouter({
        history: createWebHistory(base_path),
        routes: routes.map(route => {
            // concat the base path to all routes
            // this allow to use the rails route constants
            // example: projects_path is equal to /crm/projects
            route.path = base_path.concat(engine_paths[engine]).concat(route.path)
            return route
        })
    })


    // · 
    router.afterEach((to, from) => {
        // Use next tick to handle router history correctly
        nextTick(() => {

            // update the page title according to the working app
            document.title = `${lesli.company.name} · ${(to.path.substring(1) || 'Dashboard')}`;

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
            if (cssclass) { document.body.classList.add("cloud".concat(cssclass)) }

        })
    })


    // · Create a beautiful Vue 3 app
    let app = createApp(appbuilder)



    // · Provide composables to make them available in all the components
    app.provide('msg', useMsg())
    app.provide('url', useUrl())
    app.provide('date', useDate())
    app.provide('http', useAxios())
    app.provide('dialog', useDialog())
    app.use(pluginUrl) // temporary plugin (we have to remove all the references)
    


    // · Extending vue
    app.use(pinia)
    app.use(router)



    // · Loading Lesli handmade global components
    app.component("lesli-icon", componentLesliIcon)
    app.component("lesli-empty", componentLesliEmpty)
    app.component("lesli-header", componentLesliHeader)
    app.component("lesli-select", componentLesliSelect)
    app.component("lesli-toolbar", componentLesliToolbar)
    app.component("lesli-loading", componentLesliLoading)
    app.component("lesli-table", componentLesliTable)
    app.component("lesli-collapse", componentLesliCollapse)
    app.component("lesli-tab-item", componentLesliTabItem)
    app.component("lesli-tabs", componentLesliTabs)
    app.component("lesli-panel", componentLesliPanel)
    app.component("lesli-button", componentLesliButton)
    app.component("lesli-calendar", componentLesliCalendar)
    app.component("lesli-input-tag", componentLesliInputTag)
    app.component("lesli-file-uploader", componentLesliFileUploader)
    app.component("lesli-navigation-list", componentLesliNavigationList)
    app.component("lesli-avatar", componentLesliAvatar)
    app.component("lesli-toggle", componentLesliToggle)
    app.component("lesli-dropdown", componentLesliDropdown)
    app.component("lesli-map", componentLesliMap)
    app.component("lesli-gallery", componentLesliGallery)
    app.component("lesli-autocomplete", componentLesliAutocomplete)
    app.component("lesli-pagination", componentLesliPagination)
    app.component("lesli-input", componentLesliInput)
    


    // · Mount app once DOM is ready
    document.addEventListener("DOMContentLoaded", () => {

        // · mount the app on the main html tag
        app.mount("#lesli-application")

        // · development message about vue app loaded
        if (lesli_app_mode_development) { 
            debug.info(`${base_path}`, engine) 
        }
        
        // · console production message
        if (lesli_app_mode_production) { 
            debug.lesli_message_warning(lesli?.company?.name?.replace("Cloud", ""))
        }

    });

    return app;
}
