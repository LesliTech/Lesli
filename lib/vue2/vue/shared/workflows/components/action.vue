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
import componentList from './actions/list.vue'
import componentEdit from './actions/edit.vue'
import componentNew from './actions/new.vue'

export default {
    props: {
        workflowId: {
            required: true
        },

        engineNamespace: {
            required: true
        },
        translationsPath: {
            required: true,
            type: String
        },
        statusesTranslationsPath: {
            required: true,
            type: String
        }
    },

    components: {
        'component-list': componentList,
        'component-edit': componentEdit,
        'component-new': componentNew
    },

    data(){
        return {
            show: false,
            translations: {
                core: I18n.t('core.shared'),
                actions: I18n.t('core.workflow/actions')
            },
            active_tab: 0,
            action_selected: false
        }
    },

    mounted(){
        this.setSubscriptions()
        this.setTranslations()
    },

    methods: {
        setSubscriptions(){
            this.bus.subscribe('show:/module/workflow/action/edit', () => {
                this.active_tab = 2
            })

            this.bus.subscribe('destroy:/module/workflow/action', ()=>{
                this.active_tab = 0
            })
        },

        setTranslations(){
            this.$set(this.translations, 'main', I18n.t(this.translationsPath))
        }
    },

    beforeDestroy(){
        this.bus.$off('show:/module/workflow/action/edit')
        this.bus.$off('destroy:/module/workflow/action')
    }
}
</script>
<template>
    <div v-if="translations.actions">
        <h5 class="title is-5">{{translations.actions.view_title_main}}</h5>
        <b-tabs expanded v-model="active_tab">
            <b-tab-item :label="translations.actions.view_tab_title_list">
                <component-list
                    :engine-namespace="engineNamespace"
                    :workflow-id="workflowId"
                    :translations-path="translationsPath"
                    :statuses-translations-path="statusesTranslationsPath"
                    :action-selected.sync="action_selected"
                >
                </component-list>
            </b-tab-item>
            <b-tab-item :label="translations.actions.view_tab_title_new">
                <component-new
                    :engine-namespace="engineNamespace"
                    :workflow-id="workflowId"
                    :translations-path="translationsPath"
                    :statuses-translations-path="statusesTranslationsPath"
                >
                </component-new>
            </b-tab-item>
            <b-tab-item :label="translations.actions.view_tab_title_edit" :disabled="! action_selected">
                <component-edit
                    :engine-namespace="engineNamespace"
                    :workflow-id="workflowId"
                    :translations-path="translationsPath"
                    :statuses-translations-path="statusesTranslationsPath"
                >
                </component-edit>
            </b-tab-item>
        </b-tabs>
    </div>
</template>
