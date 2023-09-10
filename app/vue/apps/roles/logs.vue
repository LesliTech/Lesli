<script setup>
/*

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

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
