<script>
export default {
       data(){
      return{
        user_id: null,
        user: {
        }
      }
   },
    methods: {
        getEmployee() {
            this.http.get(`/admin/users/${this.user_id}.json`).then(result => {
                if (result.successful) {
                    this.user = result.data
                }
            }).catch(error => {
                console.log(error)
            })
        },
        postEmployee(e) {
            if (e) { e.preventDefault() }
            this.http.post('/admin/users', {
                user: this.user
            }).then(result => {
                if (result.successful) {
                this.$router.push(`${result.data.id}/edit`)
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
                <input class="button is-primary" type="submit" value="Edit" required>
                <input class="button is-danger" type="submit" value="Destroy" required>
                
            </div>
            <div class="card-content">
                <form @submit="postEmployee">
                       <div class="columns">
                                <div class="column is-4">
                                    <label class="label">First name</label>
                                    <div class="control">
                                        <input 
                                            class="input is-primary" type="text" placeholder="Luis"
                                            >
                                    </div>        
                                </div>
                                <div class="column is-4">
                                    <label class="label">Last name</label>
                                    <div class="control">
                                        <input 
                                            class="input is-primary" type="text" placeholder="Davila"
                                           >
                                    </div>        
                                </div>
                                <div class="column is-4">
                                    <label class="label"> Street </label>
                                    <div class="control">
                                        <input 
                                            class="input is-primary" type="text" placeholder="3rt street"
                                           >
                                    </div>        
                                </div>
                            </div>
                </form>
            </div>
        </div>
    </section>
</template>
