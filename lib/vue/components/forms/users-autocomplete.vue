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
        user_id:{
            default: null
        },
        users: {
            type: Array,
            required: true
        },
        required: {
            default: false
        },
        field: {
            default: 'name'
        },
        disabled: {
            type: Boolean,
            default: false
        },
        title: {
            type: String,
            default: null
        },
        focus: {
            type: Boolean,
            default: true
        },
        placeholder: {
            type: String,
            default: ''
        },
        viewType: {
            default: null
        },
        id: {
            default: null
        },
        name: {
            default: null
        }
    },

    data(){
        return {
            users_filtered: [],
            user_input: "",
            ready: false,
            timer: null,
            translations: {
                core: I18n.t('core.shared')
            }
        }
    },

    beforeDestroy(){
        this.deleteSubscriptions()
    },

    mounted(){
        this.initData()
        this.bus.subscribe('update:/users/autocomplete', (user_id) => {
            let user = this.users_filtered.find(e => e.id === user_id)
            if (user) {
                this.user_input = user.text
                this.select(user)
            }
        })
    },

    methods: {
        deleteSubscriptions(){
            this.bus.$off('update:/users/autocomplete')
        },

        setInitialValue(){
            if (this.user_id){
                let user = this.users_filtered.find(e => 
                    e.id === this.user_id
                )

                if(user){
                    this.user_input = user.text
                    this.select(user)
                }
            }
        },

        initData(){
            this.users_filtered = this.users.map(user => {
                let text = user[this.field]
                if (text.includes("@") && this.field !== 'email') {
                    text = user.email.split("@")[0]
                }

                return {
                    id: user.id,
                    name: user.name, 
                    email: user.email,
                    role: user.role,
                    text: text
                }
            })
            
            this.setInitialValue()
            this.ready = true
        },

        select(user) {
            this.$emit("select", user)
            this.$nextTick(()=>{
                if(! this.disabled){
                    try{
                        this.$refs.autocomplete.checkHtml5Validity()
                    }catch(error){ }
                }
            })
        },

        search() {
            clearTimeout(this.timer)
            this.timer = setTimeout(() => {
                if(this.filterUser.length == 1) {
                    this.select(this.filterUser[0])
                } else if(this.user_input != ''){
                    this.user_input = ''
                    this.alert(this.translations.core.messages_warning_user_not_found, 'warning')
                }
            }, 5000)
        },

        selectUser(user){
            if(user){
                this.select(user)
            }
        }
    },

    computed: {
        filterUser(input) {
            return this.users_filtered.filter((user) => {
                return user.text
                    .toString()
                    .toLowerCase()
                    .indexOf(this.user_input.toLowerCase()) >= 0
            })
        }
    },

    watch: {
        user_id(){
            this.setInitialValue()
        }
    }
}
</script>

<template>
    <b-field v-if="ready">
        <template v-slot:label>
            <span v-if="title">
                {{ title }}
            </span>
            <span v-else>
                {{translations.core.view_placeholder_select_employee}}
            </span>
            <sup class="has-text-danger" v-if="required">*</sup>
        </template>
        <div class="control">
            <b-autocomplete
                v-if="! disabled"
                ref="autocomplete"
                v-model="user_input"
                :data="filterUser"
                field="text"
                :required="required"
                @select="selectUser"
                @input="search()"
                :open-on-focus="focus"
                :placeholder="placeholder"
                clearable
                :id="id"
                :name="name"
            >
            </b-autocomplete>
            <input v-else type="text" autocomplete="off" class="input" readonly :value="user_input">
            <slot></slot>
        </div>
    </b-field>
</template>
