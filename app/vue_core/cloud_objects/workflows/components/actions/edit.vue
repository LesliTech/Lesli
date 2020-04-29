<script>
import componentForm from './form.vue'

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
            :cloud-engine="cloudEngine"
            :translations-path="translationsPath"
            :statuses-translations-path="statusesTranslationsPath"
            view-type="edit"
        >
        </component-form>
    </div>
</template>
