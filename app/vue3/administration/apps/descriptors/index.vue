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
const msg = inject("msg")
const url = inject("url")


// · 
const storeDescriptor = useDescriptor()


// · 
const columns = [{
    field: "id",
    label: "ID"
}, {
    field: "name",
    label: "Name",
    sort: true
},  {
    field: "reference",
    label: "Reference",
    sort: true
}, {
    field: "path",
    label: "Path",
    sort: true
}, {
    field: "updated_at",
    label: "Updated at"
}]


// · 
onMounted(() => {
    storeDescriptor.fetch()
})


// · 
function showDescriptor(d) {
    router.push(url.admin("descriptors/:id", d.id).s)
}

</script>
<template>
    <section class="application-component">
        <lesli-header title="Role Descriptors"></lesli-header>
        <lesli-toolbar></lesli-toolbar>
        <lesli-table
            @click="showDescriptor"
            :columns="columns"
            :records="storeDescriptor.records"
            :pagination="storeDescriptor.pagination"
        ></lesli-table>
    </section>
</template>
