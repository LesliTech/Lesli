/*

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
