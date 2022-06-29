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



// · Loading application layout components
import componentApplicationHeader from "LesliVue/layout/application-header.vue"
import componentApplicationFooter from "LesliVue/layout/application-footer.vue"
import componentApplicationSearch from "LesliVue/layout/application-search.vue"
import componentApplicationSidebar from "LesliVue/layout/application-sidebar.vue"
import componentApplicationEngines from "LesliVue/layout/application-engines.vue"



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
import componentLesliNavigationList from "LesliVue/lesli/components/navigation/NavigationList.vue"
import componentLesliInputTag from "LesliVue/lesli/components/inputTag/InputTag.vue"
import componentLesliButton from "LesliVue/lesli/components/button/Button.vue"
import componentLesliFileUploader from "LesliVue/lesli/components/fileUploader/FileUploader.vue"

// · Loading vue/pinia plugins
import pluginUrl from "LesliVue/plugins/url"
import pluginMsg from "LesliVue/plugins/msg"
import pluginHttp from "LesliVue/plugins/http"
import pluginLesli from "LesliVue/plugins/lesli"
import pluginDialog from "LesliVue/plugins/dialog"
import pluginPiniaUrl from "LesliVue/plugins/pinia-url"
import pluginPiniaMsg from "LesliVue/plugins/pinia-msg"
import pluginPiniaHttp from "LesliVue/plugins/pinia-http"
import pluginPiniaDialog from "LesliVue/plugins/pinia-dialog"



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
        "CloudBell": "bell",
        "CloudAudit": "audit",
        "CloudBabel": "babel",
        "CloudDevelopment": "development",
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
    }



    // · Use pinia as app state management
    const pinia = createPinia()



    // · Loading pinia handmade plugins
    pinia.use(pluginPiniaUrl)
    pinia.use(pluginPiniaMsg)
    pinia.use(pluginPiniaHttp)
    pinia.use(pluginPiniaDialog)


    
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
            document.title = `${lesli?.company?.name} · ${to.path}`;

            // default class for the specific instance
            document.body.className = lesli?.instance

            // using the path as class id for the body
            var cssclass = to.path;

            // we want the path without params to use it as body class
            Object.values(to.params).forEach(p => cssclass = cssclass.replace(p,''))

            // replace the slashes with dashes to make the class work with standard css
            cssclass = cssclass.substring(1).replaceAll("/","-").replace(/-$/, '');

            // add the css class to the body
            if (cssclass) { document.body.classList.add(cssclass) }

        })
    })


    // · Create a beautiful Vue 3 app
    let app = createApp(appbuilder)



    // · Loading Lesli vue handmade plugins
    app.use(pluginUrl)
    app.use(pluginMsg)
    app.use(pluginHttp)
    app.use(pluginLesli)
    app.use(pluginDialog)
    


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
    app.component("lesli-navigation-list", componentLesliNavigationList)
    app.component("lesli-input-tag", componentLesliInputTag)
    app.component("lesli-button", componentLesliButton)
    app.component("lesli-file-uploader", componentLesliFileUploader)



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
