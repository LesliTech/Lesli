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
import app from "LesliVue/app"


// · Import pages
import pageList from "./pages/list.vue"
import pageNew from "./pages/new.vue"
import pageShow from "./pages/show.vue"
import pageEdit from "./pages/edit.vue"


// · Cloud app
app("Lesli", "[exchange_rates]", "/administration/account/currencies", [{
    path: "/:account_currency_id/exchange_rates",
    component: pageList
}, {
    path: "/:account_currency_id/exchange_rates/new",
    component: pageNew
}, {
    path: "/:account_currency_id/exchange_rates/:id",
    component: pageShow
},{
    path: "/:account_currency_id/exchange_rates/:id/edit",
    component: pageEdit
}],{
    exchange_rate: null,
    reload: {
        exchange_rate: false
    }
})
