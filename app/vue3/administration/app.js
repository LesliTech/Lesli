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
import appDescriptorsEdit from "Lesli/vue3/administration/apps/descriptors/edit.vue"
import appDescriptorsNew from "Lesli/vue3/administration/apps/descriptors/new.vue"

import appRolesIndex from "Lesli/vue3/administration/apps/roles/index.vue"
import appRolesShow from "Lesli/vue3/administration/apps/roles/show.vue"
import appRolesEdit from "Lesli/vue3/administration/apps/roles/edit.vue"
import appRolesNew from "Lesli/vue3/administration/apps/roles/new.vue"

import appIntegrationsIndex from "Lesli/vue3/administration/apps/integrations/index.vue"
import appIntegrationsNew from "Lesli/vue3/administration/apps/integrations/new.vue"
import appSecurity from "Lesli/vue3/administration/apps/security/index.vue"
import appDatetime from "Lesli/vue3/administration/apps/date_time/index.vue"
import appBranding from "Lesli/vue3/administration/apps/branding/index.vue"
import appTheme from "Lesli/vue3/administration/apps/theme/index.vue"
import appAccountShow from "Lesli/vue3/administration/apps/accounts/show.vue"
import appAccountIssues from "Lesli/vue3/administration/apps/account_issues/index.vue"
import appAccountIssuesShow from "Lesli/vue3/administration/apps/account_issues/show.vue"




// · 
app("Administration", [{
    path: "/",
    component: appAccountDashboard
}, {
    path: "/account",
    component: appAccountShow
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
    path: "/descriptors/:id/edit",
    component: appDescriptorsEdit
}, {
    path: "/descriptors/new",
    component: appDescriptorsNew
}, {
    path: "/roles",
    component: appRolesIndex
}, {
    path: "/roles/new",
    component: appRolesNew
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
}, {
    path: "/account/settings/theme",
    component: appTheme
}, {
    path: "/account/issues",
    component: appAccountIssues
}, {
    path: "/account/issues/:id",
    component: appAccountIssuesShow
},
])
