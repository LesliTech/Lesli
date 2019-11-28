<script>
export default {
    
    methods: {
        create() {
            this.http.post('/users', {
                user: {
                    email: 'prueba1@mail.com',
                    password: '123456sdd',
                    detail_attributes: {
                        name: 'ldonis'
                    }
                }
            }).then(result => console.log(result))
            .catch(error => console.log(error))
        }
    },

}
</script>
<template>
    <div>
    <button @click="create">send</button>        
    </div>
</template>
