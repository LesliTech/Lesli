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
import { ref, reactive, onMounted, watch, computed } from "vue"


// · defining props
const props = defineProps({
    class: {
        type: String,
        required: false,
        default: "is-striped"
    },
    pagination: {
        type: [Object, Boolean],
        required: false
    },
    loading: {
        type: Boolean,
        default: false
    },
    columns: {
        type: Array,
        required: true
    },
    records: {
        type: Array,
        required: true
    }
})

// · define variables
const objectRecords = ref([])
const arrayRecords = ref([])


// · prepaer the CSS classes for every column in the header
function tableHeaderClass(column) {
    return {
        'has-text-centered': column.field == 'id'
    }
}


// · prepaer the CSS classes for every column in the header
function tableBodyClass(column) {
    return {
        'has-text-centered': column.field == 'id'
    }
}

function showRow(temp_company) {
    //We must use this.url function but compiler says it is undefined
    //Check this
    //this.url.go(`admin/temp_companies/${temp_company.id}`)
    window.location.href = `/admin/temp_companies/${temp_company.id}`;
}


</script>
<template>
    <div>
        <table 
            class="table is-fullwidth lesli-data-table"
            :class="props.class">
            <thead>
                <tr>

                    <!-- Define table header, we simple iterate over the defined fields -->
                    <th :class="tableHeaderClass(column)"
                        v-for="column in props.columns" 
                        :key="column.field">
                        {{ column.label }}
                    </th>

                </tr>
            </thead>
            <tbody>

                <!-- t
                    Wait until the store indicate that the request was completed, 
                    create the table rows from records
                -->
                <tr  v-show="!loading" 
                    v-for="(record, i) in props.records" :key="`tr-${i}`" :click="showRow(record)">

                    
                    <td 
                        :class="tableBodyClass(column)"
                        v-for="(column, j) in props.columns" :key="`td-${j}`">
                        {{ record[column.field] }}
                    </td>
                </tr>

            </tbody>
        </table>

        <!-- show special messages according according to table data -->
        <div>

            <!-- Show loading animation, this should be setted through the stores -->
            <lesli-data-loading v-if="loading"></lesli-data-loading>

            <!-- Show a message to indicate that there is no data to present -->
            <lesli-data-empty v-if="!loading && props.records.length < 1"></lesli-data-empty>

        </div>

        <nav v-if="props.pagination" 
            class="pagination" role="navigation" aria-label="pagination">
            <a class="pagination-previous">Previous</a>
            <a class="pagination-next">Next page</a>

            <ul class="pagination-list">
                <li>
                    <a class="pagination-link" aria-label="Goto page 1">1</a>
                </li>
                <li>
                    <span class="pagination-ellipsis">&hellip;</span>
                </li>
                <li>
                    <a class="pagination-link" aria-label="Goto page 45">45</a>
                </li>
                <li>
                    <a class="pagination-link is-current" aria-label="Page 46" aria-current="page">46</a>
                </li>
                <li>
                    <a class="pagination-link" aria-label="Goto page 47">47</a>
                </li>
                <li>
                    <span class="pagination-ellipsis">&hellip;</span>
                </li>
                <li>
                    <a class="pagination-link" aria-label="Goto page 86">86</a>
                </li>
            </ul>
        </nav>

    </div>
</template>
