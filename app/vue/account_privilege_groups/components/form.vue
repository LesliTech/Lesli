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
            submitting_form: false,
            privilege_groups: []
        }
    },

    mounted() {
        this.getPrivilegeGroups()
    },

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
        },
        
        getPrivilegeGroups(){
            let url = this.url.admin('account/privilege_groups/list')
            this.http.get(url).then(result => {
                if (!result.successful) {
                    this.msg.error(result.error.message)
                    return
                }
                
                this.privilege_groups = result.data.filter((e) => {
                    return (
                        e.account_privilege_groups_id === null &&
                        e.account_privilege_groups_id !== this.privilege_group.id &&
                        e.id !== this.privilege_group.id
                    )
                })
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
                <b-input type="text" placeholder="" v-model="privilege_group.name" required></b-input>
            </b-field>

            <b-field :label="translations.main.column_account_privilege_groups_id" v-if="privilege_groups.length > 0">
                <b-select v-model="privilege_group.account_privilege_groups_id" expanded>
                    <option
                        v-for="privilege_group in privilege_groups"
                        :value="privilege_group.id"
                        :key="privilege_group.id">
                        {{ privilege_group.name }}
                    </option>
                </b-select>
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
</template>