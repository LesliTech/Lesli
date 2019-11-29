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

    data() {
        return {
            users: [],
            columns: [{
                field: 'id',
                label: 'ID'
            }, {
                field: 'email',
                label: 'Email'
            }]
        }
    },

    mounted() {
        this.getUsers()
    },
    
    methods: {

        getUsers() {
            this.http.get('/admin/users.json').then(result => {
                this.users = result.data
            }).catch(error => {
                console.log(error)
            })
        },

        clickUser(user) {
            this.$router.push(`${user.id}`)
        }

    }
}
</script>
<template>
    <section>
        <div class="card">
            <div class="card-header">
                <router-link class="button is-link" to="/new">New user</router-link>
                <router-link class="button is-link" to="/invite">invite user</router-link>
            </div>
            <div class="card-content">
                <b-table 
                    :data="users" 
                    :columns="columns"
                    :hoverable="true"
                    @click="clickUser"
                    ></b-table>
            </div>
        </div>
    </section>
</template>
