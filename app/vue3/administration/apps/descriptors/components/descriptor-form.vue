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
import { inject, onMounted, ref, onUnmounted } from "vue"

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
    router.push(url.admin('descriptors').s)
}

const userRole = ref({ label:"", value:"" })

onMounted(() => {
    if (!props.isEditable){
        storeDescriptor.resetDescriptor()
    } else {
        storeDescriptor.fetchDescriptor(route.params?.id)
    }
})

</script>
<template>
    <form class="information" @submit.prevent="
            isEditable
                ? onUpdate()
                : onCreate()
    ">
        <div class="field is-horizontal">
            <div class="field-label">
                <label class="label">
                    {{ translations.core.view_text_name }}
                    <sup class="has-text-danger">*</sup>
                </label>
            </div>
            <div class="field-body">
                <div class="field is-narrow">
                    <div class="control">
                        <input name="name" v-model="storeDescriptor.descriptor.name" required="required" type="text" class="input"> 
                    </div>
                </div>
            </div>
        </div>

        <div class="field is-horizontal">
            <div class="field-label is-normal">
                <label class="label"> {{ translations.core.role_descriptors.view_text_assign_parent_descriptor }} </label>
            </div>
            <div class="field-body">
                <div class="field is-narrow">
                    <div class="control">
                        <div class="select is-fullwidth">
                            <!-- <lesli-select
                                v-model="storeDescriptor.descriptor.role_descriptors_id"
                            >
                            </lesli-select> -->
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="field is-horizontal">
            <div class="field-label">
                <label class="label">
                    {{ translations.core.role_descriptors.column_description }}
                    <sup class="has-text-danger">*</sup>
                </label>
            </div>
            <div class="field-body">
                <div class="field is-narrow">
                    <div class="control">
                        <textarea class="textarea" v-model="storeDescriptor.descriptor.description"></textarea>
                    </div>
                </div>
            </div>
        </div>


        <div class="field is-horizontal">
            <div class="field-label is-normal">
            </div>
            <div class="field-body">
                <div class="field">
                    <div class="control">
                        <lesli-button icon="save">
                            {{ translations.core.shared.view_btn_save }}
                        </lesli-button>                 
                    </div>
                </div>
            </div>
        </div>
    </form>

</template>
