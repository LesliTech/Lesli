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

@dev      Carlos Hermosilla
@author   LesliTech <hello@lesli.tech>
@license  Propietary - all rights reserved.
@version  GIT: 0.1.0 alpha

// · 
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
*/


// · Import main app
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
import app from 'LesliCoreVue/public'



// · Import apps and components
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
import appLogin from './apps/login.vue'
import appRegister from './apps/register.vue'
/*
import appConfirmation from './apps/confirmation.vue'
import appRegistration from './apps/register.vue'
import appPasswordNew from './apps/password/new.vue'
import appPasswordEdit from './apps/password/edit.vue'
*/


// · 
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
app("Lesli", "[login|register]", "", [{
    path: "/login",
    component: appLogin,
}, {
    path: "/register",
    component: appRegister,
}])


/*
app("Lesli", "[login|confirmation|register]", "", [{
    path: "/",
    redirect: "/login",
},{
    path: "/login",
    component: appLogin,
},{
    path: "/confirmation/new",
    component: appConfirmation,
},{
    path: "/register",
    component: appRegistration,
},{
    path: "/password/new",
    component: appPasswordNew,
},{
    path: "/password/edit",
    component: appPasswordEdit,
}], true)
*/