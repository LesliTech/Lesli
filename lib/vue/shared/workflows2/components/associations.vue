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
import { onMounted } from "vue"

// · import stores
import { useAssociations } from "Lesli/stores/shared/workflows/associations"


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

/**
 * @description This function is used to select an option for association
 */
function selectOption (new_association){
    let selected_association = storeAssociation.options.find((association) =>{
        return association.workflow_for == new_association
    })

    if(selected_association){
        storeAssociation.association_details = {}

        storeAssociation.association_details = selected_association

        storeAssociation.select_details = {}

        Object.values(storeAssociation.association_details.details).forEach((detail)=>{
            storeAssociation.select_details[detail.field_name] = []
            
            detail.list.forEach((list_item)=>{
                storeAssociation.select_details[detail.field_name].push({
                    label: list_item.name,
                    value: list_item.id
                })
            })
        })
        
    } else {
        storeAssociation.select_details = []
    }

}

</script>

<template>
    <lesli-header title="Associations"></lesli-header>

    <div class="block">
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

                        <div v-for="detail in storeAssociation.select_details" 
                            :key="detail"
                        >
                            <label class="label">
                                {{ Object.keys(storeAssociation.select_details).find(key => storeAssociation.select_details[key] === detail) }}
                            </label>
                            <lesli-select
                                :options="detail"
                                v-model="storeAssociation.association[Object.keys(storeAssociation.select_details).find(key => storeAssociation.select_details[key] === detail)]"
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
    </div>

    <div class="block">
        <lesli-table
        :records="storeAssociation.associations"
        :columns="columns"
        v-if="storeAssociation.associations.length > 0 " 
        >
            <template #buttons="{ record }">
                <button class="button is-outlined is-danger" @click="storeAssociation.deleteAssociation(record.id)">
                    <span class="material-icons">
                        delete
                    </span>
                </button>
            </template>


            <template #global="{ value }">
                <span class="tag is-success" v-if="value">
                    {{ translations.core.view_text_yes}}
                </span>
                <span class="tag is-warning" v-if="!value">
                    {{ translations.core.view_text_no }}
                </span>
            </template> 


        </lesli-table>
    </div>

</template>
