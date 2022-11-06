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
import { inject, watch, onMounted } from "vue"
import { useRouter, useRoute } from 'vue-router'


// · import store
import { useLayout } from "LesliVue/stores/layout"
import { useAnnouncements } from "LesliVue/stores/panels/announcements"


// · initialize/inject plugins
const router = useRouter()
const url = inject("url")


// · implement stores
const storeLayout = useLayout()
const storeAnnouncementsPanel = useAnnouncements()


// · 
import editorRichText from "LesliVue/components/editors/richtext.vue"


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


// · 
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


// · 
const selectOptions = [
    { label: "Info", value: "info"}, 
    { label: "Alert", value: "danger"},
    { label: "Success", value: "success"},
    { label: "Warning", value: "warning"}
]


// · 
const columns = [{
    field: "name",
    label: translations.bell.announcements.column_name
}, {
    field: "category",
    label: translations.bell.announcements.column_category
}, {
    field: "user_creator",
    label: translations.bell.announcements.column_users_id
}]


// · 
watch(() => storeLayout.showAnnouncements, () => {
    if(storeLayout.showAnnouncements){
        storeAnnouncementsPanel.getAnnouncements()
    }    
})
</script>

<template>
    <lesli-panel class="lesli-panel-announcements" v-model:open="storeLayout.showAnnouncements">
        <template #header>
            {{translations.bell.announcements.view_title_creating_announcement}}
        </template>
        <template #default>
            <div class="form">
                <form @submit.prevent="storeAnnouncementsPanel.formSubmit()">
                    <div class="columns">
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
                    
                    <div class="columns">
                        <div class="column is-4">
                            <label class="label">
                                {{translations.bell.announcements.column_message}}
                                <sup class="has-text-danger">*</sup>
                            </label>
                        </div>
                        <div class="column">
                            <div class="control is-clearfix">
                                <editor-rich-text mode="small" v-model="storeAnnouncementsPanel.announcement.message">
                                </editor-rich-text>
                            </div>
                        </div>
                    </div>

                    <div class="columns">
                        <div class="column is-4">
                            <label class="label">{{translations.bell.announcements.column_start_at}}</label>
                        </div>
                        <div class="column">
                            <input class="input is-info" type="date" v-model="storeAnnouncementsPanel.announcement.start_at">
                        </div>
                    </div>

                    <div class="columns">
                        <div class="column is-4">
                            <label class="label">{{translations.bell.announcements.column_end_at}}</label>
                        </div>
                        <div class="column">
                            <input class="input is-info" type="date" v-model="storeAnnouncementsPanel.announcement.end_at">
                        </div>
                    </div>


                    <div class="columns">
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

                    <div class="columns">
                        <div class="column is-7">
                            <label class="label">
                                {{translations.bell.announcements.column_can_be_closed}}
                                <sup class="has-text-danger">*</sup>
                            </label>
                        </div>
                        <div class="column">
                            <label :for="option.label" class="radio" v-for="option in closeOptions" :key="option">
                                <input 
                                    name="user_salutation" 
                                    type="radio" 
                                    :id="option.label" 
                                    :value="option.value" 
                                    v-model="storeAnnouncementsPanel.announcement.can_be_closed"
                                />
                                {{option.label}}
                            </label>  
                        </div>
                    </div>

                    <div class="px-3 ql-bg-blue">
                        <lesli-button icon="save">
                            {{ translations.core.shared.view_btn_save }}
                        </lesli-button>
                    </div>
                    
                </form>
            </div>
            <div class="announcements" v-if="storeAnnouncementsPanel.announcements.length > 0">
                <lesli-table
                    :columns="columns"
                    :records="storeAnnouncementsPanel.announcements"
                    @click="storeAnnouncementsPanel.showAnnouncement"
                    :loading="storeAnnouncementsPanel.loading"
                >

                <template #options="{ record, value }">
                    <a class="dropdown-item" @click="storeAnnouncementsPanel.deleteAnnouncement(record.id)">
                        <span class="material-icons">
                            delete
                        </span>
                        <span>
                            delete
                        </span>
                    </a>
                </template>

                </lesli-table>
            </div>

        </template>
    </lesli-panel>
</template>
