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

export default {
    props: {
        role_descriptor: {
            required: true
        }
    },

    data() {
        return {
            translations: {
                core: I18n.t('core.shared'),
                role_descriptors: I18n.t('core.role_descriptors')
            },
            submitting_form: false,
            role_descriptors: []
        }
    },

    mounted() {
        this.getPrivilegeGroups()
    },

    methods: {
        submitForm(event){
            if (event) { event.preventDefault() }

            if(this.role_descriptor.id){
                this.putPrivilegeGroup()
            }else{
                this.postPrivilegeGroup()
            }
        },

        postPrivilegeGroup() {
            this.submitting_form = true

            let url = this.url.admin(`role_descriptors`)

            this.http.post(url, { role_descriptor: this.role_descriptor }).then(result => {
                this.submitting_form = false

                if (!result.successful) {
                    this.msg.error(result.error.message)
                    return
                }

                this.msg.success(this.translations.role_descriptors.messages_success_created)

                this.$router.push(`${result.data.id}`)
            }).catch(error => {
                console.log(error)
            })
        },

        putPrivilegeGroup() {
            this.submitting_form = true

            let url = this.url.admin('role_descriptors/:id', { id: this.role_descriptor.id})
            this.http.put(url, { role_descriptor: this.role_descriptor }).then(result => {
                this.submitting_form = false

                if (!result.successful) {
                    this.msg.error(result.error.message)
                    return
                }

                this.msg.success(this.translations.role_descriptors.messages_success_updated)
            }).catch(error => {
                console.log(error)
            })
        },

        getPrivilegeGroups(){
            let url = this.url.admin('role_descriptors/list')
            this.http.get(url).then(result => {
                if (!result.successful) {
                    this.msg.error(result.error.message)
                    return
                }

                this.role_descriptors = result.data.filter((e) =>
                    e.role_descriptors_id === null && e.id !== this.role_descriptor.id
                )
            }).catch(error => {
                console.log(error)
            })
        }
    }
}

</script>
<template>
    <form @submit.prevent="submitForm">
        <fieldset :disabled="submitting_form">
            <b-field>
                <template v-slot:label>
                    {{ translations.core.view_text_name }}
                    <sup class="has-text-danger">*</sup>
                </template>
                <b-input type="text" placeholder="" v-model="role_descriptor.name" required></b-input>
            </b-field>

            <b-field :label="translations.role_descriptors.view_text_assign_parent_descriptor" v-if="role_descriptors.length > 0">
                <b-select v-model="role_descriptor.role_descriptors_id" expanded>
                    <option :value="null"> {{ translations.core.view_text_none }} </option>
                    <option
                        v-for="role_descriptor in role_descriptors"
                        :value="role_descriptor.id"
                        :key="role_descriptor.id">
                        {{ role_descriptor.name }}
                    </option>
                </b-select>
            </b-field>

            <b-field :label="translations.role_descriptors.column_description">
                <b-input v-model="role_descriptor.description" type="textarea"></b-input>
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