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
import { ref, reactive, onMounted, watch, computed, inject } from "vue"


// · import stores
import { useUser } from "LesliApp/administration/stores/user"
import { useLayout } from "Lesli/shared/stores/layout"


// · implement stores
const storeUser = useUser()
const storeLayout = useLayout()


// · initialize/inject plugins
const url = inject("url")
const date = inject("date")


// · emit the page selected received from the pagination component
function paginate(page) {
    storeUser.paginateNotifications(page)
}


// · 
watch(() => storeLayout.showNotifications, () => {
    storeUser.fetchNotifications()
})

</script>
<template>
    <lesli-panel class="lesli-panel-notifications" v-model:open="storeLayout.showNotifications">
        <template #header>
            Notifications ({{ storeUser.notifications.pagination.total }})
        </template>
        <template #default>
            <div class="block">
                <ul class="">
                    <li class="lesli-notification pt-3 pb-2 px-4"
                        v-for="notification in storeUser.notifications.records">
                        <a  :href="notification.url"
                            :class="['mb-2 is-block', `notification-${ notification.category }`]">
                            <h4 :class="['notification-title', `has-text-${ notification.category }-dark`]">
                                <span class="icon-text is-flex">
                                    <span class="is-flex-grow-1">{{ notification.subject }}</span>
                                    <span class="icon">
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
                <lesli-pagination :pagination="storeUser.notifications.pagination" @paginate="paginate" mode="simple"></lesli-pagination>
            </div>
        </template>
    </lesli-panel>
</template>
