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

Lesli - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  <hello@lesli.tech>
@website  <https://lesli.tech>
@license  Propietary - all rights reserved.

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
            search: {
                searching: false
            },
            chatbotIntent: '',
            microphone: true,
            translations: {
                core: {
                    shared: I18n.t('core.shared')
                }
            }
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
            this.bus.publish("show:/core/layout/notification#panel")
        },

        searchText(input) {

            this.search.searching = !input.srcElement.value == ""

            this.bus.publish("search:/core/layouts/component-global-search", input.srcElement.value)

            setTimeout(() => {
                this.search.searching = false
            }, 1400)

        }

    }

}
</script>
<template>
    <header class="application-header">
        <b-navbar fixed-top>
            <template slot="brand">
                <slot name="brand"></slot>
            </template>

            <template slot="start">
                <div class="navbar-item">
                    <div class="control is-medium has-icons-left has-text-grey">
                        <input class="input is-medium is-shadowless" type="email" @input="searchText" :placeholder="translations.core.shared.search_placeholder">
                        <span class="icon is-left has-text-gray">
                            <i v-if="!search.searching" class="fas fa-search"></i>
                            <component-data-loading v-if="search.searching && searchText!=''" :icon-only="true"/>
                        </span>
                    </div>
                </div>
            </template>

            <template slot="end">

                <!-- 
                <a class="navbar-item" @click="showHelp()">
                    <span class="icon has-text-grey-dark">
                        <i class="far fa-question-circle"></i>
                    </span>
                </a>
                -->

                <slot name="languages"></slot>

                <a class="navbar-item notification-indicator" data-intro="Notification icon" @click="showNotificationPanel()">
                    <i v-if="notification.count > 0" class="fas fa-bell has-text-link"></i>
                    <i v-if="notification.count == 0" class="far fa-bell"></i>
                    <span>0</span>
                </a>

                <div class="navbar-item has-dropdown is-hoverable" data-intro="Account options">
                    <span class="navbar-link">
                        <slot name="username"></slot>
                    </span>
                    <div class="navbar-dropdown">
                        <a class="navbar-item" @click="url.go('/crm/users/'+lesli.current_user.id)">
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

            </template>
        </b-navbar>
    </header>
</template>
