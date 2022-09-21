/**
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


// · Import main app
import app from "LesliVue/app"


// · Import apps and components
import appShow from "./apps/show.vue"
import appNew from "./apps/new.vue"

/*
// · 
app("Lesli", "[show]", "/administration/account", [{
    path: "/",
    component: appShow,
}, {
    path: "/new",
    component: appShow,
}])


// · 
app("Lesli", "[show]", "/account", [{
    path: "/new",
    component: appNew,
}])
*/

app("Lesli", "[show]", "/account/new", [{
    path: "/",
    component: appNew,
}])
