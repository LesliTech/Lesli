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
import { ref, reactive, onMounted, watch, computed, inject } from "vue"
import { useRouter, useRoute } from 'vue-router'


// · import lesli stores
import { useIntegration } from "../../stores/integration"


// · initialize/inject plugins
const router = useRouter()
const msg = inject("msg")
const url = inject("url")


// · 
const storeIntegration = useIntegration()

// · 
const columns = [{
    field: "id",
    label: "ID"
}, {
    field: "name",
    label: "Name"
},  {
    field: "active",
    label: "Status"
}, {
    field: "usage_count",
    label: "Usage"
}, {
    field: "created_at",
    label: "Created at"
}, {
    field: "creator_name",
    label: "Created by"
}]


// · 
onMounted(() => {
    storeIntegration.fetch()
})

</script>
<template>
    <section class="application-component">
        <lesli-header 
            title="Integrations"
            add="Add integration">
            <lesli-button 
                icon="add"
                :to="url.admin('account/integrations/new')">
                Add integration
            </lesli-button>
        </lesli-header>
        <lesli-toolbar></lesli-toolbar>
        <lesli-table
            :columns="columns"
            :records="storeIntegration.records">
            <template #creator_name="{value, record}">
                <a :href="url.admin('users/:id', record.creator_id)">
                    {{ value }}
                </a>
            </template>
            <template #options="{ record, value }">
                <a class="dropdown-item" @click="storeIntegration.deleteIntegration(record.id)">
                    <span class="material-icons">
                        delete
                    </span>
                    <span>
                        Delete
                    </span>
                </a>
            </template>
        </lesli-table>
    </section>
</template>
