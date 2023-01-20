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
})


function selectOption (new_association){
    let selected_association = storeAssociation.options.find((association) =>{
        return association.workflow_for == new_association
    })

    if(selected_association){
        storeAssociation.association_details = {}
        selected_association.details.forEach((detail)=>{
            console.log(detail)

            detail.list.forEach((option)=>{
                storeAssociation.association_details[detail.field_name]= {
                    label: option.name,
                    value: option.id
                }

            })
        })

        console.log( storeAssociation.association_details)
        
    }

}


</script>

<template>
    <lesli-header title="Associations">
    </lesli-header>

    <form>
        <div class="columns is-marginless has-border-bottom">
                <!-- Association -->
                <div class="column">
                    <label class="label">
                        {{translations.associations.view_title_assign_to}}
                        <sup class="has-text-danger">*</sup>
                    </label>
                    <lesli-select
                        :options="storeAssociation.options_select"
                        v-model="new_association"
                        @change="selectOption(new_association)"
                    >
                    </lesli-select>
                    <p>{{ translations.associations.view_text_column_workflow_for_description }}</p>
                </div>

                <!-- Global assignment -->
                <div class="column">
                    <label class="label">
                        {{ translations.associations.column_global }}
                    </label>
                    <input type="checkbox" v-model="checked" >
                </div>

                
                <div class="column">

                    <div v-for="detail in storeAssociation.options['ticket'].details" 
                        :key="detail.field_name"
                    >
                        <label class="label">
                            {{ detail.field_name }}
                        </label>
                        <pre>{{ detail.field_name }}</pre>
                        <pre>{{  storeAssociation.association_details["ticket_type"] }}</pre>
                        <lesli-select
                            :options="storeAssociation.association_details[detail.field_name]"
                            v-model="new_association"
                        >
                        </lesli-select>
                        <p>{{ translations.associations.view_text_column_workflow_for_description }}</p>


                    </div>


 
                </div>
        </div>

        <div class="columns is-marginless has-border-bottom">

        </div>

    </form>


</template>
