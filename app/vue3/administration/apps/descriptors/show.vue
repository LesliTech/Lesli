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
import { useDescriptor } from "../../stores/descriptor"


// · initialize/inject plugins
const router = useRouter()
const route = useRoute()
const msg = inject("msg")
const url = inject("url")


// · 
const storeDescriptor = useDescriptor()


// · 
onMounted(() => {
    storeDescriptor.fetchDescriptor(route.params.id)
})


const columns = [{
    field: 'id',
    label: 'ID'
}, {
    field: 'active',
    label: 'Active'
}, {
    field: 'controller',
    label: 'Controller'
}, {
    field: 'action',
    label: 'Action'
}, {
    field: 'created_at',
    label: 'Created at'
}]

</script>
<template>
    <section class="application-component">
        <lesli-header :title="storeDescriptor.descriptor.name">
            <lesli-button icon="format_list_numbered">
                descriptors
            </lesli-button>
        </lesli-header>
        <lesli-table
            :columns="columns"
            :records="storeDescriptor.descriptor.privileges">
            <template #active="{ value }">
                <span class="tag is-success is-light" v-if="value">active</span>
            </template>
        </lesli-table>
    </section>
</template>
