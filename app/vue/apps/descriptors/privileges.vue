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
    label: 'name',
    field: 'controller' 
}, {
    label: 'Active',
    field: 'active'
}]


//
onMounted(() => {
    //storeSystemController.fetchControllers()
    setTimeout(() => storeDescriptor.fetchDescriptorPrivileges(), 2000)
    
})


//
function addPrivilege(action) {
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
        <lesli-tabs v-model="tab">
            <lesli-tab-item paddingless icon="list" title="Index">
                <lesli-table
                    headless
                    v-if="storeDescriptor.privileges.index"
                    :columns="columns"
                    :records="storeDescriptor.privileges.index">
                    <template #active="{ record }">
                        <lesli-toggle 
                            v-model="record.active"
                            @update:modelValue="addPrivilege(record)">
                        </lesli-toggle>
                    </template>
                </lesli-table>
            </lesli-tab-item>

            <lesli-tab-item paddingless icon="add" title="Create">
                <lesli-table
                    headless
                    v-if="storeDescriptor.privileges.create"
                    :columns="columns"
                    :records="storeDescriptor.privileges.create">
                    <template #active="{ record }">
                        <lesli-toggle 
                            v-model="record.active"
                            @update:modelValue="addPrivilege(record)">
                        </lesli-toggle>
                    </template>
                </lesli-table>
            </lesli-tab-item>

            <lesli-tab-item paddingless icon="edit" title="Update">
                <lesli-table
                    headless
                    v-if="storeDescriptor.privileges.update"
                    :columns="columns"
                    :records="storeDescriptor.privileges.update">
                    <template #active="{ record }">
                        <lesli-toggle 
                            v-model="record.active"
                            @update:modelValue="addPrivilege(record)">
                        </lesli-toggle>
                    </template>
                </lesli-table>
            </lesli-tab-item>

            <lesli-tab-item paddingless icon="visibility" title="Show">
                <lesli-table
                    headless
                    v-if="storeDescriptor.privileges.show"
                    :columns="columns"
                    :records="storeDescriptor.privileges.show">
                    <template #active="{ record }">
                        <lesli-toggle 
                            v-model="record.active"
                            @update:modelValue="addPrivilege(record)">
                        </lesli-toggle>
                    </template>
                </lesli-table>
            </lesli-tab-item>

            <lesli-tab-item paddingless icon="delete" title="Destroy">
                <lesli-table
                    headless
                    v-if="storeDescriptor.privileges.destroy"
                    :columns="columns"
                    :records="storeDescriptor.privileges.destroy">
                    <template #active="{ record }">
                        <lesli-toggle 
                            v-model="record.active"
                            @update:modelValue="addPrivilege(record)">
                        </lesli-toggle>
                    </template>
                </lesli-table>
            </lesli-tab-item>
        </lesli-tabs>
    </application-component>
</template>
