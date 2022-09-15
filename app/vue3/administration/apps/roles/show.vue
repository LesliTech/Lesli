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
import { useRole } from "../../stores/role"
import { useDescriptor } from "../../stores/descriptor"


// · initialize/inject plugins
const router = useRouter()
const route = useRoute()
const msg = inject("msg")
const url = inject("url")


// · 
const storeRole = useRole()
const storeDescriptor = useDescriptor()


// · 
const tab = ref(0)


// · 
onMounted(() => {
    storeRole.fetchRole(route.params.id)
})


// · :index, :show, :new, :edit, :create, :update, :destroy, :search
const columnDescriptors = [{
    field: 'name',
    label: 'Name'
},{
    field: 'index',
    label: 'index',
    align: 'center'
},{
    field: 'show',
    label: 'show',
    align: 'center'
},{
    field: 'create',
    label: 'create',
    align: 'center'
},{
    field: 'update',
    label: 'update',
    align: 'center'
},{
    field: 'destroy',
    label: 'destroy',
    align: 'center'
},{
    field: 'search',
    label: 'search',
    align: 'center'
}]


// · 
function matchRolesDescriptors() {
    storeRole.role.descriptors.forEach(describer => {
        let descriptor = storeDescriptor.list.find(descriptor => {
            return descriptor.id == describer.descriptors_id
        })
        if (descriptor) {
            descriptor.active = true
        }
    })
}


function updateDescriptor(descriptor) {
    storeRole.updateDescriptor(descriptor)
}

</script>x
<template>
    <section class="application-component">
        <lesli-header :title="'Privileges for: ' + storeRole.role.name + ' role '">
            <lesli-button icon="list" :to="url.admin('roles')">
                All roles
            </lesli-button>
            <lesli-button icon="edit" :to="url.admin('roles/:id/edit', storeRole.role.id)">
                Edit role
            </lesli-button>
        </lesli-header>
        <lesli-toolbar></lesli-toolbar>
        <lesli-table 
            :columns="columnDescriptors"
            :records="storeRole.descriptors">
            <template #head(index)="{ column }">
                <span class="icon-text">
                    <span class="icon">
                        <span class="material-icons">
                            format_list_bulleted
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
            <template #head(update)="{ column }">
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
            <template #head(search)="{ column }">
                <span class="icon-text">
                    <span class="icon">
                        <span class="material-icons">
                            search
                        </span>
                    </span>
                    <span>{{ column.label }}</span>
                </span>
            </template>

            <template #name="{ record }">
                <p>{{ record.name }}</p>
                <p><small>{{ record.path }}</small></p>
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
            <template #update="{ record, value }">
                <lesli-toggle v-if="value != null" v-model="record.update.active" @change="updateDescriptor(record.update)">
                </lesli-toggle>
            </template>
            <template #destroy="{ record, value }">
                <lesli-toggle v-if="value != null" v-model="record.destroy.active" @change="updateDescriptor(record.destroy)">
                </lesli-toggle>
            </template>
            <template #search="{ record, value }">
                <lesli-toggle v-if="value != null" v-model="record.search.active" @change="updateDescriptor(record.search)">
                </lesli-toggle>
            </template>
        </lesli-table>
    </section>
</template>
