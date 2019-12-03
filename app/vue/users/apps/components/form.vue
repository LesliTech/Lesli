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
        props: {
        isEditable: {
            type: Boolean,
            default: true
        }
    },
    data(){
        return{
            user_id: null,
            user: {
                detail_attributes: {
                }
            },
            modal:{
                active: false
            }
        }
    },
    mounted(){
        this.user_id =this.$route.params.id
        this.getUser()
    },
    methods: {
        getUser() {
            this.http.get(`/admin/users/${this.user_id}.json`).then(result => {
                if (result.successful) {
                    this.user = result.data
                }
            }).catch(error => {
                console.log(error)
            })
        },
         putDetail(e) {
            if (e) { e.preventDefault() }
            this.http.put(`/admin/users/${this.user_id}`, {
                user: this.user
            }).then(result => {
                if (result.successful) {
                    this.alert("User updated successfuly")
                    this.$router.push('/')
                }
            }).catch(error => {
                console.log(error)
            })
        },
        deteleDetail(){
            this.http.delete(`/admin/users/${this.user_id}`).then(result =>{
                if(result.successful){
                    this.alert("Detail deleted", 'success' )
                    this.$router.push('/')
                }else{
                    this.alert(result.error,'danger')
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
        <b-modal
            :active.sync="modal.active"
            has-modal-card
            trap-focus
            aria-role="dialog"
            aria-modal    
        >
            <div class="card">
                <div class="card-header is-danger">
                    <h2 class="card-header-title">
                        Delete
                    </h2>
                </div>
                <div class="card-content">
                    Are you sure to delete this user?
                </div>
                <div class="card-footer has-text-right">
                    <button class="card-footer-item button is-danger" @click="deteleDetail">
                        Yes
                    </button>
                    <button class="card-footer-item button is-secondary" @click="modal.active=false">
                        Cancel
                    </button>
                </div>
            </div>
        </b-modal>
        <div class="card">
            <div class="card-header">
                <h4 class="card-header-title">
                   User details - {{ `${user.id} - ${user.detail_attributes.first_name}` }}
                </h4>
                <router-link :to="`/${user_id}/edit`" class="card-header-icon">
                    <i class="fas fa-edit"></i>
                    Edit
                </router-link>
                <a class="card-header-icon" @click="modal.active = true">
                    <i class="fas fa-eraser"></i>
                    Delete
                </a>
                <router-link :to="`/`" class="card-header-icon">
                    <i class="fas fa-undo"></i>
                    Return
                </router-link>
                
            </div>
            <div class="card-content">
                <form @submit="putDetail">
                    <fieldset :disabled="!isEditable">
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
                    </fieldset>
                </form>
            </div>
        </div>
    </section>
</template>

