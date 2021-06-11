<script>
/*
Copyright (c) 2021, all rights reserved.

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
import componentForm from '../components/form.vue'
import componentPrivileges from '../components/privileges.vue'

// ·
export default {
    props: {},

    components: {
        'component-form': componentForm,
        'component-privileges': componentPrivileges
    },
    data() {
        return {
            privilege_group_id: null,
            privilege_group: {},
            translations: {
                core: I18n.t('core.shared'),
                main: I18n.t('core.account/privilege_groups')
            },
            active_tab: 1
        }
    },
    mounted() {
        this.privilege_group_id = this.$route.params.id
        this.getPrivilegeGroup()
    },
    methods: {
        getPrivilegeGroup() {
            let url = this.url.admin('account/privilege_groups/:id', {id: this.privilege_group_id})
            this.http.get(url).then(result => {

                if (!result.successful) {
                    return
                }

                this.privilege_group = result.data
            }).catch(error => {
                console.log(error)
            })
        }
    }
}
</script>
<template>
    <section class="application-component">
        <component-header :title="privilege_group.name">
            <div class="navbar-item">
                <div class="buttons">
                    <router-link class="button" to="/">
                        <b-icon icon="list" size="is-small" />
                        <span>{{ translations.core.view_btn_list }}</span>
                    </router-link>
                </div>
            </div>
        </component-header>

        <b-tabs v-model="active_tab">
            <b-tab-item :label="translations.core.view_tab_title_form">
                <component-form v-if="privilege_group.id" :privilege_group="privilege_group"></component-form>
            </b-tab-item>
            <b-tab-item :label="translations.main.view_tab_title_actions">
                <component-privileges v-if="privilege_group.id" :privilege_group="privilege_group"></component-privileges>
            </b-tab-item>
        </b-tabs>
    </section>
</template>