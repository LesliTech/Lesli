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
import { createApp } from "vue"
import { createPinia } from "pinia"
import { createWebHistory, createRouter } from "vue-router";
import debug from "lesli-js/debug/browser"



// · Loading application layout components
import componentApplicationHeader from "LesliVue/layout/application-header.vue"
import componentApplicationFooter from "LesliVue/layout/application-footer.vue"
import componentApplicationSearch from "LesliVue/layout/application-search.vue"
import componentApplicationSidebar from "LesliVue/layout/application-sidebar.vue"


// · Loading panels
import componentApplicationPanelEngines from "LesliVue/panels/panel-engines.vue"



// · Loading global layout components
import componentLesliIcon from "LesliVue/components/lesli/icon.vue"
import componentLesliHeader from "LesliVue/components/lesli/header.vue"
import componentLesliToolbar from "LesliVue/components/lesli/toolbar.vue"
import componentLesliDataLoading from "LesliVue/components/lesli/data/loading.vue"
import componentLesliDataEmpty from "LesliVue/components/lesli/data/empty.vue"
import componentLesliDataTable from "LesliVue/components/lesli/data/table.vue"
import componentLesliDataCollapse from "LesliVue/components/lesli/data/collapse.vue"
import componentLesliTab from "LesliVue/components/lesli/tab.vue"
import componentLesliTabItem from "LesliVue/components/lesli/tab-item.vue"



// · Loading vue/pinia plugins
import pluginUrl from "LesliVue/plugins/url"
import pluginHttp from "LesliVue/plugins/http"
import pluginStore from "LesliVue/plugins/store"
import pluginPiniaUrl from "LesliVue/plugins/pinia-url"
import pluginPiniaHttp from "LesliVue/plugins/pinia-http"



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
        "CloudAudit": "audit",
        "CloudBabel": "babel",
        "CloudDevelopment": "development",
        "Administration": "administration",
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
        "application-component-panel-engines": componentApplicationPanelEngines,
    }



    // · Use pinia as app state management
    const pinia = createPinia()



    // · Loading pinia handmade plugins
    pinia.use(pluginPiniaHttp)
    pinia.use(pluginPiniaUrl)


    
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



    // · Create a beautiful Vue 3 app
    let app = createApp(appbuilder)



    // · Loading Lesli vue handmade plugins
    app.use(pluginUrl, lesli.url)
    app.use(pluginHttp)
    app.use(pluginStore)
    


    // · Extending vue
    app.use(pinia)
    app.use(router)



    // · Loading Lesli handmade global components
    app.component("lesli-icon", componentLesliIcon)
    app.component("lesli-header", componentLesliHeader)
    app.component("lesli-toolbar", componentLesliToolbar)
    app.component("lesli-data-empty", componentLesliDataEmpty)
    app.component("lesli-data-loading", componentLesliDataLoading)
    app.component("lesli-data-table", componentLesliDataTable)
    app.component("lesli-data-collapse", componentLesliDataCollapse)
    app.component("lesli-tab-item", componentLesliTabItem)
    app.component("lesli-tab", componentLesliTab)



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
            console.clear()
            debug.lesli_message_warning(lesli?.company?.name?.replace("Cloud", ""))
        }

    });

}
