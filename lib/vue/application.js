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

Lesli · Ruby on Rails SaaS development platform.

Made with ♥ by https://www.lesli.tech
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
import debug from "lesli-js/debug/browser"


// custom console.log implementation for Lesli
window.debug = debug


// · Loading application layout components
import componentApplicationHeader from "Lesli/layout/application-header.vue"
import componentApplicationFooter from "Lesli/layout/application-footer.vue"
import componentApplicationSearch from "Lesli/layout/application-search.vue"
import componentApplicationSidebar from "Lesli/layout/application-sidebar.vue"
import componentApplicationEngines from "Lesli/layout/application-engines.vue"
import componentApplicationAnnouncement from "Lesli/layout/application-announcements.vue"

import componentApplicationPanelTasks from "Lesli/panels/panel-tasks.vue"
import componentApplicationPanelFiles from "Lesli/panels/panel-files.vue"
import componentApplicationPanelTickets from "Lesli/panels/panel-tickets.vue"
import componentApplicationPanelProfile from "Lesli/panels/panel-profile.vue"
import componentApplicationPanelNotifications from "Lesli/panels/panel-notifications.vue"
import componentApplicationPanelAnnouncements from "Lesli/panels/panel-announcements.vue"


// · Loading global layout components
import componentLesliApplication from "Lesli/lesli/components/application/Application.vue"
import componentLesliIcon from "Lesli/lesli/components/icon/Icon.vue"
import componentLesliEmpty from "Lesli/lesli/components/empty/Empty.vue"
import componentLesliTable from "Lesli/lesli/components/table/Table.vue"
import componentLesliHeader from "Lesli/lesli/components/header/Header.vue"
import componentLesliSelect from "Lesli/lesli/components/select/Select.vue"
import componentLesliToolbar from "Lesli/lesli/components/toolbar/Toolbar.vue"
import componentLesliLoading from "Lesli/lesli/components/loading/Loading.vue"
import componentLesliCollapse from "Lesli/lesli/components/collapse/Collapse.vue"
import componentLesliTabItem from "Lesli/lesli/components/tabs/TabItem.vue"
import componentLesliTabs from "Lesli/lesli/components/tabs/Tabs.vue"
import componentLesliPanel from "Lesli/lesli/components/panel/Panel.vue"
import componentLesliButton from "Lesli/lesli/components/button/Button.vue"
import componentLesliInputTag from "Lesli/lesli/components/inputTag/InputTag.vue"
import componentLesliCalendar from "Lesli/lesli/components/calendar/Calendar.vue"
import componentLesliFileUploader from "Lesli/lesli/components/fileUploader/FileUploader.vue"
import componentLesliNavigationList from "Lesli/lesli/components/navigation/NavigationList.vue"
import componentLesliAvatar from "Lesli/lesli/components/avatar/Avatar.vue"
import componentLesliToggle from "Lesli/lesli/components/toggle/Toggle.vue"
import componentLesliDropdown from "Lesli/lesli/components/dropdown/Dropdown.vue"
import componentLesliMap from "Lesli/lesli/components/map/Map.vue"
import componentLesliGallery from "Lesli/lesli/components/gallery/Gallery.vue"
import componentLesliAutocomplete from "Lesli/lesli/components/autocomplete/Autocomplete.vue"
import componentLesliPagination from "Lesli/lesli/components/pagination/Pagination.vue"
import componentLesliForm from "Lesli/lesli/components/form/Form.vue"
import componentLesliInput from "Lesli/lesli/components/input/Input.vue"
import componentLesliControl from "Lesli/lesli/components/control/Control.vue"
import componentLesliCard from "Lesli/lesli/components/card/Card.vue"


// · Loading vue/pinia plugins as composables
import { useMsg } from "./composables/msg"
import { useUrl } from "./composables/url"
import { useDate } from "./composables/date"
import { useHTTP } from "./composables/http"
import { useDate2 } from "./composables/date2"
import { useUtils } from "./composables/utils"
import { useDialog } from "./composables/dialog"



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
        "CloudBell": "bell",
        "CloudTeam": "team",
        "CloudTalk": "talk",
        "CloudTime": "time",
        "CloudHelp": "help",
        "CloudWork": "work",
        "CloudWord": "word",
        "CloudAudit": "audit",
        "CloudBabel": "babel",
        "CloudMailer": "mailer",
        "CloudDriver": "driver",
        "CloudSocial": "social",
        "CloudShared": "shared",
        "CloudScraper": "scraper",
        "CloudAuthority": "authority",
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
        "application-component-panel-profile": componentApplicationPanelProfile,
        "application-component-panel-announcements": componentApplicationPanelAnnouncements,
        "application-component-panel-notifications": componentApplicationPanelNotifications,
    }

    // · Use pinia as app state management
    const pinia = createPinia()


    // · Loading pinia handmade plugins
    pinia.use(() => ({ msg: useMsg() }))
    pinia.use(() => ({ url: useUrl() }))
    pinia.use(() => ({ http: useHTTP() }))
    pinia.use(() => ({ date: useDate() }))
    pinia.use(() => ({ date2: useDate2() }))
    pinia.use(() => ({ utils: useUtils() }))
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
            if (cssclass) { document.body.classList.add("cloud_".concat(cssclass)) }

        })
    })


    // · Create a beautiful Vue 3 app
    let app = createApp(appbuilder)


    // · Provide composables to make them available in all the components
    app.provide('msg', useMsg())
    app.provide('url', useUrl())
    app.provide('http', useHTTP())
    app.provide('date', useDate())
    app.provide('date2', useDate2())
    app.provide('utils', useUtils())
    app.provide('dialog', useDialog())

    // · Use composables as Vue2 plugins
    app.use({ install: (app) => { app.config.globalProperties.url = useUrl() }})


    // · Extending vue
    app.use(pinia)
    app.use(router)


    // · Loading Lesli global layout components
    // · Deprecated: use lesli-application instead
    app.component("application-component", componentLesliApplication)

    
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
    app.component("lesli-form", componentLesliForm)
    app.component("lesli-input", componentLesliInput)
    app.component("lesli-control", componentLesliControl)
    app.component("lesli-card", componentLesliCard)
    app.component("lesli-application", componentLesliApplication)
    


    // · Mount app once DOM is ready
    document.addEventListener("DOMContentLoaded", () => {

        // · mount the app on the main html tag
        app.mount("#lesli-application")

        // · development message about vue app loaded
        if (lesli_application_development) { 
            debug.info("Lesli application", "vue/application") 
        }

        // · console production message
        if (lesli_application_production) { 
            console.clear()
            debug.lesli_message_warning(lesli?.company?.name) 
            debug.info("Lesli application", lesli_application_version) 
        }

    });

    return app;
}
