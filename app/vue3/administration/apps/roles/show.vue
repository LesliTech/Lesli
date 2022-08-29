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
    field: 'name',
    label: 'Name'
},{
    field: 'code',
    label: 'Code'
},{
    field: 'path',
    label: 'Path'
}]

</script>
<template>
    <section class="application-component">
        <lesli-header :title="'Role: '+storeRole.role.name"></lesli-header>
        <lesli-tabs v-model="tab">
            <lesli-tab-item title="Descriptors">
                <lesli-table 
                    :columns="columnDescriptors"
                    :records="storeRole.role.descriptors">
                </lesli-table>
            </lesli-tab-item>
            <lesli-tab-item title="Privileges">
            </lesli-tab-item>
        </lesli-tabs>
        {{ storeRole.role }}
    </section>
</template>
