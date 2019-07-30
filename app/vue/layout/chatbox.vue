<script>
export default {
    data() {
        return {
            intent: "",
            intents:[ ],
            loading: false
        }
    },
    mounted() {
        for (let i = 0; i < 2; i++) {
            this.intents.push({type:'intent',text:'My intent'})
            this.intents.push({type:'response',text:'The response'})
        }
    },
    methods: {

        postIntent() {

            this.loading = true
            this.intents.push({type:'intent',text:this.intent})
            //this.intent = ""

            setTimeout(() => {
                this.intents.push({
                    type: 'response',
                    text: this.intent
                })
                this.loading = false
                this.intent = ""
            }, 800)

        }

    }
}
</script>
<template>
    <div class="chatbox">
        <div class="chat-header">
            <ul class="nav">
                <li class="nav-item">
                    <a class="navbar-brand">
                        
                        LesliCloud</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link">
                        <i class="fas fa-minus"></i>
                    </a>
                </li>
                <li class="nav-item">
                    <i class="fas fa-times"></i>
                </li>
            </ul>
        </div>
        <div class="chat-body">
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
        <div class="chat-footer">
            <form v-on:submit.prevent="postIntent()">
                <input v-model="intent" type="text" placeholder="How can I help you?">
            </form>
        </div>
    </div>
</template>
