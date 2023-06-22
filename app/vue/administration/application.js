/*
Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Ruby on Rails Development Platform.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/

// · 
import application from "Lesli/application"


// · 
import applicationAccountDashboard from "CloudAdmin/apps/accounts/dashboard.vue"

import applicationUsersProfile from "LesliApp/administration/apps/profile/show.vue"
import applicationUsersIndex from "LesliApp/administration/apps/users/index.vue"
import applicationUsersShow from "LesliApp/administration/apps/users/show.vue"
import applicationUsersNew from "LesliApp/administration/apps/users/new.vue"

import applicationDescriptorsIndex from "LesliApp/administration/apps/descriptors/index.vue"
import applicationDescriptorsEdit from "LesliApp/administration/apps/descriptors/edit.vue"
import applicationDescriptorsNew from "LesliApp/administration/apps/descriptors/new.vue"

import applicationRolesIndex from "LesliApp/administration/apps/roles/index.vue"
import applicationRolesShow from "LesliApp/administration/apps/roles/show.vue"
import applicationRolesEdit from "LesliApp/administration/apps/roles/edit.vue"
import applicationRolesNew from "LesliApp/administration/apps/roles/new.vue"

import applicationIntegrationsIndex from "LesliApp/administration/apps/integrations/index.vue"
import applicationIntegrationsNew from "LesliApp/administration/apps/integrations/new.vue"
import applicationSecurity from "LesliApp/administration/apps/security/index.vue"
import applicationDatetime from "LesliApp/administration/apps/date_time/index.vue"
import applicationBranding from "LesliApp/administration/apps/branding/index.vue"
import applicationTheme from "LesliApp/administration/apps/theme/index.vue"
import applicationAccountShow from "LesliApp/administration/apps/accounts/show.vue"


// · 
application("Administration", [{
    path: "/",
    component: applicationAccountDashboard
}, {
    path: "/account",
    component: applicationAccountShow
}, {
    path: "/users",
    component: applicationUsersIndex
}, {
    path: "/users/:id",
    component: applicationUsersShow
}, {
    path: "/users/new",
    component: applicationUsersNew
},{
    path: "/profile",
    component: applicationUsersProfile
}, {
    path: "/descriptors",
    component: applicationDescriptorsIndex
}, {
    path: "/descriptors/:id/edit",
    component: applicationDescriptorsEdit
}, {
    path: "/descriptors/new",
    component: applicationDescriptorsNew
}, {
    path: "/roles",
    component: applicationRolesIndex
}, {
    path: "/roles/new",
    component: applicationRolesNew
}, {
    path: "/roles/:id",
    component: applicationRolesShow
}, {
    path: "/roles/:id/edit",
    component: applicationRolesEdit
}, {
    path: "/account/integrations",
    component: applicationIntegrationsIndex
}, {
    path: "/account/integrations/new",
    component: applicationIntegrationsNew
}, {
    path: "/account/settings/security",
    component: applicationSecurity
}, {
    path: "/account/settings/date_time",
    component: applicationDatetime
}, {
    path: "/account/settings/branding",
    component: applicationBranding
}, {
    path: "/account/settings/theme",
    component: applicationTheme
}, {
    path: "/account/settings/theme",
    component: applicationTheme
}])
