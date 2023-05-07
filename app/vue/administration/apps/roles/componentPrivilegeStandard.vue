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


// · list, index, show, create, edit, delete
const columnDescriptors = [{
    field: 'name',
    label: 'Name'
},{
    field: 'index',
    label: 'Index',
    align: 'center'
},{
    field: 'show',
    label: 'Show',
    align: 'center'
},{
    field: 'create',
    label: 'Create',
    align: 'center'
},{
    field: 'edit',
    label: 'Edit',
    align: 'center'
},{
    field: 'destroy',
    label: 'Delete',
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
        :records="storeRole.descriptors">
        <template #head(index)="{ column }">
            <span class="icon-text">
                <span class="icon">
                    <span class="material-icons">
                        format_list_numbered
                    </span>
                </span>
                <span>{{ column.label }}</span>
            </span>
        </template>
        <template #head(show)="{ column }">
            <span class="icon-text">
                <span class="icon">
                    <span class="material-icons">
                        visibility
                    </span>
                </span>
                <span>{{ column.label }}</span>
            </span>
        </template>
        <template #head(create)="{ column }">
            <span class="icon-text">
                <span class="icon">
                    <span class="material-icons">
                        add
                    </span>
                </span>
                <span>{{ column.label }}</span>
            </span>
        </template>
        <template #head(edit)="{ column }">
            <span class="icon-text">
                <span class="icon">
                    <span class="material-icons">
                        edit
                    </span>
                </span>
                <span>{{ column.label }}</span>
            </span>
        </template>
        <template #head(destroy)="{ column }">
            <span class="icon-text">
                <span class="icon">
                    <span class="material-icons">
                        delete
                    </span>
                </span>
                <span>{{ column.label }}</span>
            </span>
        </template>

        <template #name="{ record }">
            <p>{{ record.name }}</p>
            <p><small>/{{ record.controller }}</small></p>
        </template>
        <template #list="{ record, value }">
            <lesli-toggle v-if="value != null" v-model="record.list.active" @change="updateDescriptor(record.list)">
            </lesli-toggle>
        </template>
        <template #index="{ record, value }">
            <lesli-toggle v-if="value != null" v-model="record.index.active" @change="updateDescriptor(record.index)">
            </lesli-toggle>
        </template>
        <template #show="{ record, value }">
            <lesli-toggle v-if="value != null" v-model="record.show.active" @change="updateDescriptor(record.show)">
            </lesli-toggle>
        </template>
        <template #create="{ record, value }">
            <lesli-toggle v-if="value != null" v-model="record.create.active" @change="updateDescriptor(record.create)">
            </lesli-toggle>
        </template>
        <template #edit="{ record, value }">
            <lesli-toggle v-if="value != null" v-model="record.edit.active" @change="updateDescriptor(record.edit)">
            </lesli-toggle>
        </template>
        <template #destroy="{ record, value }">
            <lesli-toggle v-if="value != null" v-model="record.destroy.active" @change="updateDescriptor(record.destroy)">
            </lesli-toggle>
        </template>
    </lesli-table>
</template>
