<script setup>
/*
Copyright (c) 2023, all rights reserved.

All the information provided by this platform is protected by international laws related to
industrial property, intellectual property, copyright and relative international laws.
All intellectual or industrial property rights of the code, texts, trade mark, design,
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~ ~·~ ~·~ ~·~ ~·~ ~·~ ~·~ ~·~ ~·~ ~·~ ~·~ ~·~
// ·
*/

// · import vue tools
import { onMounted } from "vue"

// · import store
import { useCloudObjectAction } from "LesliVue/stores/cloud-objects/action"

// · import components


// · defining translations
const translations = {
    core: ("core.shared")
}

// · implement store
const actionStore = useCloudObjectAction()

// · defining props
const props = defineProps({
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
    // · prop that indicates the object id of the resource that you need to interact with.
    cloudObjectId: {
        type: String,
        required: true,
    }
})


onMounted(() => {

})
</script>

<template>


        <h4 class=" title is-4">
            {{ translations.core.view_text_quick_actions }}
        </h4>

        <form @submit="">
            <fieldset>
                <div class="columns">
                    <div class="column is-8">
                        <div class="field">
                            <label class="label">{{ translations.core.view_text_cloud_object_actions_add_new_group }}<sup class="has-text-danger">*</sup></label>
                            <div class="control">
                                <input class="input" type="text" v-model="actionStore.new_group_name" required>
                            </div>
                        </div>
                    </div>

                    <div class="column is-4">
                        <div class="field">
                            <label class="label">&nbsp;</label>
                            <div class="control">
                                <lesli-button icon="add">
                                    {{ translations.core.view_btn_add }}
                                </lesli-button> 
                            </div>
                        </div>
                    </div>
                
                </div>
            </fieldset>
        </form>

        <div>

        </div>


        
    
</template>
