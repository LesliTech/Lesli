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


// · 
const translations = {
    core: {
        roles: I18n.t("core.roles"),
        users: I18n.t("core.users"),
        shared: I18n.t("core.shared")
    }
}


// · 
const columns = [{
    field: "name",
    label: translations.core.shared.view_text_name,
    sort: true
}, {
    field: "users",
    label: translations.core.roles.view_text_users || 'Users',
    sort: true
}, {
    field: "isolated",
    label: translations.core.roles.view_text_isolated || 'Isolated',
    sort: true
}, {
    field: "active",
    label: translations.core.users.view_table_header_status,
    sort: true
}]


// · defining props
const props = defineProps({
    appMountPath: {
        type: String,
        required: false,
        default: "administration/roles",
    }
})


// · 
onMounted(() => {
    storeRole.fetch()
})


</script>
<template>
    <section class="application-component">
        <lesli-header title="Roles & privileges">
            <lesli-button
                outlined
                icon="refresh"
                :loading="storeRole.loading"
                @click="storeRole.fetch()"
            >
                {{ translations.core.shared.view_text_btn_reload }}
            </lesli-button>
            <lesli-button icon="add" :to="url.root(props.appMountPath+`/new`)">
                {{ translations.core.roles.view_btn_new_role }}
            </lesli-button>
        </lesli-header>
        <lesli-toolbar @search="storeRole.search"></lesli-toolbar>
        <lesli-table
            :link="(role) => url.root(props.appMountPath+`/${role.id}`).s"
            :columns="columns"
            :records="storeRole.records"
            :pagination="storeRole.index.pagination"
            @paginate="storeRole.paginateIndex"
            @sort="storeRole.sortIndex"
            >
            <template #active="{ value }">
                <span class="tag is-success is-light" v-if="value">active</span>
            </template>

            <template #options="{ record, value }">
                <a class="dropdown-item" :href="url.root(props.appMountPath+`/${record.id}`)">
                    <span class="material-icons">
                        settings
                    </span>
                    <span>
                        {{ translations.core.roles.view_btn_edit_privilege_actions }}
                    </span>
                </a>
                <a class="dropdown-item" :href="url.root(props.appMountPath+`/${record.id}/edit`)">
                    <span class="material-icons">
                        edit
                    </span>
                    <span>
                        {{ translations.core.roles.view_btn_edit_role_information }}
                    </span>
                </a>
                <a class="dropdown-item" :href="url.admin(`users`).filter({ role: [record.id] })">
                    <span class="material-icons">
                        groups
                    </span>
                    <span>
                        {{ translations.core.roles.view_btn_users_list }}
                    </span>
                </a>
                <a class="dropdown-item" @click="storeRole.deleteRole(record.id)">
                    <span class="material-icons">
                        delete
                    </span>
                    <span>
                        {{ translations.core.users.view_btn_revoke_access }}
                    </span>
                </a>
            </template>

        </lesli-table>
    </section>
</template>
