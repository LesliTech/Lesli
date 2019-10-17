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

@dev      Luis Donis <ldonis@lesli.tech>
@author   LesliTech <hello@lesli.tech>
@license  Propietary - all rights reserved.
@version  0.1.0-alpha

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/
export default {
    props: {
        cloudModule: {
            type: String,
            required: true
        },
        cloudOwnerId: {
            required: true
        }
    },
    data() {
        return {
            actions: []
        }
    },
    mounted() {
        this.getActions()
        this.bus.$on("post:/help/ticket/actions", () => {
            this.getActions()
        })
    },
    methods: {

        getActions() {
            this.http.get(`/${this.cloudModule}s/${this.cloudOwnerId}/actions`).then(result => {
                if (result.successful) {
                    this.actions = result.data
                }
            }).catch(error => {
                console.log(error)
            })
        },

        updateAsComplete(ticket) {
            this.http.patch(`/help/ticket/actions/${ ticket.id }`, {
                ticket_action: {
                    id: ticket.id,
                    complete: ticket.complete,
                    cloud_help_tickets_id: ticket.cloud_help_tickets_id
                }
            }).then(result => {
                if (result.successful) {
                    if (result.data.complete == true) {
                        this.alert('Task marked as completed!')
                    }
                    if (result.data.complete != true) {
                        this.alert('Task marked as not completed!')
                    }
                }
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
            <div class="card-content">
                <ul>
                    <li class="field" v-for="action in actions" :key="action.id">
                        <input class="is-checkradio" type="checkbox" v-model="action.complete" @change="updateAsComplete(action)">
                        {{ action.instructions }}
                        <!-- 
                        <b-checkbox v-model="action.status" @change="updateAsComplete">
                            {{ action.instructions }}
                        </b-checkbox>
                         -->
                    </li>
                </ul>
            </div>
        </div>
    </section>
</template>
