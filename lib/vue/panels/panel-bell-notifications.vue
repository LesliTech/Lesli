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

Made with ♥ by LesliTech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/


// · import vue tools
import { ref, reactive, onMounted, watch, computed, inject } from "vue"


// · import stores
import { useLayout } from "Lesli/vue/shared/stores/layout"
import { useNotifications } from "Lesli/vue/panels/stores/bell-notifications"



// · implement stores
const storeLayout = useLayout()
const storeNotifications = useNotifications()


// · initialize/inject plugins
const url = inject("url")
const date = inject("date")

function onEscape(callback, activate) {

    function onEscaping(event) {
        if (event.keyCode === 27) {
            callback()
            console.log("escaping")
            document.removeEventListener('keydown', onEscaping)
        }
    }

    if (activate === true) {
        console.log("activate")
        document.addEventListener('keydown', onEscaping)
    }
    
    if (activate === false) {
        console.log("deactivate")
        document.removeEventListener('keydown', onEscaping)
    }
}

// · 
watch(() => storeLayout.showBellNotifications, (newVal, oldVal) => {

    // request notifications only if showing the panel
    if (newVal) { storeNotifications.get() };

    // activate/deactivate escape listener
    onEscape(() => storeLayout.toggleBellNotifications(), newVal)
})

</script>
<template>
    <lesli-panel class="lesli-panel-bell-notifications" v-model:open="storeLayout.showBellNotifications">
        <template #header>
            Notifications ({{ storeNotifications.notifications.pagination.total }})
        </template>
        <template #default>
            <div class="block">
                <ul class="">
                    <li class="lesli-notification pt-3 pb-2 px-4"
                        v-for="notification in storeNotifications.notifications.records">
                        <a  :href="notification.url"
                            :class="['mb-2 is-block', `notification-${ notification.category }`]">
                            <h4 :class="['notification-title', `has-text-${ notification.category }-30`]">
                                <span class="icon-text is-flex">
                                    <span class="is-flex-grow-1">{{ notification.subject }}</span>
                                    <span :class="['icon', `has-text-${notification.category}`]">
                                        <span v-if="notification.category == 'warning'" class="material-icons">warning</span>
                                        <span v-if="notification.category == 'success'" class="material-icons">done</span>
                                        <span v-if="notification.category == 'danger'" class="material-icons">dangerous</span>
                                        <span v-if="notification.category == 'info'" class="material-icons">info</span>
                                    </span>
                                </span>
                            </h4>
                            <p class="notification-body">{{ notification.body }}</p>
                        </a>
                        <p class="notification-date is-flex is-justify-content-space-between">
                            <span>{{ date.dateTime(notification.created_at) }}</span>
                            <button class="button is-text p-0" @click="storeUser.putNotification(notification)">
                                Mark as read
                            </button>
                        </p>
                    </li>
                </ul>
            </div>
            <div class="block px-5">
                <!-- 
                <lesli-pagination :pagination="storeNotifications.notifications.pagination" @paginate="paginate" mode="simple"></lesli-pagination>
                -->
            </div>
        </template>
    </lesli-panel>
</template>
