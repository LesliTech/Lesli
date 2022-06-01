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


// · 
import app from "LesliVue/app"


// · 
import appAccountDashboard from "Lesli/vue3/administration/apps/accounts/dashboard.vue"
import appUsersProfile from "Lesli/vue3/administration/apps/profile/show.vue"
import appUsersList from "Lesli/vue3/administration/apps/users/list.vue"
import appUsersShow from "Lesli/vue3/administration/apps/users/show.vue"


// · 
app("Administration", [{
    path: "/",
    component: appAccountDashboard
}, {
    path: "/users",
    component: appUsersList
}, {
    path: "/users/:id",
    component: appUsersShow
}, {
    path: "/profile",
    component: appUsersProfile
}])
