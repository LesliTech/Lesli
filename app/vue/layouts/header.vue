<script>
export default {

    data() {
        return {
            aside: {
                timer: null
            },
            chatbotIntent: '',
            microphone: true
        }
    },

    mounted() {

        this.checkIfMicrophoneWorks()

    },

    methods: {

        checkIfMicrophoneWorks() {
            window.SpeechRecognition = window.webkitSpeechRecognition || window.SpeechRecognition;
            if (window.SpeechRecognition) {
                return this.microphone = true
            }
            this.microphone = false
        },

        talk() {
            //var msg = new SpeechSynthesisUtterance('Hello World');
            //window.speechSynthesis.speak(msg);
        },

        listen() {

            window.SpeechRecognition = window.webkitSpeechRecognition || window.SpeechRecognition;

            if (window.SpeechRecognition) {
                const recognition = new window.SpeechRecognition();
                recognition.onresult = (event) => {
                    const speechToText = event.results[0][0].transcript;
                }
                recognition.start();
            }

        },

        showAside() {
            clearTimeout(this.timer)
            let el = document.getElementsByTagName('aside')[0]
            el.classList.toggle('show')
            this.aside.timer = setTimeout(() => el.classList.remove('show'), 4000)
        },

        emitChatbotIntent() {
            this.bus.$emit('component/chatbox/intent', this.chatbotIntent)
            this.chatbotIntent=""
        },

        emitNotify() {
            this.bus.$emit('cloud/layout/notify/notification#show')
        }

    }

}
</script>
<template>
    <header>

        <!-- User navigation area -->
        <nav class="navbar is-transparent">

            <div id="header-main-navbar" class="navbar-menu">

                <!-- Assistant controls -->
                <div class="navbar-start">

                    <button type="button" class="button is-white" @click="showAside">
                        <i class="fas fa-bars"></i>
                    </button>

                    <button :disabled="!microphone" type="button" class="button is-white" @click="listen">
                        <i v-if="microphone" class="fas fa-microphone"></i>
                        <i v-if="!microphone" class="fas fa-microphone-slash"></i>
                    </button>

                    <form v-on:submit.prevent="emitChatbotIntent()">
                        <input class="input" v-model="chatbotIntent" type="text" placeholder="Hello, how can I help you today? :)">
                    </form>
                    
                </div>

                <!-- Brand container -->
                <div class="navbar-brand">
                    <a class="navbar-item" href="/">
                        <img alt="LesliCloud logo" src="/assets/brand/leslicloud-logo.svg" />
                    </a>
                </div>

                <!-- User navigation -->
                <div class="navbar-end">
                    <div class="navbar-item">

                        <a class="navbar-item" @click="emitNotify">
                            <i class="fas fa-bell"></i>
                        </a>

                        <a class="navbar-item" href="/logout">
                            <figure class="image">
                                <img class="is-rounded" src="https://placekitten.com/g/30/30" alt="profile thumbnail">
                            </figure>
                        </a>

                        <a class="navbar-item" href="/logout">
                            <i class="fas fa-sign-out-alt"></i>
                        </a>

                    </div>
                </div>
            </div>
        </nav>
    </header>
</template>
