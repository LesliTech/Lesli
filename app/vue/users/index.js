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

@author   LesliTech <hello@lesli.tech>
@license  Propietary - all rights reserved.
@version  0.1.0-alpha

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/
import app from 'LesliCloud/vue/app'



// · Import apps and components
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
import componentList from './apps/user/list.vue'
import componentInvite from './apps/user/invite.vue'
import appNewUser from './apps/user/new.vue'
import appShow from './apps/user/show.vue'
import appEdit from './apps/user/edit.vue'



// · Cloud app
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
app("AdminUsers", "[list|new|invite|show|edit]", "/admin/users", [{
    path :'/',
    component: componentList, //list
}, {
    path :'/new',
    component: appNewUser,  //new
}, {
    path :'/invite',
    component: componentInvite,  //invite
},{
    path :'/:id',
    component: appShow, //show
},{
    path :'/:id/edit',
    component: appEdit, //show
}])
