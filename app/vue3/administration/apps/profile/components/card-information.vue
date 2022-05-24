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
import { useProfile } from "LesliVue/stores/profile"


// · implement stores
const storeProfile = useProfile()


// · implement stores
const translations = {
    core: {
        users: I18n.t("core.users"),
        shared: I18n.t("core.shared"),
    }
}

</script>
<template>
    <div class="box information">
        <div class="media is-align-items-center">
            <div class="media-left">
                <figure class="image is-128x128">
                    <span class="alternative-avatar">
                         {{ storeProfile.initials() }}
                    </span>
                </figure>
            </div>
            <div class="media-content">
                <div class="content mb-0">
                    <p>
                        <strong>
                        
                        </strong>
                        <strong>{{ storeProfile.user.detail_attributes.first_name }}</strong>
                        <strong>{{ storeProfile.user.detail_attributes.last_name }}</strong>
                        <br>
                        {{ storeProfile.user.detail_attributes.title }}
                    </p>
                </div>

                <nav class="level is-mobile mb-0">
                    <div class="level-left">
                        <a  v-if="storeProfile.user.email"
                            :href="'mailto:'+storeProfile.user.email" class="level-item" aria-label="reply">
                            <span class="icon is-small mr-2">
                                <span class="material-icons">
                                    email
                                </span>
                            </span>
                            {{ storeProfile.user.email }}
                        </a>
                        <a  v-if="storeProfile.user.detail_attributes.telephone"
                            :href="'tel:'+storeProfile.user.detail_attributes.telephone" class="level-item" aria-label="retweet">
                            <span class="icon is-small mr-2">
                                <span class="material-icons">
                                    phone
                                </span>
                            </span>
                            {{ storeProfile.user.detail_attributes.telephone }}
                        </a>
                    </div>
                </nav>

                <div class="buttons" v-if="false">
                    <button class="button is-white is-small" @click="doRequestPasswordChange()">
                        <span class="icon"><i class="fas fa-unlock-alt"></i></span>
                        <span> {{ translations.core.users.view_btn_request_password_change }}</span>
                    </button>

                    <button class="button is-white is-small" @click="doUserLogout()">
                        <span class="icon"><i class="fas fa-sign-out-alt"></i></span>
                        <span>  {{ translations.core.users.view_btn_force_logout }}</span>
                    </button>

                    <button class="button is-white is-small" @click="doRevokeAccess()">
                        <span class="icon"><i class="fas fa-user-lock"></i></span>
                        <span> {{ translations.core.users.view_btn_revoke_access }} </span>
                    </button>

                    <button class="button is-white is-small" @click="confirmMarkUserAsDeleted()">
                        <span class="icon"><i class="fas fa-user-slash"></i></span>
                        <span> {{ translations.core.users.view_btn_mark_user_as_deleted }} </span>
                    </button>
                </div>

            </div>
        </div>
    </div>
</template>
