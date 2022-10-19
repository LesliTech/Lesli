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
import { inject, watch } from "vue"
import { useRouter } from 'vue-router'

// · import store
import { useLayout } from "LesliVue/stores/layout"
import { useAnnouncements } from "LesliVue/stores/panels/announcements"

// · initialize/inject plugins
const router = useRouter()
const url = inject("url")


// · implement stores
const storeLayout = useLayout()
const storeAnnouncementsPanel = useAnnouncements()

// · defining translations
const translations = {
    core: {
        shared: I18n.t("core.shared")
    },
    bell: {
        notifications: I18n.t("bell.notifications"),
        announcements: I18n.t("bell.announcements")
    }
}

const closeOptions = {
    yes: { 
        label: "yes", 
        value: true
    },
    no: {
        label: "no",
        value: false
    }
    
}

const selectOptions = [
    { label: "Info", value: "info"}, 
    { label: "Alert", value: "danger"},
    { label: "Primary", value: "primary"},
    { label: "Link", value: "link"},
    { label: "Success", value: "success"},
    { label: "Warning", value: "warning"}
]


// watch(() => storeLayout.showAnnouncements, () => {
//     if(storeLayout.showTickets){
//         storeTicketsPanel.fetchTickets()

//         if(!storeTicketsPanel.loaded){
//             storeTicketsPanel.getTicketOptions()
//         }
//     }    
// })


</script>

<template>
    <lesli-panel class="lesli-panel-tickets" v-model:open="storeLayout.showAnnouncements">
        <template #header>
            Create a new announcement
        </template>
        <template #default>
            <div class="form">
                <h4>{{translations.main.view_title_quick_creation}}</h4>
                <form @submit.prevent="storeAnnouncementsPanel.postAnnouncement()" class="card py-4">
                    <div class="columns is-marginless has-border-bottom">
                        <div class="column is-4">
                            <label class="label">
                                {{ translations.bell.announcements.column_name }}
                                <sup class="has-text-danger">*</sup>
                            </label>
                        </div>
                        <div class="column">
                            <div class="control is-clearfix">
                                <input
                                    type="text"
                                    autocomplete="on"
                                    name="subject"
                                    required
                                    class="input"
                                    v-model="storeAnnouncementsPanel.announcement.name"
                                />
                            </div>
                        </div>
                    </div>

                    <div class="columns is-marginless has-border-bottom">
                        <div class="column is-4">
                            <label class="label">
                                {{translations.bell.announcements.column_message}}
                                <sup class="has-text-danger">*</sup>
                            </label>
                        </div>
                        <div class="column">
                            <div class="control is-clearfix">
                                <input
                                    type="text"
                                    autocomplete="on"
                                    name="subject"
                                    required
                                    class="input"
                                    v-model="storeAnnouncementsPanel.announcement.message"
                                />
                            </div>
                        </div>
                    </div>

                    <div class="columns is-marginless has-border-bottom">
                        <div class="column is-4">
                            <label class="label">{{translations.bell.announcements.column_start_at}}</label>
                        </div>
                        <div class="column">
                            <input class="input is-info" type="date" v-model="storeAnnouncementsPanel.announcement.start_at" @change="updateDates">
                        </div>
                    </div>

                    <div class="columns is-marginless has-border-bottom">
                        <div class="column is-4">
                            <label class="label">{{translations.bell.announcements.column_end_at}}</label>
                        </div>
                        <div class="column">
                            <input class="input is-info" type="date" v-model="storeAnnouncementsPanel.announcement.end_at" @change="updateDates">
                        </div>
                    </div>


                    <div class="columns is-marginless has-border-bottom">
                        <div class="column is-4">
                            <label class="label">
                                {{translations.bell.announcements.column_kind}}
                            </label>
                        </div>
                        <div class="column">
                            <div class="control is-clearfix">
                                <lesli-select
                                    v-model = "storeAnnouncementsPanel.announcement.category"
                                    :options="selectOptions">
                                </lesli-select>
                            </div>
                        </div>
                    </div>

                    <div class="columns is-marginless has-border-bottom">
                        <div class="column is-4">
                            <label class="label">
                                {{translations.bell.announcements.column_can_be_closed}}
                                <sup class="has-text-danger">*</sup>
                            </label>
                        </div>
                        <div class="column">
                            <label :for="option.label" class="radio" v-for="option in closeOptions" :key="option">
                                <input name="user_salutation" type="radio" :id="option.label" :value="option.value" v-model="storeAnnouncementsPanel.announcement.can_be_closed" required/>
                                {{option.label}}
                            </label>  
                        </div>
                    </div>

                    <div class="px-3 ql-bg-blue">
                        <button
                            type="submit"
                            class="button is-fullwidth has-text-centered submit-button is-primary"
                        >
                            {{ translations.core.shared.view_btn_save }}
                        </button>
                    </div>
                </form>
            </div>
        </template>
    </lesli-panel>
</template>
