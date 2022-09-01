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
import appUsersIndex from "Lesli/vue3/administration/apps/users/index.vue"
import appUsersShow from "Lesli/vue3/administration/apps/users/show.vue"
import appUsersNew from "Lesli/vue3/administration/apps/users/new.vue"

import appDescriptorsIndex from "Lesli/vue3/administration/apps/descriptors/index.vue"
import appDescriptorsShow from "Lesli/vue3/administration/apps/descriptors/show.vue"

import appRolesIndex from "Lesli/vue3/administration/apps/roles/index.vue"
import appRolesShow from "Lesli/vue3/administration/apps/roles/show.vue"
import appRolesEdit from "Lesli/vue3/administration/apps/roles/edit.vue"

import appIntegrationsIndex from "Lesli/vue3/administration/apps/integrations/index.vue"
import appIntegrationsNew from "Lesli/vue3/administration/apps/integrations/new.vue"
import appSecurity from "Lesli/vue3/administration/apps/security/index.vue"
import appDatetime from "Lesli/vue3/administration/apps/date_time/index.vue"
import appBranding from "Lesli/vue3/administration/apps/branding/index.vue"
import appTheme from "Lesli/vue3/administration/apps/theme/index.vue"

// · 
app("Administration", [{
    path: "/",
    component: appAccountDashboard
}, {
    path: "/users",
    component: appUsersIndex
}, {
    path: "/users/:id",
    component: appUsersShow
}, {
    path: "/users/new",
    component: appUsersNew
},{
    path: "/profile",
    component: appUsersProfile
}, {
    path: "/descriptors",
    component: appDescriptorsIndex
}, {
    path: "/descriptors/:id",
    component: appDescriptorsShow
}, {
    path: "/roles",
    component: appRolesIndex
}, {
    path: "/roles/:id",
    component: appRolesShow
}, {
    path: "/roles/:id/edit",
    component: appRolesEdit
}, {
    path: "/account/integrations",
    component: appIntegrationsIndex
}, {
    path: "/account/integrations/new",
    component: appIntegrationsNew
}, {
    path: "/account/settings/security",
    component: appSecurity
}, {
    path: "/account/settings/date_time",
    component: appDatetime
}, {
    path: "/account/settings/branding",
    component: appBranding
}, {
    path: "/account/settings/theme",
    component: appTheme
}
])
