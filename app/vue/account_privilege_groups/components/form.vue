<script>
/*
Copyright (c) 2021, all rights reserved.

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
        privilege_group: {
            required: true
        }
    },

    data() {
        return {
            translations: {
                core: I18n.t('core.shared'),
                main: I18n.t('core.account/privilege_groups')
            },
            submitting_form: false
        }
    },

    mounted() {},

    methods: {
        submitForm(event){
            if (event) { event.preventDefault() }

            if(this.privilege_group.id){
                this.putPrivilegeGroup()
            }else{
                this.postPrivilegeGroup()
            }
        },

        postPrivilegeGroup() {
            this.submitting_form = true

            let url = this.url.admin(`account/privilege_groups`)

            this.http.post(url, { account_privilege_group: this.privilege_group }).then(result => {
                this.submitting_form = false

                if (!result.successful) {
                    this.msg.error(result.error.message)
                    return
                }

                this.msg.success(this.translations.main.messages_success_created)

                this.$router.push(`${result.data.id}`)
            }).catch(error => {
                console.log(error)
            })
        },

        putPrivilegeGroup() {
            this.submitting_form = true

            let url = this.url.admin('account/privilege_groups/:id', { id: this.privilege_group.id})
            this.http.put(url, { account_privilege_group: this.privilege_group }).then(result => {
                this.submitting_form = false

                if (!result.successful) {
                    this.msg.error(result.error.message)
                    return
                }

                this.msg.success(this.translations.main.messages_success_updated)
            }).catch(error => {
                console.log(error)
            })
        }
    }
}

</script>
<template>
    <div class="card">
        <div class="card-content">
            <form @submit.prevent="submitForm">
                <fieldset :disabled="submitting_form">
                    <b-field>
                        <template v-slot:label> 
                            {{ translations.core.view_text_name }} 
                            <sup class="has-text-danger">*</sup> 
                        </template>
                        <b-input type="text" placeholder="" v-model="privilege_group.name" required></b-input>
                    </b-field>

                    <b-field :label="translations.main.column_description">
                        <b-input v-model="privilege_group.description" type="textarea"></b-input>
                    </b-field>

                    <div class="field is-grouped">
                        <div class="control">
                            <button class="button is-primary">
                                <span v-if="submitting_form">
                                    <b-icon icon="circle-notch" custom-cla           ss="fa-spin" size="is-small" />
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
        </div>
    </div>
</template>