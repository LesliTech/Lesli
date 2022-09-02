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
import { useDescriptor } from "../../stores/descriptor"


// · initialize/inject plugins
const router = useRouter()
const route = useRoute()
const msg = inject("msg")
const url = inject("url")


// · 
const storeRole = useRole()
const storeDescriptor = useDescriptor()


// · 
const tab = ref(0)


// · 
onMounted(() => {
    storeRole.fetchRole(route.params.id)
})


// · 
const columnDescriptors = [{
    field: 'id',
    label: 'ID'
},{
    field: 'active',
    label: 'Active',
    align: 'center'
},{
    field: 'name',
    label: 'Name'
},{
    field: 'code',
    label: 'Code'
},{
    field: 'path',
    label: 'Path'
}]

function matchRolesDescriptors() {
    storeRole.role.descriptors.forEach(describer => {
        let descriptor = storeDescriptor.list.find(descriptor => {
            return descriptor.id == describer.descriptors_id
        })
        if (descriptor) {
            descriptor.active = true
        }
    })
}


function changeDescriptor(descriptor) {
    storeRole.changeDescriptor(descriptor)
}

</script>
<template>
    <section class="application-component">
        <lesli-header :title="'Privileges for: ' + storeRole.role.name + ' role '">
            <lesli-button icon="list" :to="url.admin('roles')">
                All roles
            </lesli-button>
            <lesli-button icon="edit" :to="url.admin('roles/:id/edit', storeRole.role.id)">
                Edit role
            </lesli-button>
        </lesli-header>
        <lesli-toolbar></lesli-toolbar>
        <lesli-table 
            :columns="columnDescriptors"
            :records="storeRole.descriptors">
            <template #active="{ record }">
                <lesli-toggle v-model="record.active" @change="changeDescriptor(record)">
                </lesli-toggle>
            </template>
        </lesli-table>
    </section>
</template>
