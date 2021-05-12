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

export default {
    props: {
        audienceId: {
            required: true
        }
    },
    data() {
        return {
            audience_contact: {
                name: "",
                email: ""
            },
            translations: {
                core: I18n.t('core.shared'),
                main: I18n.t('mailer.audiences'),
                contacts: I18n.t('mailer.audience/contacts'),
            },
            submitting_form: false
        }
    },
    methods: {
        submitContact(event){
            if (event) { event.preventDefault() }

            if(this.audience_contact.id){
                this.putContact()
            }else{
                this.postContact()
            }
        },

        postContact() {
            let data = {
                audience_contact: {
                    ...this.audience_contact,
                    source: 'manual'
                }
            }

            let url = this.url.mailer(`audiences/${this.audienceId}/contacts`)
            this.http.post(url, data).then(result => {

                if (!result.successful) {
                    this.msg.error(result.error.message)
                    return
                }

                this.data.audiences.getContacts()
                this.msg.success(this.translations.main.messages_success_contact_created)

                this.clearForm()
            }).catch(error => {
                console.log(error)
            })
        },

        putContact() {
            let url = this.url.mailer(`audiences/${this.audienceId}/contacts/${this.audience_contact.id}`)
            this.http.put(url, { audience_contact: this.audience_contact}).then(result => {

                if (!result.successful) {
                    this.msg.error(result.error.message)
                    return
                }

                this.data.audiences.getContacts()
                this.msg.success(this.translations.main.messages_success_contact_updated)

                this.clearForm()
            }).catch(error => {
                console.log(error)
            })
        },

        clearForm(){
            this.audience_contact = {
                name: '',
                email: ''
            }

            this.data.selected_audience_contact = {}
        }
    },

    watch: {
        'data.selected_audience_contact': {
            handler(value){
                if (value) {
                  this.audience_contact = value
                }
            }
        }
    }
}
</script>
<template>
    <div class="card">
        <div class="card-content">
            <form @submit.prevent="submitContact">
                <fieldset :disabled="submitting_form">
                    <div class="field">
                        <label class="label">{{ translations.contacts.column_name }} <sup class="has-text-danger">*</sup></label>
                        <div class="control">
                            <input class="input" type="text" required :placeholder="translations.contacts.view_placeholder_name" v-model="audience_contact.name">
                        </div>
                    </div>

                    <div class="field">
                        <label class="label">{{ translations.contacts.column_email }} <sup class="has-text-danger">*</sup></label>
                        <div class="control">
                            <input class="input" type="email" required :placeholder="translations.contacts.view_placeholder_email" v-model="audience_contact.email">
                        </div>
                    </div>

                    <p class="control">
                        <button class="button is-primary">
                            <span v-if="submitting_form">
                                <b-icon icon="circle-notch" custom-class="fa-spin" size="is-small" />
                                &nbsp;
                                {{translations.core.view_btn_saving}}
                            </span>
                            <span v-else>
                                <b-icon icon="save" size="is-small" />
                                &nbsp;
                                {{translations.core.view_btn_save}}
                            </span>
                        </button>
                    </p>
                </fieldset>
            </form>
        </div>
    </div>
</template>
