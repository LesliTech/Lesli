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
import { ref, reactive, onMounted, watch, computed, useSlots } from "vue"


// · 
const slots = useSlots()


// · defining emits
const emit = defineEmits(['click', 'sort', 'paginate', 'details']);


// · defining props
const props = defineProps({
    id: {
        type: String,
        require: false
    },
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
        required: true,
        default: []
    },
    link: {
        type: Function,
        required: false
    },
    href: {
        type: Function,
        required: false
    },
    headless: {
        type: Boolean,
        default: false
    }
})


// · define variables
const objectRecords = ref([])
const arrayRecords = ref([])

const currentSort = ref(null)
const currentSortDir = ref('asc')

const dropdownActive = ref([])

// · prepaer the CSS classes for every column in the header
function tableHeaderClass(column) {
    return {
        'has-text-centered': (column.field == 'id' || column.align == 'center') 
    }
}


// · prepaer the CSS classes for every column in the header
function tableBodyClass(column) {
    return {
        'has-text-centered': (column.field == 'id' || column.align == 'center') 
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


// · 
function openDetails(record) {
    record.detailActive = !record.detailActive
    setTimeout(() => { emit('details', record.detailActive) }, 500)
}

</script>
<template>
    <table 
        :id="props.id"
        class="table is-fullwidth lesli-table mb-5"
        :class="props.class">
        <thead v-if="!headless">
            <tr>

                <!--
                    Button to show/hide detail row
                -->
                <th v-if="slots.detail"></th>

                <!-- Define table header, we simple iterate over the defined fields -->
                <th 
                    @click.stop="sort(column)"
                    v-bind:width="column.width"
                    v-bind:class="tableHeaderClass(column)"
                    v-for="column in props.columns" :key="column.field">



                    <!--
                        Use a slot to render content, so it is possible to 
                        use html elements to render custom componentes for 
                        every column header of the table 
                    -->
                    <slot
                        :name="`head(${column.field})`" 
                        :column="column">

                        <!--
                            Render the default table header if not custom slot is provided
                        -->
                        <span v-if="!column.sort">
                            {{ column.label }}
                        </span>
                        <span class="icon-text" v-if="column.sort">
                            <span>
                                {{ column.label }}
                            </span>
                            <span class="icon">
                                <span class="material-icons" v-if="!currentSort">sort</span>
                                <span class="material-icons" v-if="(currentSort == column.field && currentSortDir == 'asc')">arrow_upward</span>
                                <span class="material-icons" v-if="(currentSort == column.field && currentSortDir == 'desc')">arrow_downward</span>
                            </span>
                        </span>

                    </slot>

                </th>

                <!-- 
                    Options header (empty by design)
                -->
                <th v-if="slots.options"></th>

                <th v-if="slots.buttons"></th>

            </tr>
        </thead>
        <tbody>

            <!-- 
                Wait until the store indicate that the request was completed, 
                create the table rows from records
            -->
            <template v-for="(record, i) in props.records" :key="`tr-${i}`">
                <tr>
                    

                    <!--
                        Button to show/hide detail row
                    -->
                    <td v-if="slots.detail" class="detail-row px-2 has-text-centered">
                        <button class="button is-white px-2" @click="openDetails(record)">
                            <span v-if="!record.detailActive" class="material-icons">
                                chevron_right
                            </span>
                            <span v-if="record.detailActive" class="material-icons">
                                expand_more
                            </span>
                        </button>
                    </td>


                    <!--
                        Rendering every defined column
                    -->
                    <td 
                        :class="tableBodyClass(column)"
                        v-on:click.stop="emit('click', record)"
                        v-for="(column, j) in props.columns" :key="`td-${j}`">


                        <!--
                            Print a standard vue router link if prop is provided and
                            there is not a slot for this specific column
                        -->
                        <router-link v-if="props.link && !slots[column.field]" :to="props.link(record).toString()">
                            {{ record[column.field] }}
                        </router-link>


                        <!--
                            Print a standard html anchor link if prop is provided and
                            there is not a slot for this specific column
                        -->
                        <a v-if="props.href && !slots[column.field]" :href="props.href(record)">
                            {{ record[column.field] }}
                        </a>


                        <!--
                            Use a slot to render content, so it is possible to 
                            use html elements to render custom componentes for 
                            every column of the table 
                            DO NOT print the slot if link or href is required

                            Slot has priority if we provided a slot for this specific column,
                            so, we should print the slot if slot is provided if not, we should
                            print the default slot if href or link prop was not provided :)
                        -->
                        <slot 
                            v-if="slots[column.field] || (!props.href && !props.link)"
                            :name="column.field"
                            :column="column"
                            :record="record"
                            :value="record[column.field]">

                            <!--
                                Print the text value if no custom slot is used
                                for the current column
                            -->
                            {{ record[column.field] }}

                        </slot>

                        

                    </td>


                    <!--
                        Dedicated options column
                        the dropdownActive[i] is to save the open/closed status of the dropdown for 
                        every row of the table (i)
                    -->
                    <td v-if="slots.options" class="options p-0">
                        <div :class="['dropdown', 'is-right is-hoverable', { 'is-active': dropdownActive[i] }, {'is-up': i==(props.records.length-1) }]">
                            <div class="dropdown-trigger">
                                <button class="button has-text-info" 
                                    @blur="dropdownActive[i] = false"
                                    @click="dropdownActive[i] = !dropdownActive[i]">
                                    <span class="icon">
                                        <span v-if="!dropdownActive[i]" class="material-icons md-24">
                                            more_vert
                                        </span>
                                        <span v-if="dropdownActive[i]" class="material-icons">
                                            more_horiz
                                        </span>
                                    </span>
                                </button>
                            </div>
                            <Transition>
                                <div v-if="dropdownActive[i]" class="dropdown-menu" role="menu">
                                    <div class="dropdown-content">
                                        <slot 
                                            name="options"
                                            :record="record"
                                            :value="record.id">
                                        </slot>
                                    </div>
                                </div>
                            </Transition>
                        </div>
                    </td>

                    <td v-if="slots.buttons" class="p-0">
                        <div class="buttons">
                            <slot 
                                name="buttons"
                                :record="record"
                                :value="record.id">
                            </slot>
                        </div>
                    </td>
                </tr>
                

                <!--
                    Dedicated row for detail, we can add an entire row to show some detail
                    about the current row
                    <tr v-if="record.detailActive">
                    <td class="is-paddingless" :colspan="props.columns.length + 1">
                        <slot name="detail" :record="record"></slot>
                    </td>
                </tr>
                -->
                <slot v-if="record.detailActive" name="detail" :record="record"></slot>
                
            </template>
        </tbody>
    </table>

    <!-- Show loading animation, this should be setted through the stores -->
    <lesli-loading v-if="loading"></lesli-loading>

    <!-- Show a message to indicate that there is no data to present -->
    <lesli-empty v-if="!loading && props.records && props.records.length < 1"></lesli-empty>

    <lesli-pagination v-if="props.pagination" :pagination="props.pagination" @paginate="paginate"></lesli-pagination>

</template>
    