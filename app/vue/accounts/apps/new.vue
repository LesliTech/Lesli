<script>
import accountForm from '../components/form.vue'

export default {
    mounted() {

    },
   components:{
      'account-form': accountForm
   }
}
</script>
<template>
    <section class="application-component">
        <a class="logo" href="/">
            <img alt="LesliCloud logo" src="/assets/lesli_cloud/brand/lesli-logo.svg" width="150px" />
        </a>
        <account-form></account-form>
    </section>
</template>
