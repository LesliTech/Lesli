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


// · import lesli stores
import { useRole } from "../../stores/role"
import { useDescriptor } from "../../stores/descriptor"


// · initialize/inject plugins
const msg = inject("msg")
const url = inject("url")


// · 
const storeRole = useRole()
const storeDescriptor = useDescriptor()


// · 
const columnDescriptors = [{
    field: 'name',
    label: 'Name'
},{
    field: 'action',
    label: 'Status',
    align: 'center'
}]


// · 
function updateDescriptor(descriptor) {
    storeRole.updateDescriptor(descriptor)
}

</script>
<template>
    <lesli-table 
        :columns="columnDescriptors"
        :records="storeRole.descriptorsCustom">
        <template #name="{ record }">
            <p>{{ record.name }}</p>
            <p><small>/{{ record.controller }}</small></p>
        </template>
        <template #action="{ record, value }">
            <lesli-toggle v-if="value != null" v-model="record.active" @change="updateDescriptor(record)">
            </lesli-toggle>
        </template>
    </lesli-table>
</template>
