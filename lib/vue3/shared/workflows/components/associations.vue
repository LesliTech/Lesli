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
import { onMounted } from "vue"
import { useRouter, useRoute } from 'vue-router'


// · import stores
import { useAssociations } from "LesliVue/stores/shared/workflows/associations"

// · import components


// · defining props
const props = defineProps({
    appMountPath: {
        type: String,
        required: false,
        default: "",
    },
    // · prop that indicates the cloud module that will be used for interacting with the backend.
    cloudModule: {
        type: String,
        required: true,
    },
    // · prop that indicates the resource that you need to interact with.
    cloudObject: {
        type: Object,
        required: true,
    },
})

// · implement stores
const storeAssociation = useAssociations()

// · translations
const translations = {
    core: I18n.t('core.shared'),
    associations: I18n.t('core.workflow/associations')
}

onMounted(() => {
    // · get workflow association options
    storeAssociation.getAssociationOptions()
    storeAssociation.getAssociations()
})

//. · columns of the table
const columns = [
    {
        field: "workflow_for",
        label: translations.associations.column_workflow_for,
    },
    {
        field: "global",
        label: translations.associations.column_global,
    },
    {
        field: "details",
        label: translations.associations.view_table_header_details,
    }
]


function selectOption (new_association){
    let selected_association = storeAssociation.options.find((association) =>{
        return association.workflow_for == new_association
    })

    if(selected_association){
        storeAssociation.association_details = {}
        selected_association.details.forEach((detail)=>{

            detail.list.forEach((option)=>{
                storeAssociation.association_details[detail.field_name]= {
                    label: option.name,
                    value: option.id
                }

            })
        })
        
    }

}


</script>

<template>
    <lesli-header title="Associations">
    </lesli-header>

    <form @submit.prevent="storeAssociation.postAssociation">
        <div class="columns is-marginless has-border-bottom">
                <!-- Association -->
                <div class="column is-4">
                    <label class="label">
                        {{translations.associations.view_title_assign_to}}
                        <sup class="has-text-danger">*</sup>
                    </label>
                    <lesli-select
                        :options="storeAssociation.options_select"
                        v-model="storeAssociation.association.workflow_for"
                        @change="selectOption(storeAssociation.association.workflow_for)"
                    >
                    </lesli-select>
                    <p>{{ translations.associations.view_text_column_workflow_for_description }}</p>
                </div>

                <!-- Global assignment -->
                <div class="column is-4" v-if="storeAssociation.association.workflow_for">
                    <label class="label">
                        {{ translations.associations.column_global }}
                    </label>
                    <input type="checkbox" v-model="storeAssociation.association.global">
                    <span v-if="storeAssociation.association.global"> {{translations.core.view_text_yes}} </span>
                    <span v-else> {{translations.core.view_text_no}} </span>
                </div>

                <div class="column is-4" v-if="!storeAssociation.association.global && storeAssociation.association.workflow_for">


                    <div v-for="detail in storeAssociation.association_details" 
                        :key="detail.id"
                    >
                        <lesli-select
                            :options="detail"
                            v-model="new_association"
                        >
                        </lesli-select>
                        <p>{{ translations.associations.view_text_column_workflow_for_description }}</p>


                    </div>


 
                </div>
        </div>
        <div class="columns is-marginless has-border-bottom">
            <div class="column">
                <lesli-button icon="save">
                    save
                </lesli-button>  
            </div>
        </div>
    </form>

    <br>

    <lesli-table
        :records="storeAssociation.associations"
        :columns="columns" 
    >
        <template #options="{ record }">
                <a class="dropdown-item" @click="storeAssociation.deleteAssociation(record.id)">
                    <span class="material-icons">
                        delete
                    </span>
                    <span>
                        Delete
                    </span>
                </a>
        </template>
    </lesli-table>


</template>
