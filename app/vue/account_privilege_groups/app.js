/*
Copyright (c) 2020, all rights reserved.

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


// · Import main app from core
import app from 'LesliVue/app'


// · Import common apps
import pageList  from 'Lesli/vue/account_role_groups/pages/list.vue'
import pageShow  from 'Lesli/vue/account_role_groups/pages/show.vue'
import pageNew   from 'Lesli/vue/account_role_groups/pages/new.vue'


// · 
app("Core", "[list|new|edit|show]", "/crm/role_groups", [{
    path: "/",
    component: pageList,
},{
    path: "/new",
    component: pageNew, props: { mainPath: '/crm/users' }
},{
    path: "/:id",
    component: pageShow
}], {
    user: {},
    options: { roles: [] }
})
