<script>
/*
Copyright (c) 2020, all rights reserved.

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
import componentRichTextEditor from '../components/forms/richtext-editor.vue'
import DatePicker from 'v-calendar/lib/components/date-picker.umd'
// ·

// ·
export default {
    components: {
        'vc-date-picker': DatePicker,
        'component-rich-text-editor': componentRichTextEditor
    },

    data() {
        return {
            translations: {
                core: {
                    shared: I18n.t("core.shared"),
                },
                bell: {
                    announcements: I18n.t("bell.announcements"),
                }
            },
            loaded: false,
            announcement: {
                can_be_closed: true,
                category:  'normal',
                status: true
            },
            submitting: false,
            options: null,
            announcements: [],
            richText: {
                delta: null,
                html: null
            },
            loading: false,
            message: {}
        }
    },
    
    methods: {        
        formSubmit() {
            if (this.announcement.id) {
                this.putAnnouncement()
            } else {
                this.postAnnouncement()
            }
        },

        postAnnouncement() {           
            this.http.post(this.url.bell("announcements"), {
                announcement: { 
                    ...this.announcement,
                    message: JSON.stringify(this.richText),
                    base_path: this.lesli.url.path
                }
            }).then(result => {
                if (!result.successful) {
                    this.msg.error(result.error.message)
                    return
                }
                
                this.msg.success(this.translations.bell.announcements.messages_success_announcement_created_successfully) 
                
                this.clearForm()
            })
        },

        putAnnouncement() {
            this.http.put(this.url.bell("announcements/:id", { id: this.announcement.id }), {
                announcement: { 
                    ...this.announcement,
                    message: JSON.stringify(this.richText)
                }
            }).then(result => {
                if (!result.successful) {
                    this.msg.error(result.error.message)
                    return
                }
                
                this.msg.success(this.translations.bell.announcements.messages_success_announcement_updated_successfully) 
            })
        },
        
        getAnnouncementOptions(){
            let url = this.url.bell('announcements/options')

            this.http.get(url).then(result => {
                if (result.successful) {
                    this.options = result.data
                }
            }).catch(error => {
                console.log(error)
            })
        },
        
        getAnnouncements(){            
            this.loading = true
                        
            let url = this.url.bell('announcements/list').filters({
                base_path: this.lesli.url.path
            })

            this.http.get(url).then(result => {
                this.loading = false 
            
                if (result.successful) {
                    this.announcements = result.data 
                }
            }).catch(error => {
                console.log(error)
            })
        },
        
        richTextHtml(html) {
            this.richText.html = html
        },

        richTextInput(delta) {
            this.richText.delta = delta
        },
        
        clearForm(){
            this.announcement = {
                can_be_closed: true,
                category:  'normal',
                status: true
            }
            
            this.message = {}
        },
        
        showAnnouncement(announcement){
            this.announcements.find(e => e.id === announcement.id) 
            
            this.$refs['announcement-name'].focus()
            
            this.message = announcement.message.delta 
            this.announcement = announcement
        },
        
        deleteAnnouncement(announcement_id){
            let url = this.url.bell('announcements/:id', {id: announcement_id})

            this.http.delete(url).then(result => {
                if (result.successful) {
                    this.announcements = this.announcements.filter(e => e.id !== announcement_id)
                }else{
                    this.msg.error(result.error.message)
                }
                
                this.msg.success(this.translations.bell.announcements.messages_success_announcement_deleted_successfully) 
            }).catch(error => {
                console.log(error)
            })
        }
    },
    
    watch: {
        'data.global.show_announcement_sidebar'(value){
            if(value && !this.options){
                this.getAnnouncementOptions()
                this.getAnnouncements()
            }
        }
    }
}
</script>
<template>
    <b-sidebar
        :open.sync="data.global.show_announcement_sidebar"
        class="application-panel-announcement"
        right
        :can-cancel="['escape']"
        fullheigsht
        overlay
    >
        <div class="sidebar-content">
            <form @submit.prevent="formSubmit()">
                <h5 class="title is-5">
                    <div class="columns">
                        <div class="column is-10">
                            {{ translations.bell.announcements.view_title_creating_announcement }}
                        </div>
                        <div class="column is-2">
                            <button type="button" class="is-pulled-right delete" @click="() => data.global.show_announcement_sidebar = false">
                            </button>
                        </div>
                    </div>
                </h5>
                
                <fieldset :disabled="submitting">

                    <b-field>
                        <template v-slot:label>
                            {{translations.bell.announcements.column_name}} <sup class="has-text-danger">*</sup>
                        </template>
                        <b-input name="name" ref="announcement-name" type="text" required v-model="announcement.name">
                        </b-input>
                    </b-field>

                    <b-field 
                        :label="translations.bell.announcements.column_start_at"
                    >
                        <vc-date-picker
                            v-model="announcement.start_at"
                            :locale="date.vcDatepickerConfig()"
                            :popover="{ visibility: 'focus' }"
                            :min-date="announcement.id ? null : new Date()"
                        >
                            <template v-slot="{ inputValue, inputEvents }">
                                <input
                                    class="input is-default"
                                    v-on="inputEvents"
                                    :value="inputValue"
                                    :placeholder="translations.core.shared.text_select_date"
                                />
                            </template>
                        </vc-date-picker>
                    </b-field>
                    
                    <b-field 
                        :label="translations.bell.announcements.column_end_at"
                        :message="translations.bell.announcements.view_text_expiration_date_indefinite"
                    >
                        <vc-date-picker
                            v-model="announcement.end_at"
                            :locale="date.vcDatepickerConfig()"
                            :popover="{ visibility: 'focus' }"
                            :min-date="announcement.id ? null : new Date()"
                        >
                            <template v-slot="{ inputValue, inputEvents }">
                                <input
                                    class="input is-default"
                                    v-on="inputEvents"
                                    :value="inputValue"
                                    :placeholder="translations.core.shared.text_select_date"
                                />
                            </template>
                        </vc-date-picker>
                    </b-field>
                    
                    <b-field>
                        <template v-slot:label>
                            {{translations.bell.announcements.column_category}}<sup class="has-text-danger">*</sup>
                        </template>
                        <div class="columns">
                            <div class="column is-10">
                                <b-select
                                    v-if="options"
                                    :placeholder="translations.core.view_placeholder_select_option"
                                    expanded
                                    required
                                    v-model="announcement.category"
                                >
                                    <option
                                        v-for="category in options.categories"
                                        :key="category.value"
                                        :value="category.value"
                                    >
                                        {{ object_utils.translateEnum(translations.bell.announcements, 'column_enum_category', category.text)}}
                                    </option>
                                </b-select>
                            </div>
                            <div class="column">
                                <b-button :type="`is-${announcement.category}`">
                                    <span>
                                        <b-icon icon="fa-brush" size="is-small">
                                        </b-icon>
                                    </span>
                                </b-button>
                            </div>
                        </div>
                    </b-field>
                            
                    <div class="columns">
                        <div class="column is-5">                            
                            <div class="field">
                                <label class="label">{{ translations.bell.announcements.column_can_be_closed }}</label>
                                <div class="block">
                                    <b-radio
                                        id="can_be_closed_true"
                                        v-model="announcement.can_be_closed"
                                        type="is-info"
                                        :native-value="true"
                                    >
                                    {{ translations.core.shared.view_text_yes }}
                                    </b-radio> 
                                    <b-radio
                                        id="can_be_closed_false"
                                        v-model="announcement.can_be_closed"
                                        type="is-info"
                                        :native-value="false"
                                    >
                                    {{ translations.core.shared.view_text_no }}
                                    </b-radio> 
                                </div>
                            </div>
                        </div>
                        <div class="column">
                            <b-field>
                                <template v-slot:label>
                                    {{ translations.bell.announcements.column_status }}<sup class="has-text-danger">*</sup>
                                </template>
                                <b-checkbox v-model="announcement.status">
                                    {{ announcement.status ? translations.core.shared.view_text_yes : translations.core.shared.view_text_no }}
                                </b-checkbox>
                            </b-field>
                        </div>
                    </div>

                    <div class="field text-editor-container">
                        <label class="label">{{translations.bell.announcements.column_description}}</label>
                        <div class="control">
                            <component-rich-text-editor :value="message" @input="richTextInput" @html="richTextHtml" type="simple">
                            </component-rich-text-editor>
                        </div>
                    </div>

                    <div class="buttons">
                        <b-button class="submit-button" type="is-primary" native-type="submit" :disabled="submitting">
                            <span v-if="submitting">
                                <b-icon icon="circle-notch" custom-class="fa-spin" size="is-small">
                                </b-icon>
                                <span>{{translations.core.shared.view_btn_saving}}</span>
                            </span>
                            <span v-else>
                                <b-icon icon="save" size="is-small">
                                </b-icon>
                                <span>{{translations.core.shared.view_btn_save}}</span>
                            </span>
                        </b-button>
                        <span class="button is-default" @click.stop="clearForm()">
                            <span>
                                <b-icon icon="eraser" size="is-small" />
                                &nbsp; &nbsp;
                                {{ translations.core.shared.view_btn_clear }}
                            </span>
                        </span>
                    </div>
                </fieldset>
            </form>
            <hr>
            
            <b-table 
                v-if="!loading && announcements.length > 0"
                @click="showAnnouncement" 
                :data="announcements"

            >
                <template slot-scope="props">
                    <b-table-column :label="translations.bell.announcements.column_name" sortable field="name">
                        {{ props.row.name }}
                    </b-table-column>
                    
                    <b-table-column :label="translations.bell.announcements.column_category" sortable field="category">
                        {{ props.row.category }}
                    </b-table-column>
                
                    <b-table-column :label="translations.bell.announcements.column_users_id" sortable field="user_creator">
                        {{ props.row.user_creator }}
                    </b-table-column>
                    
                    <b-table-column :label="translations.core.shared.view_text_actions" sortable field="actions">
                        <span>
                            <b-button type="is-danger" outlined @click.stop="deleteAnnouncement(props.row.id)">
                                <b-icon icon="trash-alt" size="is-small" />
                            </b-button>
                        </span>
                    </b-table-column>
                </template>
            </b-table>
        </div>
    </b-sidebar>
</template>

<style scoped>
.text-editor-container {
    max-height: 10rem;
    overflow-y: auto;
    overflow-x: hidden;
    scrollbar-width: thin;
    scrollbar-color: #cccccc #ffffff;
}

</style>