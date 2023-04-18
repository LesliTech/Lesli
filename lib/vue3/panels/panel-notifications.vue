<script setup>
/*
Copyright (c) 2022, all rights reserved.

All the information provided by this platform is protected by international laws related  to 
industrial property, intellectual property, copyright and relative international laws. 
All intellectual or industrial property rights of the code, texts, trade mark, design, 
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/


// · import vue tools
import { ref, reactive, onMounted, watch, computed, inject } from "vue"


// · import stores
import { useUser } from "LesliVue/stores/user"
import { useLayout } from "LesliVue/stores/layout"


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
