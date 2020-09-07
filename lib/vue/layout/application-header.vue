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
            translations: {
                core: {
                    shared: I18n.t('deutscheleibrenten.shared'),
                    users: I18n.t('deutscheleibrenten.users'),
                }
            },
            notification: {
                count: 0
            },
            search: {
                searching: false
            },
            navigation: {
                active: false
            },
            browser_data: {}
        }
    },

    mounted() {
        this.getBrowserData();
        this.setSubscriptions();
        this.getNotificationsCount();
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
        <div class="header-navigation">
            <div class="header-left">
                <div class="control is-medium has-icons-left has-text-grey">
                    <input class="input is-medium is-shadowless" name='global_search' type="email" @input="searchText" :placeholder="translations.core.shared.search_placeholder">
                    <span class="icon is-left has-text-gray">
                        <i v-if="!search.searching" class="fas fa-search"></i>
                        <component-data-loading v-if="search.searching && searchText!=''" :icon-only="true"/>
                    </span>
                </div>
            </div>
            <div class="header-right">

                <slot name="languages"></slot>

                <a class="navbar-item notification-indicator" @click="showNotifications()">
                    <i v-if="notification.count > 0" class="fas fa-bell has-text-link"></i>
                    <i v-if="notification.count == 0" class="far fa-bell"></i>
                    <span>{{ notification.count }}</span>
                </a>

                <a class="navbar-item modules-switch" @click="showApps('right')">
                    <span class="icon">
                        <svg viewBox="0 0 24 24">
                            <path d="M6,8c1.1,0 2,-0.9 2,-2s-0.9,-2 -2,-2 -2,0.9 -2,2 0.9,2 2,2zM12,20c1.1,0 2,-0.9 2,-2s-0.9,-2 -2,-2 -2,0.9 -2,2 0.9,2 2,2zM6,20c1.1,0 2,-0.9 2,-2s-0.9,-2 -2,-2 -2,0.9 -2,2 0.9,2 2,2zM6,14c1.1,0 2,-0.9 2,-2s-0.9,-2 -2,-2 -2,0.9 -2,2 0.9,2 2,2zM12,14c1.1,0 2,-0.9 2,-2s-0.9,-2 -2,-2 -2,0.9 -2,2 0.9,2 2,2zM16,6c0,1.1 0.9,2 2,2s2,-0.9 2,-2 -0.9,-2 -2,-2 -2,0.9 -2,2zM12,8c1.1,0 2,-0.9 2,-2s-0.9,-2 -2,-2 -2,0.9 -2,2 0.9,2 2,2zM18,14c1.1,0 2,-0.9 2,-2s-0.9,-2 -2,-2 -2,0.9 -2,2 0.9,2 2,2zM18,20c1.1,0 2,-0.9 2,-2s-0.9,-2 -2,-2 -2,0.9 -2,2 0.9,2 2,2z">
                            </path>
                        </svg>
                    </span>
                </a>

                <div class="dropdown is-right is-hoverable user-options">
                    <div class="dropdown-trigger">
                        <button class="button" aria-haspopup="true" aria-controls="dropdown-menu">
                            <span><slot name="username"></slot></span>
                            <span class="icon is-small">
                                <i class="fas fa-angle-down" aria-hidden="true"></i>
                            </span>
                        </button>
                    </div>
                    <div class="dropdown-menu" id="dropdown-menu" role="menu">
                        <div class="dropdown-content">
                            <a href="/profile" class="dropdown-item">
                                <span class="icon has-text-grey-light">
                                    <i class="fas fa-user"></i>
                                </span>
                                <span>{{ translations.core.users.text_profile }}</span>
                            </a>
                            <hr class="dropdown-divider">
                            <a href="/logout" class="dropdown-item">
                                <span class="icon has-text-grey-light">
                                    <i class="fas fa-sign-out-alt"></i>
                                </span>
                                <span>{{ translations.core.users.text_logout }}</span>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <b-notification v-if="! supportedBrowser" type="is-warning">
            {{translations.core.shared.notice_browser_not_supported_1}}
            {{browser_data.name}} - {{browser_data.full_version}}
            {{translations.core.shared.notice_browser_not_supported_2}}
            <a target="_blank" href="/system-requirements">
                {{translations.core.shared.notice_browser_not_supported_3}}
            </a>
        </b-notification>
    </header>
</template>
