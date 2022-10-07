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
import { useRole } from "../../stores/role"


// · initialize/inject plugins
const router = useRouter()
const route = useRoute()
const msg = inject("msg")
const url = inject("url")


// · 
const storeRole = useRole()
const actualPath = route.fullPath.slice(1)

// · 
const columns = [{
    field: "id",
    label: "ID"
}, {
    field: "name",
    label: "Name",
    sort: true
},  {
    field: "active",
    label: "Status",
    sort: true
}, {
    field: "usage_count",
    label: "Usage",
    sort: true
}, {
    field: "created_at",
    label: "Created at"
}, {
    field: "creator_name",
    label: "Created by"
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


// · 
function showRole(r) {
    router.push(url.root(props.appMountPath+`/${r.id}`).s)
}

</script>
<template>
    <section class="application-component">
        <lesli-header title="Roles & privileges">
            <lesli-button icon="add" :to="url.root(props.appMountPath+`/new`)">
                Create role
            </lesli-button>
        </lesli-header>
        <lesli-toolbar></lesli-toolbar>
        <lesli-table
            @click="showRole"
            :columns="columns"
            :records="storeRole.records"
            :pagination="storeRole.pagination">
            <template #active="{ value }">
                <span class="tag is-success is-light" v-if="value">active</span>
            </template>
        </lesli-table>
    </section>
</template>
