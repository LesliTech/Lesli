<script setup>
/*

Copyright (c) 2023, all rights reserved.

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
import { ref, reactive, onMounted, watch, computed, inject } from "vue"
import { useRouter, useRoute } from 'vue-router'


// · import lesli stores
import { useRole } from "../../stores/role"


// · initialize/inject plugins
const router = useRouter()
const route = useRoute()
const msg = inject("msg")
const url = inject("url")


// · 
const storeRole = useRole()

const translations = {
    core: {
        roles: I18n.t("core.roles"),
        users: I18n.t("core.users"),
        shared: I18n.t("core.shared"),
        role_activities: I18n.t('core.role/activities')
    }
}

// · 
const columns = [{
    field: "created_at_raw",
    label: translations.core.role_activities.column_created_at,
    sort: true
}, {
    field: "user_creator_name",
    label: translations.core.role_activities.column_users_id,
    sort: true
}, {
    field: "category",
    label: translations.core.role_activities.column_category,
    sort: true
}, {
    field: "description",
    label: translations.core.role_activities.column_description,
    sort: true
}, {
    field: "field_name",
    label: translations.core.role_activities.column_field,
    sort: true
}, {
    field: "value_from",
    label: translations.core.role_activities.column_value_from,
    sort: true
}, {
    field: "value_to",
    label: translations.core.role_activities.column_value_to,
    sort: true
}]


// · 
onMounted(() => {
    storeRole.fetchLogs()
})


</script>
<template>
    <lesli-table
        :columns="columns"
        :records="storeRole.role_activities"
        >
    </lesli-table>
</template>
