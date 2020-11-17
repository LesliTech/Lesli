<script>
import componentForm from '../components/form.vue'


export default {
    props: {
        cloudEngine: {
            type: String,
            required: true
        },

        engineNamespace: {
            type: String,
            required: true
        }
    },
    
    components: {
        'component-form': componentForm
    },

    data(){
        return {
            translations: {
                main: I18n.t(`${this.cloudEngine.toLowerCase()}.dashboards`),
                dashboards: I18n.t('core.dashboards'),
                core: I18n.t('core.shared')
            }
        }
    }
}
</script>
<template>
    <section class="application-component">
        <nav class="navbar component-header">
            <div class="navbar-menu">
                <div class="navbar-start">
                    <div class="navbar-item">
                        <h4 class="is-size-3">
                            {{translations.dashboards.view_title_main}}
                        </h4>
                    </div>
                </div>
            </div>
        </nav>
        <component-form
            :cloud-engine="cloudEngine"
            :engineNamespace="engineNamespace"
        >
        </component-form>
    </section>
</template>
