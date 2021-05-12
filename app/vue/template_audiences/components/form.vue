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


// ·
export default {
    props: {
        base_path: {
            required: true
        }
    },

    data() {
        return {
            audience: {},
            translations: {
                core: I18n.t('core.shared'),
                main: I18n.t('core.template/audiences')
            },
            submitting_form: false
        }
    },
    methods: {
        submitForm(event){
            if (event) { event.preventDefault() }

            if(this.audience.id){
                this.putTemplateAudience()
            }else{
                this.postTemplateAudience()
            }
        },

        postTemplateAudience() {
            this.submitting_form = true

            let url = this.url.mailer(`audiences`)

            this.http.post(url, { audience: this.audience }).then(result => {

                if (!result.successful) {
                    this.msg.error(result.error.message)
                    return
                }

                this.submitting_form = false

                this.msg.success(this.translations.main.messages_success_created)


                if (base_path) {
                    this.url.go(`${this.base_path}/${result.data.id}`)
                }
            }).catch(error => {
                console.log(error)
            })
        },

        putTemplateAudience() {
            this.submitting_form = true

            let url = this.url.mailer('audiences/:audience_id', { audience_id: this.audienceId})
            this.http.put(url, { audience: this.audience }).then(result => {

                if (!result.successful) {
                    this.msg.error(result.error.message)
                    return
                }

                this.submitting_form = false

                this.msg.success(this.translations.main.messages_success_updated)
            }).catch(error => {
                console.log(error)
            })
        }
    }
}

</script>
<template>
    <form @submit.prevent="postTemplateAudience()">
        <fieldset :disabled="submitting_form">
            <div class="field">
                <label class="label"> {{ translations.main.column_name }} </label>
                <div class="control">
                    <input class="input" type="text" placeholder="" v-model="audience.name">
                </div>
            </div>

            <b-field :label="translations.main.column_description">
                <b-input type="textarea" placeholder="" v-model="audience.description"></b-input>
            </b-field>

            <div class="field is-grouped">
                <div class="control">
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
                </div>
            </div>
        </fieldset>
    </form>
</template>
