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
    //storeSystemController.fetchControllers()
    storeDescriptor.fetchDescriptor(route.params.id)
    //setTimeout(() => storeDescriptor.getDescriptorPrivileges(), 2000)
    
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
