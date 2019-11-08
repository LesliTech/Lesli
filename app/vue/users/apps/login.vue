<script>
export default {
   data(){
      return{
         translations: {
            login: I18n.t('authentication.login'),
            links: I18n.t('authentication.links'),
            sessions: I18n.t('devise.sessions')
         },
         sign_in: {
            email: '',
            password: ''
         },
         error: {
            exists: false,
            message: ''
         }
      }
   },

   mounted(){
      this.preventFormSubmission();
   },
   
   methods:{
      preventFormSubmission(){
         this.$refs.form.addEventListener('submit',(event)=>{
            event.preventDefault();
         });
      },

      login(){
         let data = {sign_in: this.sign_in}
         this.http.post(this.url.to(null,null,'login'),data).then((response)=>{
            if(response.successful){
               this.url.go('/lesli');
            }else{
               this.error.exists = true;
               this.error.message = response.error.message;
            }
         }).catch((err)=>{
            console.log(err);
         });
      },

      dismissError(){
         this.error.exists = false;
      }
   }
}
</script>
<template>
   <section>
      <a class="logo" :href="url.to()">
         <img src="assets/brand/leslicloud-logo.png" alt="LesliCloud Logo">
      </a>
      <form ref="form" id="new_user" @submit="login">
         <transition name="fade">
            <div v-if="error.exists" class="notification is-danger">
               <button type="button" class="delete" @click="dismissError"></button>
               {{error.message}}
            </div>
         </transition>
         <div class="field">
            <p class="control has-icons-left">
               <label class="sr-only" type="email" for="user_email">
                  {{translations.login.labels.email}}
               </label>
               <input 
                  class="input" 
                  v-model="sign_in.email"
                  required="true"
                  :placeholder="translations.login.labels.email"
               />
               <span class="icon is-small is-left">
                  <i class="fas fa-envelope"></i>
               </span>
            </p>
         </div>
         <div class="field">
            <p class="control has-icons-left">
               <label class="sr-only" for="user_password">
                  {{translations.login.labels.password}}
               </label>
               <input 
                  type="password"
                  class="input"
                  required="true"
                  v-model="sign_in.password"
                  :placeholder="translations.login.labels.password"
               />
               <span class="icon is-small is-left">
                  <i class="fas fa-lock"></i>
               </span>
            </p>
         </div>
         <input class="button is-primary" type="submit" :value="translations.login.actions.log_in" />
      </form>
      <div class="links">
         <a :href="url.to(null, null, '/register')">
            {{translations.links.sign_up}}
         </a>
         <a :href="url.to(null, null, '/password/new')">
            {{translations.links.reset_password}}
         </a>
         <a :href="url.to(null, null, '/confirmation/new')">
            {{translations.links.resend_confirmation_email}}
         </a>
      </div>
   </section>
</template>

