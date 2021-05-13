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
import componentListContacts from "../components/list-contacts.vue"
import componentFormImportContacts from "../components/form-import-contacts.vue"


// ·
export default {
    props: {},

    components: {
        "component-form": componentForm,
        "component-list-contacts": componentListContacts,
        "component-form-import-contacts": componentFormImportContacts
    },
    data() {
        return {
            audience_id: null,
            audience: {},
            translations: {
                main: I18n.t('core.template/audiences'),
                core: I18n.t('core.shared')
            },
            active: {
                main_tab: 0
            },
            source_translation_path: null
        }
    },
    mounted() {
        this.audience_id = this.$route.params.id
        this.getTemplateAudience()
    },
    methods: {
        getTemplateAudience() {
            let url = this.url.admin('template/audiences/:id', {id: this.audience_id})
            this.http.get(url).then(result => {

                if (!result.successful) {
                    return
                }

                this.audience = result.data
            }).catch(error => {
                console.log(error)
            })
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

        <b-tabs vertical>
            <b-tab-item :label="translations.core.view_tab_title_form">
                <component-form v-if="audience.id" :base_path="null" :audience="audience"></component-form>
            </b-tab-item>

            <b-tab-item v-if="audience.id" :label="translations.main.view_tab_title_references">
                <div class="box">
                    <component-form-import-contacts :audience="audience"></component-form-import-contacts>
                </div>

                <!-- <b-tabs expanded>
                    <b-tab-item :label="translations.core.view_tab_title_list">
                        <component-list-contacts :template-audience-id="audience_id"></component-list-contacts>
                    </b-tab-item>
                    <b-tab-item :label="translations.main.view_tab_title_import_references">

                    </b-tab-item>
                </b-tabs> -->
            </b-tab-item>
        </b-tabs>
    </section>
</template>