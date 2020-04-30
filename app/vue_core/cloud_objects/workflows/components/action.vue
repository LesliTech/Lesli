<script>
import componentList from './actions/list.vue'
import componentEdit from './actions/edit.vue'
import componentNew from './actions/new.vue'

export default {
    props: {
        workflowId: {
            required: true
        },

        cloudEngine: {
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
                core: I18n.t('core.shared')
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
        setMainRoute(){
            this.main_route = `/${this.cloudEngine}/workflows/${this.workflowId}/actions`
        },

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
    <div :class="[{ 'is-active': show }, 'quickview', 'is-size-large']" v-if="translations.main">
        <header class="quickview-header">
            <h4 class="title">{{translations.main.title}}</h4>
            <span class="delete" @click="show = false"></span>
        </header>
        <div class="quickview-body">
            <b-tabs expanded v-model="active_tab">
                <b-tab-item :label="translations.main.tab_list_title">
                    <component-list
                        :cloud-engine="cloudEngine"
                        :workflow-id="workflowId"
                        :translations-path="translationsPath"
                        :statuses-translations-path="statusesTranslationsPath"
                        :action-selected.sync="action_selected"
                    >
                    </component-list>
                </b-tab-item>
                <b-tab-item :label="translations.main.tab_new_title">
                    <component-new
                        :cloud-engine="cloudEngine"
                        :workflow-id="workflowId"
                        :translations-path="translationsPath"
                        :statuses-translations-path="statusesTranslationsPath"
                    >
                    </component-new>
                </b-tab-item>
                <b-tab-item :label="translations.main.tab_edit_title" :disabled="! action_selected">
                    <component-edit
                        :cloud-engine="cloudEngine"
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
