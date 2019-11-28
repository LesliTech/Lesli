/*

*/
import app from 'LesliCloud/vue/app'



// · Import apps and components
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
import componentList from './apps/list.vue'
import componentInvite from './apps/invite.vue'



// · Cloud app
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
app("AdminUsers", "[list]", "/admin/users", [{
    path :'/',
    component: componentList
}, {
    path :'/new',
    component: componentInvite
}])
