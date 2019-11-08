<script>
export default {
   data(){
      return{
         sign_in:{
            email: '',
            password: ''
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
               console.log(response.error);
            }
         }).catch((err)=>{
            console.log(err);
         });
      }
   }
}
</script>
<template>
   <section>
      <a class="logo" :href="url.to()">
         <img src="assets/brand/leslicloud-logo.png" alt="LesliCloud Logo">
      </a>
      <form ref="form" id="new_user" class="new_user" @submit="login">
         <div class="field">
            <p class="control has-icons-left">
               <label class="sr-only" type="email" for="user_email">Email</label>
               <input class="input" v-model="sign_in.email" placeholder="Username"/>
               <span class="icon is-small is-left">
                  <i class="fas fa-envelope"></i>
               </span>
            </p>
         </div>
         <div class="field">
            <p class="control has-icons-left">
               <label class="sr-only" for="user_password">Password</label>
               <input type="password" class="input" v-model="sign_in.password" placeholder="Password"/>
               <span class="icon is-small is-left">
                  <i class="fas fa-lock"></i>
               </span>
            </p>
         </div>
         <input class="button is-primary" type="submit" name="commit" value="Log in" />
      </form>
      <div class="links">
         <a href="/register">Sign up</a>
         <a href="/password/new">Forgot your password?</a>
         <a href="/confirmation/new">Didn't receive confirmation instructions?</a>
      </div>
   </section>
</template>

