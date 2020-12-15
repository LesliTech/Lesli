<script>
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
            this.bus.subscribe('show:/module/workflows/action', () => {
                this.show = ! this.show
            })

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
        this.bus.$off('show:/module/workflows/action')
        this.bus.$off('show:/module/workflow/action/edit')
        this.bus.$off('destroy:/module/workflow/action')
    }
}
</script>
<template>
    <div :class="[{ 'is-active': show }, 'quickview', 'is-size-large']" v-if="translations.actions">
        <header class="quickview-header">
            <h4 class="title">{{translations.actions.view_title_main}}</h4>
            <span class="delete" @click="show = false"></span>
        </header>
        <div class="quickview-body">
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
    </div>
</template>
