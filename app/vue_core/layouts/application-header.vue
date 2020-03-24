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
        this.checkIfMicrophoneWorks()
        this.notification.count = leslicloud_account.notifications.count
    },

    methods: {

        mountListeners() {
            this.bus.subscribe('/core/layout/header/notification#getNotificationsCounter', () => {
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
        },

        showHelp() {
            introJs().start()
        },

        showNotificationPanel() {
            this.bus.publish("show:/core/layout/notification")
        }

    }

}
</script>
<template>
    <header class="application-header">

        <!-- User navigation area -->
        <nav class="navbar is-transparent">

            <!-- Brand container -->
            <div class="navbar-brand">
                <a class="navbar-item" href="/">
                    <slot name="logo"></slot>
                </a>
            </div>

            <div id="header-main-navbar" class="navbar-menu">

                <!-- Assistant controls -->
                <div class="navbar-start">

                    <div class="navbar-item">
                        <div class="control is-medium has-icons-left has-text-grey">
                            <input class="input is-medium is-shadowless" type="email" placeholder="Search...">
                            <span class="icon is-left has-text-gray">
                                <i class="fas fa-search"></i>
                            </span>
                        </div>
                    </div>

                </div>

                <!-- User navigation -->
                <div class="navbar-end">
                    
                    <!-- 
                    <a class="navbar-item" @click="showHelp()">
                        <span class="icon has-text-grey-dark">
                            <i class="far fa-question-circle"></i>
                        </span>
                    </a>
                    -->

                    <div class="navbar-item has-dropdown is-hoverable" data-intro="Language selector">
                        <a class="navbar-item">
                            <span class="icon has-text-grey-light">
                                <span class="flag-icon flag-icon-gb"></span>
                            </span>
                        </a>
                        <div class="navbar-dropdown">
                            <a class="navbar-item">
                                <span class="icon has-text-grey-light">
                                    <span class="flag-icon flag-icon-de"></span>
                                </span>
                                <span>Deutsche</span>
                            </a>
                            <a class="navbar-item">
                                <span class="icon has-text-grey-light">
                                    <span class="flag-icon flag-icon-gb"></span>
                                </span>
                                <span>English</span>
                            </a>
                            <a class="navbar-item">
                                <span class="icon has-text-grey-light">
                                    <span class="flag-icon flag-icon-es"></span>
                                </span>
                                <span>Español</span>
                            </a>
                        </div>
                    </div>

                    <a class="navbar-item notification-indicator" data-intro="Notification icon" @click="showNotificationPanel()">
                        <i v-if="notification.count > 0" class="fas fa-bell has-text-link"></i>
                        <i v-if="notification.count == 0" class="far fa-bell"></i>
                        <span></span>
                    </a>

                    <div class="navbar-item has-dropdown is-hoverable" data-intro="Account options">
                        <span class="navbar-link">
                            <slot name="username"></slot>
                        </span>

                        <div class="navbar-dropdown">
                            <a class="navbar-item">
                                <span class="icon has-text-grey-light">
                                    <i class="fas fa-user"></i>
                                </span>
                                <span>Profile</span>
                            </a>
                            <hr class="navbar-divider">
                            <a class="navbar-item" href="/logout">
                                <span class="icon has-text-grey-light">
                                    <i class="fas fa-sign-out-alt"></i>
                                </span>
                                <span>Logout</span>
                            </a>
                        </div>
                    </div>

                </div>
            </div>
        </nav>
    </header>
</template>
