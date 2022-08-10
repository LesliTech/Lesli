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


// · initialize/inject plugins
const url = inject("url")
const date = inject("date")


// · import stores
import { useUser } from "LesliVue/stores/user"
import { useLayout } from "LesliVue/stores/layout"


// · implement stores
const storeUser = useUser()
const storeLayout = useLayout()


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
            <ul class="">
                <li v-for="notification in storeUser.notifications.records">
                    <a class="lesli-notification is-block py-2 px-4" :href="notification.url">
                        <h4 class="notification-title">{{ notification.subject }}</h4>
                        <p class="notification-body">{{ notification.body }}</p>
                        <p class="notification-date is-flex is-justify-content-space-between">
                            <span>{{ date.dateTime(notification.created_at) }}</span>
                            <button class="button is-text">
                                Mark as read
                            </button>
                        </p>
                    </a>
                </li>
            </ul>
        </template>
    </lesli-panel>
</template>
