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
import { inject, onMounted } from "vue"


// · import lesli stores
import { useDescriptor } from "../../../stores/descriptor"


// · import vue router composable
import { useRouter, useRoute } from "vue-router"


// · implement stores
const storeDescriptor = useDescriptor()


// · initialize/inject plugins
const router = useRouter()
const url = inject("url")
const route = useRoute()


// · defining props
const props = defineProps({
    isEditable: {
        type: Boolean,
        required: false,
        default: false,
    },
})


// · translations
const translations = {
    core: {
        roles: I18n.t("core.roles"),
        shared: I18n.t("core.shared"),
        role_descriptors: I18n.t('core.role_descriptors')
    }

}

/**
 * @description This function is used to update the descriptor information
 */
const onUpdate = () => {
    storeDescriptor.updateDescriptor()
}

/**
 * @description This function is used to create a new descriptor
 */
const onCreate = () => {
    storeDescriptor.createDescriptor()
}

onMounted(() => {
    if (!props.isEditable){
        storeDescriptor.resetDescriptor()
    } else {
        storeDescriptor.fetchDescriptor(route.params?.id)
    }
})

</script>
<template>
    <lesli-form 
        class="information"
        v-if="!storeDescriptor.loading"
        @submit="isEditable ? onUpdate() : onCreate()">

        <div class="field">
            <label class="label">
                {{ translations.core.view_text_name }}
                <sup class="has-text-danger">*</sup>
            </label>
            <div class="control">
                <input name="name" v-model="storeDescriptor.descriptor.name" required="required" type="text" class="input"> 
            </div>
        </div>

        <div class="field">
            <label class="label">
                {{ translations.core.role_descriptors.view_text_assign_parent_descriptor }}
            </label>
            <div class="control">
                <lesli-select
                    v-model="storeDescriptor.descriptor.descriptors_id"
                    :options="storeDescriptor.descriptors_options">
                </lesli-select>
            </div>
        </div>

        <div class="field">
            <label class="label">
                {{ translations.core.role_descriptors.column_description }}
            </label>
            <div class="control">
                <textarea class="textarea" v-model="storeDescriptor.descriptor.description"></textarea>
            </div>
        </div>

        <div class="field">
            <div class="control">
                <lesli-button icon="save">
                    {{ translations.core.shared.view_btn_save }}
                </lesli-button>       
            </div>
        </div>
    </lesli-form>
</template>
