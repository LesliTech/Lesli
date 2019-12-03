<script>
/*
Lesli

Copyright (c) 2019, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

LesliCloud - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@author   LesliTech <hello@lesli.tech>
@license  Propietary - all rights reserved.
@version  0.1.0-alpha

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/


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
        postUser(e) {
            if (e) { e.preventDefault() }
            this.http.post('/admin/users', {
                user: this.user
            }).then(result => {
                if (result.successful) {
                this.$router.push('/')
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
                <form @submit="postUser">
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
                                class="input is-primary" type="text" placeholder="password" 
                                v-model="user.detail_attributes.last_name">
                        </div>    
                        <div class="column is-4">
                            <label class="label">Telephone</label>
                            <input 
                                class="input is-primary" type="text" placeholder="password" 
                                v-model="user.detail_attributes.telephone">
                        </div>       
                    </div>
                    <div class="columns">
                        <div class="column is-4">
                            <label class="label">Address</label>
                            <input 
                                class="input is-primary" type="text" placeholder="First name" 
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
