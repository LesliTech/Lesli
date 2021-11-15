<script>
import componentList from './checks/list.vue'
import componentEdit from './checks/edit.vue'
import componentNew from './checks/new.vue'

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
                checks: I18n.t('core.workflow/checks')
            },
            active_tab: 0,
            check_selected: false
        }
    },

    mounted(){
        this.setSubscriptions()
        this.setTranslations()
    },

    methods: {
        setSubscriptions(){
            this.bus.subscribe('show:/module/workflow/check/edit', () => {
                this.active_tab = 2
            })

            this.bus.subscribe('destroy:/module/workflow/check', ()=>{
                this.active_tab = 0
            })
        },

        setTranslations(){
            this.$set(this.translations, 'main', I18n.t(this.translationsPath))
        }
    },

    beforeDestroy(){
        this.bus.$off('show:/module/workflow/check/edit')
        this.bus.$off('destroy:/module/workflow/check')
    }
}
</script>
<template>
    <div v-if="translations.checks">
        <h5 class="title is-5">{{translations.checks.view_title_main}}</h5>
        <b-tabs expanded v-model="active_tab">
            <b-tab-item :label="translations.checks.view_tab_title_list">
                <component-list
                    :engine-namespace="engineNamespace"
                    :workflow-id="workflowId"
                    :check-selected.sync="check_selected"
                    :translations-path="translationsPath"
                    :statuses-translations-path="statusesTranslationsPath"
                >
                </component-list>
            </b-tab-item>
            <b-tab-item :label="translations.checks.view_tab_title_new">
                <component-new
                    :engine-namespace="engineNamespace"
                    :workflow-id="workflowId"
                    :translations-path="translationsPath"
                    :statuses-translations-path="statusesTranslationsPath"
                >
                </component-new>
            </b-tab-item>
            <b-tab-item :label="translations.checks.view_tab_title_edit" :disabled="! check_selected">
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
