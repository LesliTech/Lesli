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
//import urlPlugin from 'TheCrow/vue/plugins/url'
//import utilPlugin from 'TheCrow/vue/plugins/util'
//import httpPlugin from 'TheCrow/vue/plugins/http'
//import mqttPlugin from 'TheCrow/vue/plugins/mqtt'


//  · Loading app functions
// ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~
import documentFunction from 'LesliCloud/vue/functions/document'


//  · Loading app layout
// ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~
import componentHeader from 'LesliCloud/vue/layout/header.vue'
//import layoutfooter from 'LesliCloud/vue/layout/footer-admin.vue'


// · Initializing frameworks, libraries and tools
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
//Vue.use(utilPlugin)
//Vue.use(urlPlugin, { config: lesli_config })
//Vue.use(httpPlugin, { config: lesli_config })
//Vue.use(mqttPlugin, { config: lesli_config })
Vue.use(VueBootstrap)
//Vue.use(VueRouter)


// · LesliCloud app
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
let cloud = new Vue({
    components: {
        'component-header': componentHeader,
        //'layout-footer': layoutfooter
    },
    mounted() {
        console.log("works")
    }
})

documentFunction.ready(() => cloud.$mount("#leslicloud_app"))
