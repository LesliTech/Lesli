<script>
import componentForm from './form.vue'

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
        },
    },

    components: {
        'component-form': componentForm
    },
}
</script>
<template>
    <div class="tab-content">
        <component-form
            :workflow-id="workflowId"
            :engine-namespace="engineNamespace"
            :translations-path="translationsPath"
            :statuses-translations-path="statusesTranslationsPath"
            view-type="edit"
        >
        </component-form>
    </div>
</template>
