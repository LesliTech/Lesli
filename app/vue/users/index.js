/*

*/
import app from 'LesliCloud/vue/app'



// · Import apps and components
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
import componentList from './apps/user/list.vue'
import componentInvite from './apps/user/invite.vue'
import appNewUser from './apps/user/new.vue'
import appform from './apps/components/form.vue'



// · Cloud app
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
app("AdminUsers", "[list|new|show|edit]", "/admin/users", [{
    path :'/',
    component: componentList,
}, {
    path :'/new',
    component: appNewUser,
}, {
    path :'/invite',
    component: componentInvite,
},{
    path :'/:id',
    component: appform,
}])
