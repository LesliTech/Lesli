<script>
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


// · List of Imported Components
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
import componentForm from '../components/form.vue'


export default {
    props: {
        cloudEngine: {
            type: String,
            required: true
        },

        engineNamespace: {
            type: String,
            required: true
        },

        appMountPath: {
            type: String,
            default: ''
        }
    },
    
    components: {
        'component-form': componentForm
    },

    data(){
        return {
            translations: {
                main: I18n.t(`${this.cloudEngine.toLowerCase()}.dashboards`),
                dashboards: I18n.t('core.dashboards'),
                core: I18n.t('core.shared')
            }
        }
    }
}
</script>
<template>
    <section class="application-component app-dashboards">
        <component-header 
            :title="translations.dashboards.view_title_main"
        >
            <div class="navbar-item">
                <div class="buttons">
                    <router-link class="button" :to="`${appMountPath}/`">
                        <b-icon icon="list" size="is-small" />
                        <span>{{ translations.core.view_btn_list }}</span>
                    </router-link>
                </div>
            </div>
        </component-header>
        <component-form
            :cloud-engine="cloudEngine"
            :engineNamespace="engineNamespace"
            :app-mount-path="appMountPath"
        >
        </component-form>
    </section>
</template>
