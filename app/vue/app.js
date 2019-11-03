/*
Lesli

Copyright (c) 2019, Lesli Technologies, S. A.

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

@dev      Luis Donis <ldonis@lesli.tech>
@author   LesliTech <hello@lesli.tech>
@license  Propietary - all rights reserved.
@version  GIT: 0.1.0 alpha

// · 
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
*/


// · Loading core framework and libraries
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
import Vue from 'vue'
import Buefy from 'buefy'
import VueRouter from 'vue-router'



// · Loading app plugins
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
import pluginBus from 'LesliCloud/vue/plugins/bus'
import pluginUrl from 'LesliCloud/vue/plugins/url'
import pluginHttp from 'LesliCloud/vue/plugins/http'
import pluginCable from 'LesliCloud/vue/plugins/cable'



// · Loading app functions
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
import debug from 'lesli-nodejs-debug-message/browser'
import document from 'LesliCloud/vue/functions/document.js'



// · Loading app layout
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
import componentLayoutNotify from 'LesliCloud/vue/layouts/notify.vue'
import componentLayoutHeader from 'LesliCloud/vue/layouts/header.vue'
import componentLayoutChatbox from 'LesliCloud/vue/layouts/chatbox.vue'
import componentLayoutNavigation from 'LesliCloud/vue/layouts/navigation.vue'




// · Initializing frameworks, libraries and tools
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
Vue.use(Buefy)
Vue.use(VueRouter)
Vue.use(pluginBus)
Vue.use(pluginUrl)
Vue.use(pluginHttp)
Vue.use(pluginCable)



// · Vue app
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · module: Main module
// · app: List of individual apps loaded
// · base_path: for vue router
// · example: app("CloudHelp", "[list|new|edit|show]", "help/tickets", {}, [])
export default (module, app, base_path, components={}, routes=null) => {


    // · Vue app configuration container
    let cloud_builder = { }


    // · Default and custom components
    cloud_builder['components'] = { 
        ...{
            'component-layout-notify': componentLayoutNotify,
            'component-layout-header': componentLayoutHeader,
            'component-layout-chatbox': componentLayoutChatbox,
            'component-layout-navigation': componentLayoutNavigation
        }, 
        ...components 
    }


    // · Routes for SPAs
    if (routes) {
        cloud_builder['router'] = new VueRouter({
            linkActiveClass: 'is-active',
            mode: "history",
            base: base_path,
            routes: routes
        })
    }


    // · Building Vue cloud app
    let cloud = new Vue(cloud_builder)


    // · Mount app once DOM is ready
    document.ready(() => {

        cloud.$mount("#lesli-cloud-app")

        if (leslicloud_app_mode_production) debug.userWarningMessage()
        if (leslicloud_app_mode_development) debug.info(`${base_path} ${app}`, module)

    })

}
