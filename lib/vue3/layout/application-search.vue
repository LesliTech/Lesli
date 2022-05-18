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
import { ref, reactive, onMounted, inject } from "vue"


// · import stores
import { useCoreSearch } from "LesliVue/stores/search"


// · implement stores
const coreSearch = useCoreSearch()


// · 
const columns = [{
    field: "id",
    label: "ID"
}, {
    field: "email",
    label: "Email"
}, {
    field: "active",
    label: "Active"
}, {
    field: "category",
    label: "Category"
}, {
    field: "alias",
    label: "Alias"
}]

</script>
<template>
    <section 
        v-if="coreSearch.text != ''"
        class="application-search">
        <div class="content box py-4">
            <lesli-data-table
                class=""
                :pagination="false"
                :loading="false"
                :records="coreSearch.records"
                :columns="columns">
            </lesli-data-table>
        </div>
    </section>
</template>
