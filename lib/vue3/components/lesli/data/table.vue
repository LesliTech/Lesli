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
    loading: {
        type: Boolean,
        default: false
    },
    columns: {
        type: Array,
        required: true
    },
    data: {
        type: Array,
        required: true
    }
})


// · define variables



// prepaer the CSS classes for every column in the header
function tableHeaderClass(column) {
    return {
        'has-text-centered': column.field == 'id'
    }
}

// prepaer the CSS classes for every column in the header
function tableBodyClass(column) {
    return {
        'has-text-centered': column.field == 'id'
    }
}

</script>
<template>
    <div>
        <table class="table lesli-data-table is-fullwidth is-striped">
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

                <!-- 
                    Wait until the store indicate that the request was completed, 
                    create the table rows
                -->
                <tr v-if="!loading"
                    v-for="data in props.data">

                    <!-- Render table columns -->
                    <td 
                        :class="tableBodyClass(column)"
                        v-for="column in props.columns">
                        {{ data[column.field] }}
                    </td>
                </tr>

            </tbody>
            <tfoot>
                <tr>

                    <!-- show special messages according according to table data -->
                    <td :colspan="props.columns.length">

                        <!-- Show loading animation, this should be setted through the stores -->
                        <lesli-data-loading v-if="loading"></lesli-data-loading>

                        <!-- Show a message to indicate that there is no data to present -->
                        <lesli-data-empty v-if="!loading && props.data.length < 1"></lesli-data-empty>

                    </td>

                </tr>
            </tfoot>
        </table>

        <nav class="pagination" role="navigation" aria-label="pagination">
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
