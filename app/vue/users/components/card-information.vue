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
    data(){
        return {
            translations: {
                users: I18n.t("core.users"),
                shared: I18n.t("core.shared")
            },
            user: {
                detail_attributes: {}
            }
        }
    },
    methods: {
        initials() {
            let initials = ""
            if (this.user.detail_attributes.first_name) {
                initials += this.user.detail_attributes.first_name[0]
            }
            if (this.user.detail_attributes.last_name) {
                initials += this.user.detail_attributes.last_name[0]
            }
            return initials
        }
    },
    watch: {
        "store.data.user": function(user) {
            this.user = user
        }
    }
}
</script>
<template>
    <div class="box profile-card-information">
        <div class="media" v-if="user">
            <div class="media-left">
                <figure class="image is-128x128">
                    <span class="alternative-avatar">
                        {{ initials() }}
                    </span>
                </figure>
            </div>
            <div class="media-content">
                <div class="content mb-0">
                    <p>
                        <strong if="user.detail_attributes.salutation">
                            {{ object_utils.translateEnum(translations.shared, 'column_enum_salutation', user.detail_attributes.salutation ) }}
                        </strong>
                        <strong>{{ user.detail_attributes.first_name }}</strong>
                        <strong>{{ user.detail_attributes.last_name }}</strong>
                        <br>
                        {{ user.detail_attributes.title }}
                    </p>
                </div>
                
                <nav class="level is-mobile">
                    <div class="level-left">
                        <a  v-if="user.email"
                            :href="'mailto:'+user.email" class="level-item" aria-label="reply">
                            <span class="icon is-small mr-2">
                                <i class="fas fa-envelope" aria-hidden="true"></i>
                            </span>
                            {{ user.email }}
                        </a>
                        <a  v-if="user.detail_attributes.telephone"
                            :href="'tel:'+user.detail_attributes.telephone" class="level-item" aria-label="retweet">
                            <span class="icon is-small mr-2">
                                <i class="fas fa-phone-alt" aria-hidden="true"></i>
                            </span>
                            {{ user.detail_attributes.telephone }}
                        </a>
                    </div>
                </nav>
            </div>
        </div>
    </div>
</template>
