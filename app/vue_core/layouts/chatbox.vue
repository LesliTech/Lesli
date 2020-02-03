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

import axios from 'axios'

export default {
    data() {
        return {
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
    },
    methods: {

        postIntent() {

            // do not process intent if intent is empty
            if (this.intent == '') { return }

            this.loading = true
            this.intents.push({type:'intent', text:this.intent})
            

            axios.post("http://localhost:8888/api/chatbot/intent", {
                "session": {
                    "id": "8de896395dd33ca30c14fb2ebcc25df3",
                    "reference": "my-app-url.com/app/action"
                },
                "intent": {
                    "query": this.intent,
                    "language": "en"
                }
            }).then(result => {

                result = result.data

                if (!result.successful) {

                }

                this.intents.push({
                    type: "response",
                    text: result.data.fulfillment
                })

                this.intent = ""
                
                let chatBody = document.getElementsByClassName("chat-body")[0]
                chatBody.scrollTop = chatBody.scrollHeight

                this.loading = false


            }).catch(error => {
                console.log(error)
            })

            

        }

    }
}
</script>
<template>
    <div class="chatbox" v-show="showchat">
        <div class="chat-header" @click="openchat=!openchat">
            <nav class="navbar" role="navigation" aria-label="main navigation">
                <div class="navbar-brand">
                    <a class="navbar-item">
                        Lesli
                    </a>
                </div>
                <div class="navbar-menu">
                    <div class="navbar-start">
                    </div>
                    <div class="navbar-end">
                        <div class="navbar-item">
                            <div class="buttons">
                                <a class="button is-white" @click="openchat=!openchat">
                                    <i class="fas fa-minus"></i>
                                </a>
                                <a class="button is-white" @click="showchat=!showchat">
                                    <i class="fas fa-times"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </nav>
        </div>
        <div class="chat-body" v-show="openchat">
            <div v-for="(intent, index) in intents" :key="index" :class="intent.type">
                <span v-if="intent.type == 'intent'">
                    <img src="/assets/brand/leslicloud-logo.png" />
                </span>
                <p>{{ intent.text }}</p>
                <span v-if="intent.type == 'response'">
                    <img src="/assets/brand/leslicloud-logo.png" />
                </span>
            </div>
            <div class="response" v-if="loading">
                <div class="loading-animation">
                    <hr/><hr/><hr/><hr/>
                </div>
            </div>
        </div>
        <div class="chat-footer" v-show="openchat">
            <div>
                <input v-model="intent" :disabled="loading" type="text" placeholder="How can I help you?" @keyup.enter="postIntent">
            </div>
        </div>
    </div>
</template>
