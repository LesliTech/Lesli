<script>
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
        emptyMessage() {
            this.$buefy.dialog.alert({
                title: this.translations.bell.dialog_confirm_empty_message,
                message: this.translations.bell.dialog_confirm_empty_question,
                confirmText: this.translations.bell.dialog_confirm_empty_confirm_text,
                type: 'is-danger',
                hasIcon: true
            })
        },

        formSubmit() {
            if (!this.richText.html) {
                this.emptyMessage();
            } else {
                if (this.announcement.id) {
                    this.putAnnouncement()
                } else {
                    this.postAnnouncement()
                }
            }
        },

        postAnnouncement() {           
            this.http.post(this.url.bell("announcements"), {
                announcement: { 
                    ...this.announcement,
                    message: JSON.stringify(this.richText),
                    base_path: this.$router.currentRoute.path
                }
            }).then(result => {
                if (!result.successful) {
                    this.msg.error(result.error.message)
                    return
                }
                
                this.msg.success(this.translations.bell.announcements.messages_success_announcement_created_successfully) 
                
                this.clearForm()
            })
            
            this.getAnnouncements()
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
                base_path: this.$router.currentRoute.path
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
        'data.global.show_panel_announcement'(value){
            if(value && !this.options){
                this.getAnnouncementOptions()
                this.getAnnouncements()
            }
        },
        
        '$route'(){
            this.clearForm()
            this.announcements = []
            this.getAnnouncements()
        }
    }
}
</script>
<template>
    <b-sidebar
        class="application-panel-announcement"
        :open.sync="data.global.show_panel_announcement"
        :right="true"
        :fullheight="true">
        <div class="panel-title is-size-5">
            <h4>
                {{ translations.bell.announcements.view_title_creating_announcement }}
            </h4>
            <span class="icon is-large hover" @click="data.global.show_panel_announcement = false">
                <i class="fas fa-lg fa-chevron-right"></i>
            </span>
        </div>

        <div class="panel-content">
            <form @submit.prevent="formSubmit()">
                
                <fieldset :disabled="submitting">

                    <b-field
                        :message="translations.bell.announcements.view_text_name_not_shown"
                    >
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
                                        <b-icon icon="brush" size="is-small">
                                        </b-icon>
                                    </span>
                                </b-button>
                            </div>
                        </div>
                    </b-field>
                                                  
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

                    <div class="field text-editor-container">
                        <label class="label">
                            {{translations.bell.announcements.column_message}}
                            <sup class="has-text-danger">*</sup>
                        </label>
                        <div class="control">
                            <component-rich-text-editor :value="message" @input="richTextInput" @html="richTextHtml" type="tiny">
                            </component-rich-text-editor>
                        </div>
                    </div>

                    <div class="buttons">
                        <b-button class="submit-button" type="is-primary" native-type="submit"  :disabled="submitting">
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
                :data="announcements">
                <template slot-scope="props">
                    <b-table-column :label="translations.bell.announcements.column_name" sortable field="name" class="is-clickable">
                        <small>{{ props.row.name }}</small>
                    </b-table-column>
                    
                    <b-table-column :label="translations.bell.announcements.column_category" sortable field="category" class="is-clickable">
                        
                        <small>{{ object_utils.translateEnum(translations.bell.announcements, 'column_enum_category', props.row.category) }}</small>
                    </b-table-column>
                
                    <b-table-column :label="translations.bell.announcements.column_users_id" sortable field="user_creator" class="is-clickable">
                        <small>{{ props.row.user_creator }}</small>
                    </b-table-column>
                    
                    <b-table-column :label="''" sortable field="actions">
                        <div class="has-text-right">
                            <b-button size="is-small" type="is-danger" outlined @click.stop="deleteAnnouncement(props.row.id)">
                                <b-icon icon="trash-alt" size="is-small" />
                            </b-button>
                        </div>
                    </b-table-column>
                </template>
            </b-table>
        </div>
    </b-sidebar>
</template>

<style scoped>
.text-editor-container {
    max-height: 13rem;
    overflow-y: auto;
    overflow-x: hidden;
    scrollbar-width: thin;
    scrollbar-color: #cccccc #ffffff;
}

</style>
