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

// · import vue router composable
import { useRoute } from "vue-router"

// · import lesli stores
import { useUser } from "LesliVue/stores/user"

// · implement stores
const storeUser = useUser()

// · initialize/inject plugins
const route = useRoute()


onMounted(() => {
    storeUser.fetch(route.params?.id)
    storeUser.fetchSessions()
})


const translations = {
    users: I18n.t("core.users"),
    shared: I18n.t("core.shared")
}

const columns = [{
    field: 'id',
    label: 'ID'
}, {
    field: 'user_agent',
    label: 'Device'
}, {
    field: 'session_source',
    label: 'Source'
}, {
    field: 'created_at_date',
    label: 'Created at'
}, {
    field: 'last_used_at_string',
    label: 'Last used at'
}]

</script>
<template>
    <lesli-table
        :columns="columns"
        :records="storeUser.sessions">
    </lesli-table>
</template>
