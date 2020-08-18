<script>
const platform = require('platform');

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
                    shared: I18n.t('core.shared'),
                    users: I18n.t('core.users'),
                }
            },
            browser_data: {}
        }
    },

    mounted() {
        this.getBrowserData();
        this.setSubscriptions();
        this.getNotificationsCount();
        this.checkIfMicrophoneWorks();
    },

    methods: {
        getBrowserData(){
            this.browser_data = {
                name: platform.name,
                full_version: platform.version,
                version: parseInt(platform.version.split('.')[0]),
                layout: platform.layout
            }
        },

        setSubscriptions() {
            this.bus.subscribe('/lesli/layout/header/notification#getNotificationsCounter', () => {
                this.getNotificationsCount()
            })
        },

        getNotificationsCount() {

            // due performance issues we are going to get notification count
            // through account data partial
            this.notification.count = lesli.notifications
            return 

            this.http.get('/bell/notifications.json?view_type=count').then(result => {
                if (result.successful) {
                    this.notification.count = result.data
                }
            }).catch(error => {
                console.log(error)
            })
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

        showApps(side) {
            this.bus.publish("show:/core/layout/apps#panel", side)
        },

        showNotifications() {
            this.bus.publish("show:/core/layout/notification#panel")
        },

        searchText(input) {

            this.search.searching = !input.srcElement.value == ""

            this.bus.publish("search:/core/layouts/component-global-search", input.srcElement.value)

            setTimeout(() => {
                this.search.searching = false
            }, 1400)

        }

    },

    computed: {
        supportedBrowser(){
            if(this.browser_data.name == 'Microsoft Edge' && this.browser_data.version < 84){
                return false
            }

            return true
        }
    }

}
</script>
<template>
    <header class="application-header">
        <b-navbar transparent>
            <template slot="brand">
                <a class="navbar-item is-hidden-touch apps_switch" @click="showApps('left')">
                    <span class="icon">
                        <svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 512 512'><title></title><path d='M104,160a56,56,0,1,1,56-56A56.06,56.06,0,0,1,104,160Z'/><path d='M256,160a56,56,0,1,1,56-56A56.06,56.06,0,0,1,256,160Z'/><path d='M408,160a56,56,0,1,1,56-56A56.06,56.06,0,0,1,408,160Z'/><path d='M104,312a56,56,0,1,1,56-56A56.06,56.06,0,0,1,104,312Z'/><path d='M256,312a56,56,0,1,1,56-56A56.06,56.06,0,0,1,256,312Z'/><path d='M408,312a56,56,0,1,1,56-56A56.06,56.06,0,0,1,408,312Z'/><path d='M104,464a56,56,0,1,1,56-56A56.06,56.06,0,0,1,104,464Z'/><path d='M256,464a56,56,0,1,1,56-56A56.06,56.06,0,0,1,256,464Z'/><path d='M408,464a56,56,0,1,1,56-56A56.06,56.06,0,0,1,408,464Z'/></svg>
                    </span>
                </a>
                <slot name="brand" class="ldonis"></slot>
            </template>
            <template slot="start">
                <div class="navbar-item">
                    <div class="control is-medium has-icons-left has-text-grey">
                        <input class="input is-medium is-shadowless" name='global_search' type="email" @input="searchText" :placeholder="translations.core.shared.search_placeholder">
                        <span class="icon is-left has-text-gray">
                            <i v-if="!search.searching" class="fas fa-search"></i>
                            <component-data-loading v-if="search.searching && searchText!=''" :icon-only="true"/>
                        </span>
                    </div>
                </div>
            </template>

            <template slot="end">

                <slot name="languages"></slot>

                <a class="navbar-item notification-indicator" data-intro="Notification icon" @click="showNotifications()">
                    <i v-if="notification.count > 0" class="fas fa-bell has-text-link"></i>
                    <i v-if="notification.count == 0" class="far fa-bell"></i>
                    <span>{{ notification.count }}</span>
                </a>

                <a class="navbar-item apps_switch" @click="showApps('right')">
                    <span class="icon">
                        <svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 512 512'><title></title><path d='M104,160a56,56,0,1,1,56-56A56.06,56.06,0,0,1,104,160Z'/><path d='M256,160a56,56,0,1,1,56-56A56.06,56.06,0,0,1,256,160Z'/><path d='M408,160a56,56,0,1,1,56-56A56.06,56.06,0,0,1,408,160Z'/><path d='M104,312a56,56,0,1,1,56-56A56.06,56.06,0,0,1,104,312Z'/><path d='M256,312a56,56,0,1,1,56-56A56.06,56.06,0,0,1,256,312Z'/><path d='M408,312a56,56,0,1,1,56-56A56.06,56.06,0,0,1,408,312Z'/><path d='M104,464a56,56,0,1,1,56-56A56.06,56.06,0,0,1,104,464Z'/><path d='M256,464a56,56,0,1,1,56-56A56.06,56.06,0,0,1,256,464Z'/><path d='M408,464a56,56,0,1,1,56-56A56.06,56.06,0,0,1,408,464Z'/></svg>
                    </span>
                </a>

                <div class="navbar-item has-dropdown is-hoverable" data-intro="Account options">
                    <span class="navbar-link">
                        <slot name="username"></slot>
                    </span>
                    <div class="navbar-dropdown is-right">
                        <a href="/profile" class="navbar-item">
                            <span class="icon has-text-grey-light">
                                <i class="fas fa-user"></i>
                            </span>
                            <span>{{ translations.core.users.text_profile }}</span>
                        </a>
                        <hr class="navbar-divider">
                        <a class="navbar-item" href="/logout">
                            <span class="icon has-text-grey-light">
                                <i class="fas fa-sign-out-alt"></i>
                            </span>
                            <span>{{ translations.core.users.text_logout }}</span>
                        </a>
                    </div>
                </div>
            </template>
        </b-navbar>
        <b-notification v-if="! supportedBrowser" type="is-warning">
            You currently are using {{browser_data.name}} - {{browser_data.full_version}}, which
            is not a supported web browser, and some of the features of the system may not work correctly when using it.
            We recomend you to change to a supported one. For a list of supported browsers, check
            <a target="_blank" href="/about#system_requirements">here</a>
        </b-notification>
    </header>
</template>
