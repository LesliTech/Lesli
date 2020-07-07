<script>
/*
Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

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

@license  Propietary - all rights reserved.
@version  0.1.0-alpha

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/


// · 
import componentHeader from "../components/chatbox/header.vue"
import componentLoading from "../components/chatbox/loading.vue"
import componentRequest from "../components/chatbox/request.vue"
import componentResponse from "../components/chatbox/response.vue"
import componentList from "../components/chatbox/list.vue"
import componentTeamAttendance from "../components/chatbox/team-attendance.vue"
import componentDriverEvents from "../components/chatbox/driver-events.vue"


import axios from 'axios'


// · 
export default {
    components: {
        'component-header': componentHeader,
        'component-loading': componentLoading
    },
    data() {
        return {
            components: {
                list: componentList,
                request: componentRequest,
                response: componentResponse,
                team_attendance: componentTeamAttendance,
                driver_events: componentDriverEvents
            },
            intent: "",
            intents:[ ],
            loading: false,
            openchat: false,
            showchat: false
        }
    },
    mounted() {
        this.bus.subscribe('/cloud/layout/chatbox#postIntent', intent => {
            this.showchat=true
            this.openchat=true
            this.intent = intent
            this.postIntent()
        })
        this.bus.subscribe('/cloud/layout/chatbox#manageChatbox', close => {

            if (close) {
                this.showchat=false
                this.openchat=false
                return
            }

            this.openchat=!this.openchat

            if (this.openchat) {
                this.getHistory()
            }
            
        })
    },
    methods: {

        scrollChatbox() {
            let chatBody = document.getElementsByClassName("chat-body")[0]
            chatBody.scrollTop = chatBody.scrollHeight
        },

        getHistory() {
            axios.get("http://localhost:8888/api/chatbot/history?last=10").then(result => {
                this.intents = result.data.data
            }).catch(error => {
                console.log(error)
            })
        },

        postIntent() {

            // do not process intent if intent is empty
            if (this.intent == '') { return }

            this.loading = true

            this.intents.push({type: "request", text:this.intent})
            
            this.scrollChatbox()

            //axios.post("http://localhost:8888/api/chatbot/intent", {
            /*
            axios.post("https://api.lesli.chat/api/chatbot/intent", {
                "session": {
                    "id": "5367990660997635",
                    "reference": window.location.pathname
                },
                "intent": {
                    "query": this.intent,
                    "language": "en"
                }
            }).then(result => {

                result = result.data

                if (!result.successful) {

                }

                result.data.forEach(response => {
                    this.intents.push(response)
                })

                this.scrollChatbox()

                this.intent = ""
                
                this.loading = false

                //this.url.go("/lesli/assistants/"+result.data.action.ui.id)

                console.log(JSON.parse(JSON.stringify(this.intents)))

            }).catch(error => {
                console.log(error)
            })
            */
            this.intents.push({
                type: 'response',
                text: 'Mi respuesta'
            })
            this.intent = ""     
            this.loading = false

        }

    }
}
</script>
<template>
    <section class="lesli-app-chatbox" v-if="showchat">
        <component-header></component-header>
        <div class="chat-body" v-show="openchat">
            <template v-for ="(intent, index) in intents">
                <component
                    :class="'chat-'+intent.type" 
                    :is="components[intent.type]"
                    :data="intent"
                    :key="index">
                </component>
            </template>
            <component-loading v-if="loading" />
        </div>
        <div class="chat-footer" v-show="openchat">
            <input 
                type="text"
                v-model="intent" 
                :disabled="loading" 
                :placeholder="'How can I help you?'" 
                @keyup.enter="postIntent" 
            />
        </div>
    </section>
</template>
