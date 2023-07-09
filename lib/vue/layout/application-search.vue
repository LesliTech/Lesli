<script setup>
/*

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

*/



// · import vue tools
import { ref, reactive, onMounted, inject, watch } from "vue"


// · loading plugins
const url = inject('url')


// · import stores
import { useSearch } from "Lesli/shared/stores/search"


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
