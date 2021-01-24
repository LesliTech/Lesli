<script>
import integrationForm from '../components/form.vue'

export default {
    mounted() {

    },
   components:{
      'account-form': integrationForm
   }
}
</script>
<template>
    <section class="application-component">
        <component-header title="New integration"></component-header>
        <div class="card">
            <div class="card-content">
                <account-form></account-form>
            </div>
        </div>
    </section>
</template>
