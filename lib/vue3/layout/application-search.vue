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
import { ref, reactive, onMounted, inject, watch } from "vue"


// · loading plugins
const url = inject('url')


// · import stores
import { useSearch } from "LesliVue/stores/search"


// · implement stores
const storeSearch = useSearch()


// · initialize container of (dynamic) columns
const columns = ref([])


// · dynamic update the columns with the result of the search
// · this must be dynamically because every search can return a different set of columns
watch(() => storeSearch.columns, (newColumns) => {
    columns.value = newColumns
})


// · go to search result view
// · TODO: this must be dynamic by engine
function goToResult(resource) {
    url.dl("projects/:id", resource.id).go()
}

</script>
<template>
    <section 
        v-if="storeSearch.text != ''"
        class="application-search">
        <lesli-table
            @click="goToResult"
            :pagination="false"
            :loading="false"
            :records="storeSearch.records"
            :columns="columns">
            <template #[column.field]="{ value }" v-for="(column) in columns">
                <span v-html="value"></span>
            </template>
        </lesli-table>
    </section>
</template>
