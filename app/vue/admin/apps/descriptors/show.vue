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
import { inject, onMounted, ref } from "vue"


// · import lesli stores
import { useDescriptor } from "LesliApp/administration/stores/descriptor"
import { useSystemController } from "LesliApp/administration/stores/systemController"


// · import vue router composable
import { useRouter, useRoute } from "vue-router"


// · initialize/inject plugins
const route = useRoute()
const url = inject("url")


// · implement stores
const storeDescriptor = useDescriptor()
const storeSystemController = useSystemController()


// · translations
const translations = {
    core: {
        roles: I18n.t("core.roles"),
        shared: I18n.t("core.shared"),
        descriptors: I18n.t('core.role_descriptors')
    }

}


//
const tab = ref(0)


//
const columns = [{
    field: 'controller',
    label: 'Controller'
},{
    field: 'list_action',
    label: 'List',
    align: 'center'
},{
    field: 'index_action',
    label: 'Index',
    align: 'center'
},{
    field: 'show_action',
    label: 'Show',
    align: 'center'
},{
    field: 'create_action',
    label: 'Create',
    align: 'center'
},{
    field: 'update_action',
    label: 'Update',
    align: 'center'
},{
    field: 'destroy_action',
    label: 'Delete',
    align: 'center'
}]


//
onMounted(() => {
    storeDescriptor.$reset()
    storeDescriptor.fetchDescriptor(route.params.id)
})


//
function addPrivilege(action) {

    console.log(action)

    return 
    if (action.active) {
        storeDescriptor.postDescriptorPrivilege(action)
    } else {
        storeDescriptor.deleteDescriptorPrivilege(action)
    }
}

</script>
<template>
    <application-component>
        <lesli-header :title="'Descriptor: '+storeDescriptor.descriptor.name">
        </lesli-header>

        <lesli-table
            :columns="columns"
            :records="storeDescriptor.privileges"
            :loading="storeDescriptor.privilegesLoading">


            <!-- table header -->

            <template #head(list_action)="{ column }">
                <span class="icon-text">
                    <span class="icon">
                        <span class="material-icons">
                            format_list_bulleted
                        </span>
                    </span>
                    <span>{{ column.label }}</span>
                </span>
            </template>

            <template #head(index_action)="{ column }">
                <span class="icon-text">
                    <span class="icon">
                        <span class="material-icons">
                            format_list_numbered
                        </span>
                    </span>
                    <span>{{ column.label }}</span>
                </span>
            </template>

            <template #head(show_action)="{ column }">
                <span class="icon-text">
                    <span class="icon">
                        <span class="material-icons">
                            visibility
                        </span>
                    </span>
                    <span>{{ column.label }}</span>
                </span>
            </template>

            <template #head(create_action)="{ column }">
                <span class="icon-text">
                    <span class="icon">
                        <span class="material-icons">
                            add
                        </span>
                    </span>
                    <span>{{ column.label }}</span>
                </span>
            </template>

            <template #head(update_action)="{ column }">
                <span class="icon-text">
                    <span class="icon">
                        <span class="material-icons">
                            edit
                        </span>
                    </span>
                    <span>{{ column.label }}</span>
                </span>
            </template>
            
            <template #head(destroy_action)="{ column }">
                <span class="icon-text">
                    <span class="icon">
                        <span class="material-icons">
                            delete
                        </span>
                    </span>
                    <span>{{ column.label }}</span>
                </span>
            </template>


            <!-- table content -->

            <template #list_action="{ record, value }">
                <lesli-toggle v-if="value" v-model="record.actionlist" @update:modelValue="addPrivilege(record)">>
                </lesli-toggle>
            </template>

            <template #index_action="{ record, value }">
                <lesli-toggle v-if="value" v-model="record.index_active" @update:modelValue="addPrivilege(record)">>
                </lesli-toggle>
            </template>

            <template #show_action="{ record, value }">
                <lesli-toggle v-if="value" v-model="record.show_active" @update:modelValue="addPrivilege(record)">>
                </lesli-toggle>
            </template>

            <template #create_action="{ record, value }">
                <lesli-toggle v-if="value" v-model="record.create_active" @update:modelValue="addPrivilege(record)">>
                </lesli-toggle>
            </template>

            <template #update_action="{ record, value }">
                <lesli-toggle v-if="value" v-model="record.update_active" @update:modelValue="addPrivilege(record)">>
                </lesli-toggle>
            </template>

            <template #destroy_action="{ record, value }">
                <lesli-toggle v-if="value" v-model="record.destroy_active" @update:modelValue="addPrivilege(record)">>
                </lesli-toggle>
            </template>
        </lesli-table>
    </application-component>
</template>
