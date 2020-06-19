<script>
export default {
    data() {
        return {
            translations: {
                core: {
                    shared: I18n.t('core.shared')
                }
            },
        }
    },
}
</script>
<template>
<div class="buttons">
<button class="button is-primary">
<span class="icon">
<i class="far fa-save"></i>
</span>
<span>{{ translations.core.shared.btn_save }}</span>
</button>
</div>
</template>
