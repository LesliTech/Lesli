<script>
import componentForm from "../components/form.vue"


export default {

    props: {
        cloudEngine: {
            type: String,
            required: true
        },

        engineNamespace: {
            type: String,
            required: true
        },
        renderComponents: {
            required: true
        }
    },
    
    components: {
        'component-form': componentForm
    },

    data(){
        return {
            translations: {
                main: I18n.t(`${this.cloudEngine.toLowerCase()}.dashboards`)
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
                            {{translations.main.view_title_main}}
                        </h4>
                    </div>
                </div>
            </div>
        </nav>
        <component-form
            :render-components="renderComponents"
            :cloud-engine="cloudEngine"
            :engineNamespace="engineNamespace"
        >
        </component-form>
    </section>
</template>
