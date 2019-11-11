<script>
export default {
   data(){
      return{
         translations: {
            links: I18n.t('users.links'),
            password: I18n.t('users.password'),
            sessions: I18n.t('devise.sessions'),
            shared: I18n.t('users.shared')
         },
         password: {
            password: '',
            password_confirmation: '',
            reset_password_token: ''
         },
         notification: {
            exists: false,
            message: '',
            type: 'is-danger'
         }
      }
   },
   mounted(){
      this.setResetPasswordToken();
   },
   methods:{
      setResetPasswordToken(){
         this.password.reset_password_token = this.$route.query.reset_password_token;
      },
      resetPassword(event){
         event.preventDefault();
         let data = {user: this.password}
         this.http.put(this.url.to(null,null,'/password'),data).then((response)=>{
            if(response.successful){
               this.showNotification(this.translations.password.notifications.update.success,'is-success');
               setTimeout(()=>{
                  this.goTo('/login');
               },2500);
            }else{
               this.showNotification(response.error.message, 'is-danger');
            }
         }).catch((err)=>{
            console.log(err);
         });
      },
      dismissNotification(){
         this.notification.exists = false;
      },
      showNotification(message,type='is-info'){
         this.notification.message = message;
         this.notification.type = type;
         this.notification.exists = true;
      },
      verifyPasswords(){
         let password = this.password.password;
         let password_confirmation = this.password.password_confirmation;
         if(password && password_confirmation){
            if(password !== password_confirmation){
               this.showNotification(this.translations.shared.errors.unmatched_passwords,'is-danger');
               return;
            }
         }
         this.dismissNotification();
      },
      dismissError(){
         this.error.exists = false;
      },
      goTo(url){
         this.$router.push(`${url}`);
      }
   },
   computed: {
      notificationClass(){
         return `notification ${this.notification.type}`;
      }
   }
}
</script>
<template>
   <section>
      <a class="logo" :href="url.to()">
         <img src="/assets/brand/leslicloud-logo.png" alt="LesliCloud Logo">
      </a>
      <form ref="form" id="registration_user" @submit="resetPassword">
         <transition name="fade">
            <div v-if="notification.exists" :class="notificationClass">
               <button type="button" class="delete" @click="dismissNotification"></button>
               {{notification.message}}
            </div>
         </transition>
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
                  v-model="password.password"
                  :placeholder="translations.shared.fields.new_password"
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
                  v-model="password.password_confirmation"
                  :placeholder="translations.shared.fields.password_confirmation"
                  @change="verifyPasswords"
               />
               <span class="icon is-small is-left">
                  <i class="fas fa-lock"></i>
               </span>
            </p>
         </div>
         <input class="button is-primary" type="submit" :value="translations.password.actions.change_password" />
      </form>
      <div class="links">
         <a @click="goTo('/login')">
            {{translations.links.login}}
         </a>
         <a @click="goTo('/register')">
            {{translations.links.sign_up}}
         </a>
         <a @click="goTo('/confirmation/new')">
            {{translations.links.resend_confirmation_email}}
         </a>
      </div>
   </section>
</template>

