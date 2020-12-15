<script>
/*
Copyright (c) 2020, all rights reserved.

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

// · 
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
import componentForm from '../components/form.vue'


export default {
    props: {
        engineNamespace: {
            type: String,
            required: true
        },

        translationsPath: {
            type: String,
            default: null
        }
    },

    components: {
        'component-form': componentForm
    },

    data(){
        return {
            translations: {
                workflows: I18n.t('core.workflows')
            }
        }
    }
}
</script>
<template>
    <section class="application-component">
        <nav class="navbar component-header">
            <div class="navbar-menu">
                <div class="navbar-start">
                    <div class="navbar-item">
                        <h4 class="is-size-3">
                            {{translations.workflows.view_title_main}}
                        </h4>
                    </div>
                </div>
            </div>
        </nav>
        <component-form :engine-namespace="engineNamespace" :translations-path="translationsPath">
        </component-form>
    </section>
</template>
