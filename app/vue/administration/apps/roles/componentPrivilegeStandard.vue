<script setup>
/*

Copyright (c) 2023, all rights reserved.

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


// · :index, :show, :new, :edit, :create, :update, :destroy, :search
const columnDescriptors = [{
    field: 'name',
    label: ''
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
    field: 'update',
    label: 'Update',
    align: 'center'
},{
    field: 'destroy',
    label: 'Destroy',
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
                        list
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
        <template #head(new)="{ column }">
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
            {{ record.name }}
        </template>
        <template #index="{ record, value }">
            <lesli-toggle 
                v-if="record.has_index" 
                v-model="record.privilege_index" 
                @change="updateDescriptor(record.index)">
            </lesli-toggle>
        </template>
        <template #show="{ record, value }">
            <lesli-toggle 
                v-if="record.has_show" 
                v-model="record.privilege_show" 
                @change="updateDescriptor(record.show)">
            </lesli-toggle>
        </template>
        <template #create="{ record, value }">
            <lesli-toggle 
                v-if="record.has_create" 
                v-model="record.privilege_create" 
                @change="updateDescriptor(record.create)">
            </lesli-toggle>
        </template>
        <template #update="{ record, value }">
            <lesli-toggle 
                v-if="record.has_update" 
                v-model="record.privilege_update" 
                @change="updateDescriptor(record.update)">
            </lesli-toggle>
        </template>
        <template #destroy="{ record, value }">
            <lesli-toggle 
                v-if="record.has_destroy" 
                v-model="record.privilege_destroy" 
                @change="updateDescriptor(record.destroy)">
            </lesli-toggle>
        </template>
    </lesli-table>
</template>
