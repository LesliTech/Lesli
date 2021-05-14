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


// ·
import componentForm from "../components/form.vue"


// ·
export default {
    props: {
        base_path: {
            default: null
        }
    },

    components: {
        "component-form": componentForm
    },
    data() {
        return {
            translations: {
                main: I18n.t('mailer.audience_documents'),
                core: I18n.t('core.shared')
            },
            audience_document: {
                id: null
            }
        }
    }
}
</script>
<template>
    <section class="application-component">
        <component-header :title="translations.main.view_btn_new_audience_document">
            <div class="buttons">
                <router-link class="button" tag="button" to="/">
                    <span class="icon"><i class="fas fa-list"></i></span>
                    <span> {{ translations.core.view_btn_list }}</span>
                </router-links>
            </div>
        </component-header>

        <component-form :audience_document="audience_document" :base_path="base_path"></component-form>
    </section>
</template>
