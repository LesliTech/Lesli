<script setup>
/*

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Ruby on Rails SaaS Development Framework.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/



// · import vue tools
import { ref, reactive, onUnmounted, inject } from "vue"


// · import stores
import { useLayout } from "Lesli/vue/shared/stores/layout"
import { useSearch } from "Lesli/vue/shared/stores/command"


// · implement stores
const storeLayout = useLayout()
const storeSearch = useSearch()


// · 
const url = inject("url")


// · defining props
const props = defineProps({
    showEngines: {
        type: Boolean,
        default: true,
        required: false
    },
    showBell: {
        type: Boolean,
        default: false,
        required: false
    },
    showFocus: {
        type: Boolean,
        default: false,
        required: false
    },
    showSupportTickets: {
        type: Boolean,
        default: false,
        required: false
    },
    showAnnouncements:{
        type: Boolean,
        default: false,
        required: false
    },
    enginePath: {
        type: String,
        default: "/",
        required: false
    }
})


// · translations
const translations = {
    lesli: {
        application: {},
    }
}


// · defining variables
const applicationHeader = ref(null)
const search = {}


// · 
function onEscape(event) {
    if (event.keyCode === 27) {
        storeLayout.toggleEngines()
        document.removeEventListener('keydown', onEscape)
    }
}


// · 
function toggleEngines() {
    storeLayout.toggleEngines()
    document.addEventListener('keydown', onEscape)
}

// · 
function safeEngineUrl() {
    return encodeURI(props.enginePath);
}

</script>
<template>
    <header ref="lesliApplicationHeader" class="lesli-application-header">
        <lesli-navbar>
            <template v-slot:brand>
                <a :href="safeEngineUrl()">
                    <slot name="brand"></slot>
                </a>
            </template>
            <template v-slot:end>

                <slot name="end"></slot>

                <!-- engines selector  -->
                <div class="navbar-item">
                    <a  v-if="props.showEngines"
                        @click="toggleEngines()">
                        <span class="ri-apps-2-line"></span>
                    </a>
                </div>

                <div class="navbar-item">
                    <div class="dropdown is-hoverable">
                        <div class="dropdown-trigger">
                            <button 
                                class="button is-ghost" 
                                aria-haspopup="true" 
                                aria-controls="dropdown-menu"
                                @click="storeLayout.showProfile = true">
                                <span class="ri-user-smile-line">
                                </span>
                            </button>
                        </div>
                        <div class="dropdown-menu" id="dropdown-menu" role="menu">
                            <div class="dropdown-content">
                                <a :href="url.admin('profile')" class="dropdown-item py-3">
                                    <span class="icon-text">
                                        <span class="icon has-text-grey-dark">
                                            <span class="ri-questionnaire-line"></span>
                                        </span>
                                        <span>Help</span>
                                    </span>
                                </a>
                                <a :href="url.admin('profile')" class="dropdown-item py-3">
                                    <span class="icon-text">
                                        <span class="icon has-text-grey-dark">
                                            <span class="ri-equalizer-line"></span>
                                        </span>
                                        <span>Settings</span>
                                    </span>
                                </a>
                                <a :href="url.admin('profile')" class="dropdown-item py-3">
                                    <span class="icon-text">
                                        <span class="icon has-text-grey-dark">
                                            <span class="ri-user-line"></span>
                                        </span>
                                        <span>Profile</span>
                                    </span>
                                </a>
                                <hr class="dropdown-divider" />
                                <a href="/logout" class="dropdown-item py-3">
                                    <span class="icon-text">
                                        <span class="icon has-text-grey-dark">
                                            <span class="ri-logout-box-r-line"></span>
                                        </span>
                                        <span>Logout</span>
                                    </span>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Profile options
                <div class="dropdown is-right is-hoverable header-user-options">
                    <div class="dropdown-trigger">
                        <span class="icon has-text-link">
                            <span class="ri-user-smile-line" @click="storeLayout.showProfile = true">
                            </span>
                        </span>
                    </div>
                    <div class="dropdown-menu" id="dropdown-menu" role="menu">
                        <div class="dropdown-content">
                            <a :href="url.admin('profile')" class="dropdown-item py-3">
                                <span class="icon-text">
                                    <span class="icon has-text-grey-dark">
                                        <span class="ri-user-line"></span>
                                    </span>
                                    <span>{{ translations.lesli.application.navigation_my_profile }}</span>
                                </span>
                            </a>
                            <hr class="dropdown-divider">
                            <a href="/logout" class="dropdown-item py-3">
                                <span class="icon-text">
                                    <span class="icon has-text-grey-dark">
                                        <span class="ri-logout-box-r-line"></span>
                                    </span>
                                    <span>{{ translations.lesli.application.navigation_logout }}</span>
                                </span>
                            </a>
                        </div>
                    </div>
                </div>
                 -->
            </template>
        </lesli-navbar>
        <!--
        <div class="lesli-application-header-container container">
            <div class="lesli-application-header-left">
                <div class="control is-medium has-icons-left has-text-grey">
                    <span class="icon is-left has-text-grey-dark">
                        <span class="material-icons" v-if="!storeSearch.loading">
                            search
                        </span>
                        <lesli-loading :icon="true" v-if="storeSearch.loading">
                        </lesli-loading>
                    </span>
                    <input 
                        type="email" 
                        name="global_search"
                        class="input is-shadowless" 
                        :placeholder="translations.lesli.application.navigation_chat_with_lesli || ''"
                        @input="storeSearch.doSearch"
                        v-model="storeSearch.text" 
                    />
                </div>
            </div>
            <div class="lesli-application-header-right">
                

                < ! - - Tickets - - >
                <a 
                    v-if="props.showSupportTickets"
                    class="header-indicator" 
                    @click="() => { storeLayout.showSupportTickets = true }">
                    <span :class="['ri-ticket-2-line', { 'is-active' : storeLayout.header.tickets > 0 }]">
                    </span>
                    <span class="count" v-if="storeLayout.header.tickets > 0">
                        {{ storeLayout.header.tickets }}
                    </span>
                </a>

                <  ! - - Tasks - - >
                <a  v-if="props.showFocus"
                    class="header-indicator" 
                    @click="() => { if (storeLayout.header.tasks > 0 ) { storeLayout.showTasks = true }}">
                    <span :class="['ri-list-check-3', { 'is-active' : storeLayout.header.tasks > 0 }]">
                    </span>
                    <span class="count" v-if="storeLayout.header.tasks > 0">
                        {{ storeLayout.header.tasks }}
                    </span>
                </a>

                < ! - -  Notifications - - >
                <a 
                    v-if="props.showBell"
                    class="header-indicator" 
                    @click="() => { if (!storeLayout.header.notifications ) { storeLayout.showNotifications = true; }}">
                    <span :class="['ri-notification-3-line', { 'is-active' : storeLayout.header.notifications > 0 }]">
                    </span>
                    <span class="count" v-if="storeLayout.header.notifications > 0">
                        {{ storeLayout.header.notifications }}
                    </span>
                </a>     
            </div>
        </div>
        -->
    </header>
</template>
