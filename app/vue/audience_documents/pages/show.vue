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
import componentDocumentGenerator from "../components/form-document-generator.vue"


// ·
export default {
    props: {},

    components: {
        "component-form": componentForm,
        "component-document-generator": componentDocumentGenerator
    },
    data() {
        return {
            audience_document_id: null,
            audience_document: {},
            translations: {
                main: I18n.t('core.template/audience_documents'),
                core: I18n.t('core.shared')
            },
            active: {
                main_tab: 0
            },
            source_translation_path: null
        }
    },
    mounted() {
        this.audience_document_id = this.$route.params.id
        this.getTemplateAudience()
    },
    methods: {
        getTemplateAudience() {
            let url = this.url.admin('template/audience_documents/:id', {id: this.audience_document_id})
            this.http.get(url).then(result => {

                if (!result.successful) {
                    return
                }

                this.audience_document = result.data
            }).catch(error => {
                console.log(error)
            })
        }
    }
}
</script>
<template>
    <section class="application-component">
        <component-header :title="audience_document.name">
            <div class="navbar-item">
                <div class="buttons">
                    <router-link class="button" to="/">
                        <b-icon icon="list" size="is-small" />
                        <span>{{ translations.core.view_btn_list }}</span>
                    </router-link>
                </div>
            </div>
        </component-header>

        <b-tabs vertical>
            <b-tab-item :label="translations.core.view_tab_title_form">
                <component-form v-if="audience_document.id" :base_path="null" :audience_document="audience_document"></component-form>
            </b-tab-item>

            <b-tab-item v-if="audience_document.id" :label="translations.main.view_tab_title_references">
                <div class="box">
                    <component-form-import-contacts :audience_document="audience_document"></component-form-import-contacts>
                </div>
            </b-tab-item>
        </b-tabs>
    </section>
</template>