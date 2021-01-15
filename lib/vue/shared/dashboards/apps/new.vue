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
        <component-header 
            :title="translations.dashboards.view_title_main"
        >
            <div class="navbar-item">
                <div class="buttons">
                    <router-link class="button" to="/">
                        <b-icon icon="list" size="is-small" />
                        <span>{{ translations.core.view_btn_list }}</span>
                    </router-link>
                </div>
            </div>
        </component-header>
        <component-form
            :cloud-engine="cloudEngine"
            :engineNamespace="engineNamespace"
        >
        </component-form>
    </section>
</template>
