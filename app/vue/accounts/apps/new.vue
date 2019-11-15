<script>
import accountForm from '../components/form.vue'

export default {
   components:{
      'account-form': accountForm
   }
}
</script>
<template>
   <section>
      <a class="logo" href="/">
         <img alt="LesliCloud logo" src="/assets/brand/leslicloud-logo.svg"/>
      </a>
      <account-form/>
   </section>
</template>