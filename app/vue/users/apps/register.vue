<script>

import notification from '../components/notification.vue'
import progressBar from '../components/progress_bar.vue'

export default {
   data(){
      return{
         translations: {
            links: I18n.t('users.links'),
            registration: I18n.t('users.registration'),
            sessions: I18n.t('devise.sessions'),
            shared: I18n.t('users.shared')
         },
         sign_up: {
            email: '',
            password: '',
            password_confirmation: ''
         },
         progress_bar_active: false,
         notification: {
            show: false,
            message: '',
            type: 'is-danger'
         }
      }
   },
   methods:{
      register(event){
         event.preventDefault();
         let data = {user: this.sign_up};
         this.progress_bar_active = true;
         this.http.post(this.url.to(null,null,null),data).then((response)=>{
            this.progress_bar_active = false;
            if(response.successful){
               this.showNotification(this.translations.registration.notifications.success,'is-success');
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
      showNotification(message,type='is-danger'){
         this.notification.message = message;
         this.notification.type = type;
         this.notification.show = true;
      },
      verifyPasswords(){
         let password = this.sign_up.password;
         let password_confirmation = this.sign_up.password_confirmation;
         if(password && password_confirmation){
            if(password !== password_confirmation){
               this.showNotification(this.translations.shared.errors.unmatched_passwords);
               return;
            }
         }
         this.notification.show = false;
      },
      goTo(url){
         this.$router.push(`${url}`);
      }
   },
   components:{
      'form-notification':notification,
      'progress-bar': progressBar
   }
}
</script>
<template>
   <section>
      <a class="logo" :href="url.to()">
         <img src="/assets/brand/leslicloud-logo.png" alt="LesliCloud Logo">
      </a>
      <form ref="form" id="registration_user" @submit="register">
         <progress-bar :active="progress_bar_active"/>
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
                  v-model="sign_up.email"
                  required="true"
                  :placeholder="translations.shared.fields.email"
               />
               <span class="icon is-small is-left">
                  <i class="fas fa-envelope"></i>
               </span>
            </p>
         </div>
         <div class="field">
            <p class="control has-icons-left">
               <label class="sr-only" for="user_password">
                  {{translations.shared.fields.password}}
               </label>
               <input 
                  type="password"
                  class="input"
                  required="true"
                  minlength="6"
                  v-model="sign_up.password"
                  :placeholder="`${translations.shared.fields.password} ${translations.registration.fields.password_length}`"
                  @change="verifyPasswords"
               />
               <span class="icon is-small is-left">
                  <i class="fas fa-lock"></i>
               </span>
            </p>
         </div>
         <div class="field">
            <p class="control has-icons-left">
               <label class="sr-only" for="user_password">
                  {{translations.shared.fields.password}}
               </label>
               <input 
                  type="password"
                  class="input"
                  required="true"
                  v-model="sign_up.password_confirmation"
                  :placeholder="translations.shared.fields.password_confirmation"
                  @change="verifyPasswords"
               />
               <span class="icon is-small is-left">
                  <i class="fas fa-lock"></i>
               </span>
            </p>
         </div>
         <input class="button is-primary" type="submit" :value="translations.registration.actions.sign_up" />
      </form>
      <div class="links">
         <a @click="goTo('/login')">
            {{translations.links.login}}
         </a>
         <a @click="goTo('/confirmation/new')">
            {{translations.links.resend_confirmation_email}}
         </a>
      </div>
   </section>
</template>

