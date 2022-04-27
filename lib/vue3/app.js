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
import { createWebHistory, createRouter } from "vue-router";
import debug from "lesli-js/debug/browser"


// · Loading layout application
import componentApplicationHeader from "LesliVue/layout/application-header.vue"
import componentApplicationFooter from "LesliVue/layout/application-footer.vue"
import componentApplicationSearch from "LesliVue/layout/application-search.vue"
import componentApplicationSidebar from "LesliVue/layout/application-sidebar.vue"

// · Loading global layout components

import componentDataLoading from "LesliVue/layout/data-loading.vue"



//import Oruga from '@oruga-ui/oruga-next'
//import '@oruga-ui/oruga-next/dist/oruga.css'

import { Table } from '@oruga-ui/oruga-next'
//import '@oruga-ui/oruga-next/dist/oruga.css'





// · apps: List of controllers apps loaded
// · routes: Array of routes for Vue 
// · data: Object for the state management 
// · example: app("[dashboard|tickets|catalogs|etc]", [], {})
export default (apps, routes=[], data={}) => {

    // TODO: inferir module y base_path en base a const lesli
    var base_path = "/"


    // · Vue app configuration container
    let appbuilder = { }


    // · Default and custom components for logged users
    appbuilder["components"] = { 
        "application-component-header": componentApplicationHeader,
        "application-component-footer": componentApplicationFooter,
        "application-component-search": componentApplicationSearch,
        "application-component-sidebar": componentApplicationSidebar,
    }


    //appbuilder["router"] = createRouter({
    const router = createRouter({
        history: createWebHistory(base_path),
        routes: routes.map(route => {
            // concat the base path to all routes
            // this allow to use the rails route constants
            // example: projects_path is equal to /crm/projects
            route.path = base_path.concat(route.path)
            return route
        })
        /*
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
        */
    })


    // · Building Vue cloud app
    let app = createApp(appbuilder)

    app.use(Table)
    app.use(router)


    app.component("component-data-loading", componentDataLoading)

    // · Mount app once DOM is ready
    document.addEventListener("DOMContentLoaded", () => {

        app.mount("#lesli-application")

        /*
        // · development message about vue app loaded
        if (lesli_app_mode_development) { 
            debug.info(`${base_path} ${apps}`, module) 
        }

        // · console production message
        if (lesli_app_mode_production) { 
            console.clear()
            debug.lesli_message_warning(lesli?.company?.name?.replace("Cloud", "")) 
            debug.info(lesli_app_compilation)
        }
        */

    });

}
