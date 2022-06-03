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


// · 
import Pagination from "LesliVue/lesli/components/pagination/Pagination.vue"


// · defining emits
const emit = defineEmits(['click', 'sort', 'paginate']);


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

const currentSort = ref(null)
const currentSortDir = ref('asc')


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


// · 
function sort(column) {

    if (!column.sort) {
        return 
    }

    if(column.field === currentSort.value) {
      currentSortDir.value = currentSortDir.value === 'asc' ? 'desc' : 'asc';
    }

    currentSort.value = column.field;

    emit('sort', currentSort.value, currentSortDir.value)

}


// · emit the page selected received from the pagination component
function paginate(page) {
    emit('paginate', page)
}

</script>
<template>
    <div>
        <table 
            class="table is-fullwidth lesli-table"
            :class="props.class">
            <thead>
                <tr>

                    <!-- Define table header, we simple iterate over the defined fields -->
                    <th :class="tableHeaderClass(column)"
                        v-on:click.stop="sort(column)"
                        v-for="column in props.columns" :key="column.field">
                        <span v-if="!column.sort">
                            {{ column.label }}
                        </span>
                        <span class="icon-text" v-if="column.sort">
                            <span>
                                {{ column.label }}
                            </span>
                            <span class="icon">
                                <span class="material-icons" v-if="(currentSort == column.field && currentSortDir == 'asc')">arrow_upward</span>
                                <span class="material-icons" v-if="(currentSort == column.field && currentSortDir == 'desc')">arrow_downward</span>
                            </span>
                        </span>
                    </th>

                </tr>
            </thead>
            <tbody>

                <!-- 
                    Wait until the store indicate that the request was completed, 
                    create the table rows from records
                -->
                <tr  
                    v-on:click.stop="emit('click', record)"
                    v-for="(record, i) in props.records" :key="`tr-${i}`">
                    
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
            <lesli-loading v-if="loading"></lesli-loading>

            <!-- Show a message to indicate that there is no data to present -->
            <lesli-empty v-if="!loading && props.records && props.records.length < 1"></lesli-empty>

        </div>

        <Pagination v-if="props.pagination" :pagination="props.pagination" @paginate="paginate"></Pagination>

    </div>
</template>
