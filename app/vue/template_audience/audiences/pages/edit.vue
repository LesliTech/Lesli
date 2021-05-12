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
import componentFormContact from "../components/form-contact.vue"
import componentListContacts from "../components/list-contacts.vue"
import componentFormImportContacts from "../components/form-import-contacts.vue"


// ·
export default {
    props: {
        lesli_instance_code: {
            required: true
        }
    },
    components: {
        "component-form": componentForm,
        "component-form-contact": componentFormContact,
        "component-list-contacts": componentListContacts,
        "component-form-import-contacts": componentFormImportContacts
    },
    data() {
        return {
            audience_id: null,
            audience: {},
            translations: {
                main: I18n.t('mailer.audiences'),
                core: I18n.t('core.shared')
            },
            active: {
                main_tab: 0
            },
            source_translation_path: null
        }
    },
    mounted() {

        // translate the sources depending on builder
        this.source_translation_path = I18n.t(`${this.lesli_instance_code}.shared`)

        this.audience_id = this.$route.params.id
        this.getAudience()
    },
    methods: {
        getAudience() {
            this.http.get(`/mailer/audiences/${this.audience_id}.json`).then(result => {
                if (!result.successful) {
                    return
                }
                this.audience = result.data
            }).catch(error => {
                console.log(error)
            })
        }
    },
    watch: {
        'active.main_tab': {
            handler(value){
                if (value == 1 && this.data.selected_audience_contact.id) {
                    this.data.selected_audience_contact = {} // remove selected contact from form
                }
            }
        }
    }
}
</script>
<template>
    <section class="application-component">
        <component-header :title="audience.name">
            <div class="navbar-item">
                <div class="buttons">
                    <router-link class="button" to="/">
                        <b-icon icon="list" size="is-small" />
                        <span>{{ translations.core.view_btn_list }}</span>
                    </router-link>
                </div>
            </div>
        </component-header>

        <b-tabs v-model="active.main_tab">
            <b-tab-item :label="translations.main.view_text_contacts">
                <component-list-contacts :source_translation_path="source_translation_path" :active="active" :audience-id="audience_id"></component-list-contacts>
            </b-tab-item>

            <b-tab-item :label="translations.main.view_text_add_contacts">
                <component-form-contact v-if="audience" :active="active" :audience-id="audience_id"></component-form-contact>
            </b-tab-item >

            <b-tab-item :label="translations.main.view_text_import_contact">
                <component-form-import-contacts :source_translation_path="source_translation_path" :active="active" :audience-id="audience_id"></component-form-import-contacts>
            </b-tab-item>
        </b-tabs>
    </section>
</template>
