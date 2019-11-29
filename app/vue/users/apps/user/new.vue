<script>
export default {
    data(){
    return{
        user: {
            email: '',
            password: '',
            password_confirmation: '',
            detail_attributes: {
                first_name: '',
                last_name: '',
                telephone: '',
                address: ''
            }
        }
    }
},
    methods: {
        postEmployee(e) {
            if (e) { e.preventDefault() }
            this.http.post('/admin/users', {
                user: this.user
            }).then(result => {
                if (result.successful) {
                this.$router.push('/admin/users')
                }
            }).catch(error => {
                console.log(error)
            })
        }
    },

}
</script>
<template>
    <section class="section">
        <div class="card">
            <div class="card-header">
                <h4 class="card-header-title">New user</h4>
            </div>
            <div class="card-content">
                <form @submit="postEmployee">
                    <div class="columns">
                        <div class="column is-4">
                            <label class="label">Email</label>
                            <input 
                                class="input is-primary" type="email" placeholder="Email" required
                                v-model="user.email">
                        </div>        
                        <div class="column is-4">
                            <label class="label">Password</label>
                            <input 
                                class="input is-primary" type="password" placeholder="Password" required
                                v-model="user.password">
                        </div>    
                        <div class="column is-4">
                            <label class="label">Password confirmation</label>
                            <input 
                                class="input is-primary" type="password" placeholder="Password confirmation" required
                                v-model="user.password_confirmation">
                        </div>       
                    </div>
                    <div class="columns">
                        <div class="column is-4">
                            <label class="label">First name</label>
                            <input 
                                class="input is-primary" type="text" placeholder="First name" required
                                v-model="user.detail_attributes.first_name">
                        </div>        
                        <div class="column is-4">
                            <label class="label">Last name</label>
                            <input 
                                class="input is-primary" type="text" placeholder="password" required
                                v-model="user.detail_attributes.last_name">
                        </div>    
                        <div class="column is-4">
                            <label class="label">Telephone</label>
                            <input 
                                class="input is-primary" type="text" placeholder="password" required
                                v-model="user.detail_attributes.telephone">
                        </div>       
                    </div>
                    <div class="columns">
                        <div class="column is-4">
                            <label class="label">Address</label>
                            <input 
                                class="input is-primary" type="text" placeholder="First name" required
                                v-model="user.detail_attributes.address">
                        </div>        
                        <div class="column is-4" style="padding: 2.75rem;">
                            <div class="field">
                                <div class="control">
                                    <input class="button is-primary" type="submit" value="Save" required>
                                </div>
                            </div>
                        </div>          
                    </div>
                </form>
            </div>
        </div>
    </section>
</template>
