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
import { useAccountIssues } from "../../stores/accountIssues"


// · initialize/inject plugins
const router = useRouter()
const route = useRoute()
const msg = inject("msg")
const url = inject("url")


// · 
const storeIssues = useAccountIssues()

const translations = {
    core: {
        roles: I18n.t("core.roles"),
        users: I18n.t("core.users"),
        shared: I18n.t("core.shared")
    }
}

// · 
const columns = [{
    field: "first_name",
    label: "first_name",
    sort: true
}, {
    field: "last_name",
    label: "last_name",
    sort: true
}, {
    field: "email",
    label: "email",
    sort: true
}, {
    field: "category",
    label: "category",
    sort: true
}]

// · 
onMounted(() => {
    storeIssues.fetch()
})


</script>
<template>
    <section class="application-component">
        <lesli-header title="Account Issues">
            <lesli-button
                outlined
                icon="refresh"
                :loading="storeIssues.loading"
                @click="storeIssues.fetch()"
            >
                {{ translations.core.shared.view_text_btn_reload }}
            </lesli-button>
        </lesli-header>
        <lesli-toolbar @search="storeIssues.search"></lesli-toolbar>
        <lesli-table
            :link="(issue) => url.admin(`account/issues/${issue.id}`).s"
            :columns="columns"
            :records="storeIssues.index.records"
            :pagination="storeIssues.index.pagination"
            @paginate="storeIssues.paginateIndex"
            @sort="storeIssues.sortIndex"
            >
        </lesli-table>
    </section>
</template>
