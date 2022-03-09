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
}
</script>
<template>
    <div v-if="translations.checks">
        <h5 class="title is-5">{{translations.checks.view_title_main}}</h5>
        <b-tabs expanded v-model="data.checks.active_tab">
            <b-tab-item :label="translations.checks.view_tab_title_list">
                <component-list
                    :engine-namespace="engineNamespace"
                    :workflow-id="workflowId"
                    :check-selected.sync="check_selected"
                    :statuses-translations-path="statusesTranslationsPath"
                >
                </component-list>
            </b-tab-item>
            <b-tab-item :label="translations.checks.view_tab_title_new">
                <component-new
                    :engine-namespace="engineNamespace"
                    :workflow-id="workflowId"
                    :statuses-translations-path="statusesTranslationsPath"
                >
                </component-new>
            </b-tab-item>
            <b-tab-item :label="translations.checks.view_tab_title_edit" :disabled="! data.checks.selected_record_id">
                <component-edit
                    :engine-namespace="engineNamespace"
                    :workflow-id="workflowId"
                    :statuses-translations-path="statusesTranslationsPath"
                >
                </component-edit>
            </b-tab-item>
        </b-tabs>
    </div>
</template>
