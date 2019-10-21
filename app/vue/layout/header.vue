<script>
export default {

    data() {
        return {
            notification: {
                show: false,
                timer: null,
                list: []
            },
            chatbotIntent: '',
            microphone: true,
            timer: null
        }
    },

    mounted() {

        this.checkIfMicrophoneWorks()
        this.getNotifications()

    },

    methods: {

        checkIfMicrophoneWorks() {
            window.SpeechRecognition = window.webkitSpeechRecognition || window.SpeechRecognition;
            if (window.SpeechRecognition) {
                this.microphone = true
                return
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

        emitSidenavShow() {
            clearTimeout(this.timer)
            let el = document.getElementsByTagName('aside')[0]
            el.classList.toggle('show')
            this.timer = setTimeout(() => el.classList.remove('show'), 4000)
        },

        emitChatbotIntent() {
            this.bus.$emit('lesli.component.chatbox.postIntent', this.chatbotIntent)
            this.chatbotIntent=""
        },

        showNotifications() {
            this.notification.show = true
            this.notification.timer = setTimeout(() => this.notification.show = false, 250000)
        },

        getNotifications() {
            this.http.get('/bell/notifications.json').then(result => {
                if (result.successful){
                    this.notification.list = result.data
                }
            }).catch(error => {
                console.log(error)
            })
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

                    <button type="button" class="button is-white" @click="emitSidenavShow">
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

                        <a class="navbar-item" @click="showNotifications">
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

        <div id="quickviewDefault" :class="[{ 'is-active': notification.show }, 'quickview']">
            <header class="quickview-header" @click="notification.show = false">
                <p class="title">Notifications</p>
                <!-- <span class="delete" @click="notification.show = false"></span> -->
                <i class="fas fa-chevron-right"></i>
            </header>
            <div class="quickview-body">
                <div class="quickview-block">
                    <div class="section">
                        <ul class="menu-list">
                            <li v-for="(notification, index) in notification.list" :key="index" >
                                <a :href="notification.href">{{ notification.content }}</a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
            <footer class="quickview-footer">
            </footer>
        </div>


    </header>
</template>
