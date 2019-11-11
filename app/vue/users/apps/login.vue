<script>
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
      },
      goTo(url){
         this.$router.push(`${url}`);
      }
   }
}
</script>
<template>
   <section>
      <a class="logo" :href="url.to()">
         <img src="/assets/brand/leslicloud-logo.png" alt="LesliCloud Logo">
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

