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
    data() {
        return {
            user: { },
            options:{ },
            locale: I18n.locale,
            translations: {
                shared: I18n.t('core.shared'),
                user: {
                    settings: I18n.t('core.user/settings')
                }
            },

            settings: {
                locale: null
            }
        }
    },
    mounted(){
        this.getSettings()
    },

    methods: {
        getSettings(){
            console.log('getting settings')
        },

        postSettingsPreferredLanguage(event) {
            this.http.post(this.url.admin('users/:id/settings', this.user.id), {
                user_setting: {
                    name: 'locale', 
                    value_string: event.target.value
                }
            }).then(result => {
                console.log(result)
            }).catch(error => {
                console.log(error)
            })
        }
    },
    watch: {
        "data.user": function(user) {
            this.user = user
        },
        "data.options": function(options) {
            this.options = options
        }
    }
}
</script>

<template>
    <div class="box">
        <div class="field">
            <label class="label">{{translations.user.settings.view_title_preferred_language}}</label>
            <div class="control">
                <div class="select">
                    <select v-on:change="postSettingsPreferredLanguage($event)" v-model="settings.locale">
                        <option v-for="(name, code) in options.locales" :value="code" :key="code">
                            {{ name }}
                        </option>
                    </select>
                </div>
            </div>
        </div>
    </div>
</template>
