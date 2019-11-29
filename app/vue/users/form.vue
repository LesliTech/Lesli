<script>
export default {
       data(){
      return{
        user: {
            email: '',
            password: '',
        }
      }
   },
    methods: {
        create() {
            this.http.post('/admin/users', {
                user: {
                    email: 'prueba1@mail.com',
                    password: '123456sdd',
                    detail_attributes: {
                        name: 'ldonis'
                    }
                }
            }).then(result => console.log(result))
            .catch(error => console.log(error))
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
                <h4 class="card-header-title">Nuevo Usuario</h4>
            </div>
            <div class="card-content">
                <form @submit="postEmployee">
                    <div class="field">
                        <div class="control">
                            <input 
                                class="input is-primary" type="text" placeholder="Correo" required
                                v-model="user.email">
                        </div>
                    </div>
                    <div class="field" style="margin-top: 10px">
                        <div class="control">
                            <input 
                                class="input is-primary" type="text" placeholder="password" required
                                v-model="user.password">
                        </div>
                    </div>
                    <div class="field">
                        <div class="control">
                            <input class="button is-primary" type="submit" value="Crear" required>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </section>
</template>
