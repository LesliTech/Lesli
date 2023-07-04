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

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

*/



// · import vue tools
import { ref, reactive, onUnmounted, inject } from "vue"


// · import stores
import { useLayout } from "Lesli/shared/stores/layout"
import { useSearch } from "Lesli/shared/stores/search"


// · implement stores
const storeLayout = useLayout()
const storeSearch = useSearch()


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
    showTickets:{
        type: Boolean,
        default: false,
        required: false
    },
    showAnnouncements:{
        type: Boolean,
        default: false,
        required: false
    }
})


// · translations
const translations = {
    core: {
        shared: I18n.t("core.shared"),
        users: I18n.t('deutscheleibrenten.users'),
    }
}


// · defining variables
const applicationHeader = ref(null)
const search = {}


// · capture user scroll to add special styles for the header
function handleScroll($event) {

    let scrollTop = window.pageYOffset || document.body.scrollTop;
    if (scrollTop > applicationHeader.value.offsetHeight - 100) {
        applicationHeader.value.classList.add("scrolling-header-navigation")
    } else {
        applicationHeader.value.classList.remove("scrolling-header-navigation")
    }
}


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


// · listen for all the scroll event
window.addEventListener('scroll', handleScroll);


// · stop listeners
onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
})

</script>
<template>
    <header ref="applicationHeader" class="application-header">
        <div class="header-navigation">
            <div class="header-left">
                <div class="control is-medium has-icons-left has-text-grey">
                    <input 
                        type="email" 
                        name="global_search"
                        class="input is-medium is-shadowless" 
                        :placeholder="translations.core.shared.search_placeholder || 'Search...'"
                        @input="storeSearch.doSearch"
                        v-model="storeSearch.text" 
                    />
                    <span class="icon is-left has-text-gray">
                        <span class="material-icons" v-if="!storeSearch.loading">
                            search
                        </span>
                        <lesli-loading :icon="true" v-if="storeSearch.loading">
                        </lesli-loading>
                    </span>
                </div>
            </div>
            <div class="header-right">

                <!-- engines selector -->
                <a  v-if="props.showEngines"
                    class="navbar-item" @click="toggleEngines()">
                    <span class="material-icons md-36">
                        apps
                    </span>
                </a>

                <!-- Tickets -->
                <a 
                    v-if="props.showTickets"
                    class="navbar-item header-notification-indicator" 
                    @click="() => { storeLayout.showTickets = true }">
                    <span :class="['material-icons md-36', { 'is-active' : storeLayout.header.tickets > 0 }]">
                        confirmation_number
                    </span>
                    <span class="count" v-if="storeLayout.header.tickets > 0">
                        {{ storeLayout.header.tickets }}
                    </span>
                </a>

                <!-- Tasks -->
                <a  v-if="props.showFocus"
                    class="navbar-item header-notification-indicator" 
                    @click="() => { if (storeLayout.header.tasks > 0 ) { storeLayout.showTasks = true }}">
                    <span :class="['material-icons md-36', { 'is-active' : storeLayout.header.tasks > 0 }]">
                        checklist
                    </span>
                    <span class="count" v-if="storeLayout.header.tasks > 0">
                        {{ storeLayout.header.tasks }}
                    </span>
                </a>

                <!-- Announcements -->
                <a 
                    v-if="props.showAnnouncements"
                    class="navbar-item header-notification-indicator" 
                    @click="() => { { storeLayout.showAnnouncements = true }}">
                    <span :class="['material-icons md-36']">
                        campaign
                    </span>
                    <span>
                        {{ storeLayout.header.announcements }}
                    </span>
                </a>

                <!-- Notifications -->
                <a 
                    v-if="props.showBell"
                    class="navbar-item header-notification-indicator" 
                    @click="() => { if (storeLayout.header.notifications > 0 ) { storeLayout.showNotifications = true }}">
                    <span :class="['material-icons md-36', { 'is-active' : storeLayout.header.notifications > 0 }]">
                        notifications
                    </span>
                    <span class="count" v-if="storeLayout.header.notifications > 0">
                        {{ storeLayout.header.notifications }}
                    </span>
                </a>

                <!-- Profile options -->
                <div class="dropdown is-right is-hoverable header-user-options">
                    <div class="dropdown-trigger">
                        <span class="material-icons md-36" @click="storeLayout.showProfile = true">
                            account_box
                        </span>
                    </div>
                    <div class="dropdown-menu" id="dropdown-menu" role="menu">
                        <div class="dropdown-content">
                            <a href="/administration/profile" class="dropdown-item header-user-options-profile ">
                                <span class="icon-text">
                                    <span class="icon has-text-grey-light">
                                        <span class="material-icons">
                                            person
                                        </span>
                                    </span>
                                    <span>{{ translations.core.shared.view_text_profile }}</span>
                                </span>
                            </a>
                            <hr class="dropdown-divider">
                            <a href="/logout" class="dropdown-item">
                                <span class="icon-text">
                                    <span class="icon">
                                        <span class="material-icons">
                                            logout
                                        </span>
                                    </span>
                                    <span>{{ translations.core.shared.view_text_logout }}</span>
                                </span>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </header>
</template>
