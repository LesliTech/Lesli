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


// · 
import app from 'LesliVue/app'



// · 
import pageList from './pages/list.vue'
import pageShow from './pages/show.vue'
import pageEdit from './pages/edit.vue'
import pageNew from './pages/new.vue'



// · 
app("Administration", "[list|new|edit|show]", "/administration/roles", [{
    path: '/',
    component: pageList
}, {
    path: '/new',
    component: pageNew
}, {
    path: '/:id',
    component: pageShow
}, {
    path: '/:id/edit',
    component: pageEdit
}])
