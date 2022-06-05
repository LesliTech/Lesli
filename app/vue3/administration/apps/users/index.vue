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
import { useRouter, useRoute } from 'vue-router'


// · import lesli stores
import { useUsers } from "LesliVue/stores/users"


// implement stores
const storeUsers = useUsers()


// · translations
const translations = {
    core: {
        roles: I18n.t("core.roles"),
        users: I18n.t("core.users"),
        shared: I18n.t("core.shared")
    }
}


// · initializing
onMounted(() => {
    storeUsers.fetchIndex()
})


// · 
const columns = [{
    field: "id",
    label: "ID",
    sort: true
}, {
    field: "name",
    label: "Name",
    sort: true
}, {
    field: "email",
    label: "Email",
    sort: true
}, {
    field: "roles",
    label: "Roles"
}, {
    field: "active",
    label: "Status",
    sort: true,
    custom: true
}, {
    field: "last_sign_in_at",
    label: "Last login",
    sort: true
}, {
    field: "last_activity_at",
    label: "Last activity"
}]


</script>
<script>
export default {
    methods: {
        showUser(user) {
            this.$router.push(this.url.admin("users/:id", user.id).toString())
        }
    }
}
</script>
<template>
    <section class="application-component">
        <lesli-header :title="translations.core.users.view_text_title_users">
        </lesli-header>
        <lesli-toolbar 
            :search-placeholder="translations.core.users.view_toolbar_filter_placeholder_search"
            @search="storeUsers.search"></lesli-toolbar>
        <lesli-table
            :loading="storeUsers.loading"
            :columns="columns"
            :records="storeUsers.index.records"
            :pagination="storeUsers.index.pagination"
            @click="showUser"
            @sort="storeUsers.sortIndex">

            <template #active="{ value }">
                <span class="tag is-success" v-if="value">
                    {{ translations.core.shared.view_text_active }}
                </span>
                <span class="tag is-warning" v-if="!value">
                    {{ translations.core.shared.view_text_inactive }}
                </span>
            </template>

        </lesli-table>
    </section>
</template>
