<script>
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

        this.bus.$on('lesli.component.chatbox.postIntent', intent => {
            this.showchat=true
            this.openchat=true
            this.postIntent(intent)
        })

    },
    methods: {

        postIntent(intent=false) {

            // postIntent can be called as function
            if (intent) { this.intent = intent }

            // do not process intent if intent is empty
            if (intent == '') { return }

            this.loading = true
            this.intents.push({type:'intent',text:this.intent})
            this.intent = ""

            let timeout = setTimeout(() => {
                this.intents.push({
                    type: 'response',
                    text: new Date()
                })
                this.loading = false
                let chatBody = document.getElementsByClassName("chat-body")[0]
                chatBody.scrollTop = chatBody.scrollHeight; 
            }, 800)

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
                    <img src="/assets/brand/leslicloud-logo.png">
                </span>
                <p>{{ intent.text }}</p>
                <span v-if="intent.type == 'response'">
                    <img src="https://cdn.lesli.tech/leslicloud/brand/leslicloud_isotipo-nomargin.png">
                </span>
            </div>
            <div class="response" v-if="loading">
                <div class="loading-animation">
                    <hr/><hr/><hr/><hr/>
                </div>
            </div>
        </div>
        <div class="chat-footer" v-show="openchat">
            <form v-on:submit.prevent="postIntent()">
                <input v-model="intent" :disabled="loading" type="text" placeholder="How can I help you?">
            </form>
        </div>
    </div>
</template>
