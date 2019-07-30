<script>
export default {
    data() {
        return {
            intent: "",
            intents:[ ],
            loading: false,
            openchat: false,
            showchat: true
        }
    },
    mounted() {

        for (let i = 0; i < 2; i++) {
            this.intents.push({type:'intent',text:'My intent'})
            this.intents.push({type:'response',text:'The response'})
        }

        this.bus.$on('main.layout.chatbox.postIntent', intent => {
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

            setTimeout(() => {
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
        <div class="chat-header">
            <ul class="nav">
                <li class="nav-item">
                    <a class="navbar-brand">
                        LesliCloud {{ openchat }}
                    </a>
                </li>
                <li class="nav-item" @click="openchat=!openchat">
                    <a class="nav-link"><i class="fas fa-minus"></i></a>
                </li>
                <li class="nav-item" @click="showchat=!showchat">
                    <i class="fas fa-times"></i>
                </li>
            </ul>
        </div>
        <div class="chat-body" v-show="openchat">
             <div v-for="(intent, index) in intents" :key="index" :class="intent.type">
                <span v-if="intent.type == 'intent'">
                    <img src="https://cdn.lesli.tech/leslicloud/brand/leslicloud_isotipo-nomargin.png">
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
