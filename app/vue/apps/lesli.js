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

//  · 
// ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~
*/


//  · Loading core framework and libraries
// ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~
import Vue from 'vue'
import VueRouter from 'vue-router'
import VueBootstrap from 'bootstrap-vue'


//  · Loading app plugins
// ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~
import pluginBus from 'LesliCloud/vue/plugins/bus'
import pluginUrl from 'LesliCloud/vue/plugins/url'
import pluginUtil from 'LesliCloud/vue/plugins/util'
import pluginHttp from 'LesliCloud/vue/plugins/http'


//  · Loading app functions
// ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~
import debug from 'LesliCloud/vue/functions/debug'
import functionDocument from 'LesliCloud/vue/functions/document'


//  · Loading app layout
// ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~
import componentLesliChatbox from 'LesliCloud/vue/components/chatbox.vue'
import componentLayoutHeader from 'LesliCloud/vue/layout/header.vue'
import componentLayoutSidenav from 'LesliCloud/vue/layout/sidenav.vue'


//  · Loading apps, modules and components
// ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~



// · Initializing frameworks, libraries and tools
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
Vue.use(pluginBus)
Vue.use(pluginUrl)
Vue.use(pluginUtil)
Vue.use(pluginHttp)
Vue.use(VueBootstrap)


// · LesliCloud app
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
let cloud = new Vue({

    components: {
        'component-layout-header': componentLayoutHeader,
        'component-layout-sidenav': componentLayoutSidenav,
        'component-lesli-chatbox': componentLesliChatbox
    },

    mounted() {
        console.log("Default lesli app")
    }

})

// · 
functionDocument.ready(() => cloud.$mount("#lesli-cloud-app"))
