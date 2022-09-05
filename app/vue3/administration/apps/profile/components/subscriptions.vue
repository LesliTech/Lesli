<script setup>
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


// · import vue tools
import { ref, reactive, onMounted, watch, computed } from "vue"


// · import lesli stores
import { useUser } from "LesliVue/stores/user"

// · implement stores
const storeUser = useUser()

const engine = ref({ label:"", value:"" })


onMounted(() => {
    storeUser.getSubscriptionsOptions ()
})

function selectEngine(){
    storeUser.getSubscriptions(engine.value.value)

}


const translations = {
    users: I18n.t("core.users"),
    shared: I18n.t("core.shared")
}

const columns = [{
    field: 'action',
    label: 'action'
}, {
    field: 'notification_type',
    label: 'Notification type'
}, {
    field: 'created_at',
    label: 'Created at'
}]

</script>
<template>

    <div>
        <lesli-select
            :options="storeUser.options.engines"
            @change="selectEngine"
            v-model="engine">
        </lesli-select>
    </div>
    <lesli-table
        :columns="columns"
        :records="storeUser.subscriptions">
    </lesli-table>


    
</template>
    