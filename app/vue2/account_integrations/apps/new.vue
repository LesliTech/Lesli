<script>
import integrationForm from '../components/form.vue'

export default {
    props: {},
    
    data(){
        return {
            endpoint: "/administration/account/integrations",
            translations: {
                core: {
                    integrations: I18n.t("core.account/integrations")
                }
            },
        }
    },
    mounted() {

    },
   components:{
      'account-form': integrationForm
   }
}
</script>
<template>
    <section class="application-component">
        <component-header :title="translations.core.integrations.view_title_new"></component-header>
        <div class="card">
            <div class="card-content">
                <account-form></account-form>
            </div>
        </div>
    </section>
</template>
