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
import { inject, onMounted, watch } from "vue"

// · import stores
import { useDashboard } from "LesliVue/stores/shared/dashboard"

// · import vue router composable
import { useRouter, useRoute } from "vue-router"

// · implement stores
const storeDashboard = useDashboard()

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
    appMountPath: {
        type: String,
        required: false,
        default: "",
    }
})


// · translations
const translations = {
    dashboards: I18n.t('core.dashboards'),
    components: I18n.t('core.dashboard/components'),
    core: I18n.t('core.shared'),
    roles: I18n.t('core.roles'),
    main: I18n.t(`${storeDashboard.cloudModule}.dashboards`),
    main_components: I18n.t(`${storeDashboard.cloudModule}.dashboard/components`)
}



/**
 * @description This function is used to update the workflow information
 */
const onUpdate = () => {
    storeDashboard.updateDashboard()
}

/**
 * @description This function is used to create a new workflow
 */
const onCreate = () => {
    storeDashboard.postDashboard().then(()=> {
        router.push(url.root(`${props.appMountPath}`).s)
    })
}


onMounted(() => {
    if (!props.isEditable){
        storeDashboard.resetDashboard()
    } else {
        storeDashboard.fetchDashboard(route.params?.id).then(()=>{
        })      
    }
})

</script>
<template>
    <div class="block">
        <fieldset>
            <form class="mb-4" 
                v-if="!storeDashboard.loading" 
                @submit.prevent="isEditable ? onUpdate() : onCreate()"
            >

               
                <div class="columns">
                    <div class="column is-4">
                         <!-- Name -->
                        <div class="field">
                            <label class="label">
                                {{translations.dashboards.column_name}}
                                <sup class="has-text-danger">*</sup>
                            </label>
                            <div class="control">
                                <input class="input" type="text" v-model="storeDashboard.dashboard.name" required>
                            </div>
                        </div>
                    </div>

                    <div class="column is-4">
                        <div class="field">
                            <label class="label">{{ translations.dashboards.column_roles_id }}</label>
                            <div class="control">
                                <lesli-select
                                    v-model="storeDashboard.dashboard.roles_id"
                                    :options="storeDashboard.options.roles"
                                ></lesli-select>
                            </div>
                        </div>
                    </div>

                    <div class="column is-4">
                        <div class="field">
                            <label class="label">{{ translations.dashboards.column_default }}</label>
                            <div class="control">
                                <input type="checkbox" v-model="storeDashboard.dashboard.default">
                                <span v-if="storeDashboard.dashboard.default"> {{translations.core.view_text_yes}} </span>
                                <span v-else> {{translations.core.view_text_no}} </span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="field is-grouped">
                    <div class="control">
                        <lesli-button icon="save">
                            {{ translations.dashboards.view_btn_save_dashboard }}
                        </lesli-button> 
                    </div>
                </div>

            </form>
            
        </fieldset>
      
    </div>

</template>
