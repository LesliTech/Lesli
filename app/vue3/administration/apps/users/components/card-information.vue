<script setup>
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


// · import vue tools
import { ref, reactive, onMounted, watch, computed } from "vue"


// · import lesli stores
import { useUser } from "LesliVue/stores/user"


// · implement stores
const storeUser = useUser()


// · translations
const translations = {
    core: {
        users: I18n.t("core.users"),
        shared: I18n.t("core.shared"),
    }
}

</script>
<template>
    <div class="information mb-5">
        <div class="media is-align-items-center">
            <div class="media-left">
                <figure class="image is-128x128">
                    <span class="alternative-avatar">
                         {{ storeUser.initials }}
                    </span>
                </figure>
            </div>

            <div class="media-content">
                <div class="content mb-0">
                    <p>
                        <!-- 
                        <strong>
                            object_utils.translateEnum(translations.core.shared, 'column_enum_salutation', user.detail_attributes.salutation )
                            {{ storeUser.user.detail_attributes.salutation }}
                        </strong>
                        -->
                        <h5 class="title is-5 mb-0">
                            {{ storeUser.user.detail_attributes.first_name }}
                            {{ storeUser.user.detail_attributes.last_name }}
                        </h5>
                        <p>{{ storeUser.user.detail_attributes.title }}</p>
                    </p>
                </div>

                <nav class="level is-mobile mb-0">
                    <div class="level-left">
                        <a  v-if="storeUser.user.email"
                            :href="'mailto:'+storeUser.user.email" class="level-item" aria-label="reply">
                            <span class="icon is-small mr-2">
                                <span class="material-icons">
                                    email
                                </span>
                            </span>
                            {{ storeUser.user.email }}
                        </a>
                        <a  v-if="storeUser.user.detail_attributes.telephone"
                            :href="'tel:'+storeUser.user.detail_attributes.telephone" class="level-item" aria-label="retweet">
                            <span class="icon is-small mr-2">
                                <span class="material-icons">
                                    phone
                                </span>
                            </span>
                            {{ storeUser.user.detail_attributes.telephone }}
                        </a>
                    </div>
                </nav>
            </div>
        </div>
    </div>
</template>
