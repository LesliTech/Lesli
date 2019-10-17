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
import VueRouter from 'vue-router'
import Buefy from 'buefy'



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
import componentLayoutHeader from 'LesliCloud/vue/layout/header.vue'
import componentLayoutNotify from 'LesliCloud/vue/layout/notify.vue'
import componentLayoutChatbox from 'LesliCloud/vue/layout/chatbox.vue'
import componentLayoutNavigation from 'LesliCloud/vue/layout/navigation.vue'


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
export default (module, app, base_path, routes={}) => {

    let cloud = new Vue({

        components: {
            'component-layout-header': componentLayoutHeader,
            'component-layout-notify': componentLayoutNotify,
            'component-layout-chatbox': componentLayoutChatbox,
            'component-layout-navigation': componentLayoutNavigation
        },

        router: new VueRouter({
            linkActiveClass: 'is-active',
            //mode: "history",
            //base: base_path,
            routes: routes
        })

    })

    document.ready(() => {

        cloud.$mount("#lesli-cloud-app")

        if (leslicloud_app_mode_production) debug.userWarningMessage()
        if (leslicloud_app_mode_development) debug.info(app, module)

    })

}
