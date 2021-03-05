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



// · Import main app
import app from "LesliVue/app"
import router from "LesliVue/functions/router.js"


// · Import apps and components
import pageList from "./pages/list.vue"


// · 
app("Lesli", "[new|list|show]", "/administration/account/settings", router.for_lesli([{
    path: "/",
    component: pageList,
}]))
