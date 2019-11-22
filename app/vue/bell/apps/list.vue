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


// · 
export default {

    data() {
        return {
            notifications: [],
            columns: [{
                field: 'subject',
                label: 'Subject'
            }]
        }
    },
    mounted() {
        this.getNotifications()
    },
    methods: {

        getNotifications() {
            this.notifications = []
            this.http.get('/bell/notifications.json').then(result => {
                this.notifications = result.data
            }).catch(error => {
                console.log(error)
            })
        }
    }

}
</script>
<template>
    <section class="section">
        <div class="card">
            <div class="card-header">
                <h4 class="card-header-title">
                    My notifications
                </h4>
            </div>
            <div class="card-body">
                <table class="table is-fullwidth">
                    <thead>
                        <tr>
                            <th>id</th>
                            <th>Subject</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="notification in notifications" :key="notification.id">
                            <td>{{ notification.id }}</td>
                            <td>{{ notification.subject }}</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </section>
</template>
