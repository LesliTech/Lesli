<script>

import notification from '../../components/forms/notification.vue'
import progressBar from '../../components/forms/progress_bar.vue'

export default {
   data(){
      return{
         translations: {
            links: I18n.t('users.links'),
            login: I18n.t('users.login'),
            sessions: I18n.t('devise.sessions'),
            shared: I18n.t('users.shared')
         },
         sign_in: {
            email: '',
            password: ''
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
      login(event){
         event.preventDefault();
         let data = {sign_in: this.sign_in};
         this.progress_bar_active = true;
         this.http.post(this.url.to(null,null,'login'),data).then((response)=>{
            this.progress_bar_active = false;
            if(response.successful){
               this.url.go('/');
            }else{
               this.showNotification(response.error.message);
            }
         }).catch((err)=>{
            console.log(err);
         });
      },
      showNotification(message, type='is-danger'){
         this.notification.message = message;
         this.notification.type = type;
         this.notification.show = true;
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
   <section id="sessions">
      <a class="logo" :href="url.to()">
         <img src="/assets/brand/leslicloud-logo.png" alt="LesliCloud Logo">
      </a>
      <form ref="form" id="new_user" @submit="login">
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
                  v-model="sign_in.email"
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
                  v-model="sign_in.password"
                  :placeholder="translations.shared.fields.password"
               />
               <span class="icon is-small is-left">
                  <i class="fas fa-lock"></i>
               </span>
            </p>
         </div>
         <input class="button is-primary" type="submit" :value="translations.login.actions.log_in" />
      </form>
      <div class="links">
         <a @click="goTo('/register')">
            {{translations.links.sign_up}}
         </a>
         <a @click="goTo('/password/new')">
            {{translations.links.reset_password}}
         </a>
         <a @click="goTo('/confirmation/new')">
            {{translations.links.resend_confirmation_email}}
         </a>
      </div>
   </section>
</template>

