<script>

import notification from '../components/notification.vue'

export default {
   data(){
      return {
         translations: {
            links: I18n.t('users.links'),
            confirmation: I18n.t('users.confirmation'),
            shared: I18n.t('users.shared')
         },
         confirmation: {
            email: ''
         },
         notification: {
            show: false,
            message: '',
            type: 'is-danger'
         }
      }
   },
   methods: {
      showNotification(message,type='is-danger'){
         this.notification.message = message;
         this.notification.type = type;
         this.notification.show = true;
      },
      confirmEmail(event){
         event.preventDefault();
         let data = {user: this.confirmation};
         this.http.post(this.url.to(null,null,'/confirmation'),data).then((response)=>{
            if(response.successful){
               this.showNotification(this.translations.confirmation.notifications.success,'is-success');
               setTimeout(()=>{
                  this.goTo('/login');
               },5000);
            }else{
               this.showNotification(response.error.message);
            }
         }).catch((err)=>{
            console.log(err);
         });
      },
      goTo(url){
         this.$router.push(`${url}`);
      }
   },
   components:{
      'form-notification':notification
   }
}
</script>

<template>
   <section>
      <a class="logo" :href="url.to()">
         <img src="/assets/brand/leslicloud-logo.png" alt="LesliCloud Logo">
      </a>
      <form ref="form" id="new_confirmation" @submit="confirmEmail">
         <form-notification
            :message="notification.message"
            :type="notification.type"
            :show.sync="notification.show"
         >
         </form-notification>
         <div class="field">
            <p class="control has-icons-left">
               <label class="sr-only">
                  {{translations.shared.fields.email}}
               </label>
               <input 
                  class="input" 
                  type="email"
                  v-model="confirmation.email"
                  required="true"
                  :placeholder="translations.shared.fields.email"
               />
               <span class="icon is-small is-left">
                  <i class="fas fa-envelope"></i>
               </span>
            </p>
         </div>
         <input class="button is-primary" type="submit" :value="translations.confirmation.actions.resend_email" />
      </form>
      <div class="links">
         <a @click="goTo('/login')">
            {{translations.links.login}}
         </a>
         <a @click="goTo('/register')">
            {{translations.links.sign_up}}
         </a>
         <a @click="goTo('/password/new')">
            {{translations.links.reset_password}}
         </a>
      </div>
   </section>
</template>