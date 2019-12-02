<script>
export default {

    data() {
        return {
            notification: {
                count: 0
            },
            aside: {
                timer: null
            },
            chatbotIntent: '',
            microphone: true
        }
    },

    mounted() {
        this.mountListeners()
        this.getNotificationsCounter()
        this.checkIfMicrophoneWorks()
    },

    methods: {

        mountListeners() {
            this.bus.subscribe('/cloud/layout/header/notification#getNotificationsCounter', () => {
                this.getNotificationsCounter()
            })
        },

        getNotificationsCounter() {
            this.http.get('/bell/notifications.json').then(result => {
                if (result.successful) {
                    this.notification.count = result.data.length
                }
            }).catch(error => {
                console.log(error)
            })
        },

        openAside() {
            clearTimeout(this.timer)
            let el = document.getElementsByTagName('aside')[0]
            el.classList.toggle('show')
            this.aside.timer = setTimeout(() => el.classList.remove('show'), 4000)
        },

        checkIfMicrophoneWorks() {
            window.SpeechRecognition = window.webkitSpeechRecognition || window.SpeechRecognition;
            if (window.SpeechRecognition) {
                return this.microphone = true
            }
            this.microphone = false
        },

        publishChatbotIntent() {
            this.bus.publish('/cloud/layout/chatbox#postIntent', this.chatbotIntent)
            this.chatbotIntent = ''
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

                    <button type="button" class="button is-white" @click="openAside">
                        <i class="fas fa-bars"></i>
                    </button>

                    <button :disabled="!microphone" type="button" class="button is-white" @click="listen">
                        <i v-if="microphone" class="fas fa-microphone"></i>
                        <i v-if="!microphone" class="fas fa-microphone-slash"></i>
                    </button>

                    <div>
                        <input class="input" v-model="chatbotIntent" type="text" placeholder="Hello, how can I help you today? :)" @keyup.enter="publishChatbotIntent()">
                    </div>
                    
                </div>

                <!-- Brand container -->
                <div class="navbar-brand">
                    <a class="navbar-item" href="/">
                        <slot name="logo"></slot>
                    </a>
                </div>

                <!-- User navigation -->
                <div class="navbar-end">
                    <div class="navbar-item">

                        <a class="navbar-item" @click="bus.publish('open:/cloud/layout/notify#notification')">
                            <i v-if="notification.count > 0" class="fas fa-bell has-text-link"></i>
                            <i v-if="notification.count == 0" class="far fa-bell"></i>
                            <span 
                                v-if="notification.count > 0" 
                                id="notification_total">
                                {{ notification.count }}
                            </span>
                        </a>

                        <a class="navbar-item" href="/admin/users/">
                            <figure class="image">
                                <img class="is-rounded" src="https://placekitten.com/g/30/30" alt="profile thumbnail">
                            </figure>
                        </a>

                        <a class="navbar-item" href="/admin/users">
                            <i class="fas fa-users"></i>
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
