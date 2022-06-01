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
    <div class="box information">
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
                        <strong>
                            <!-- salutation -->
                        </strong>
                        <strong>{{ storeUser.user.detail_attributes.first_name }}</strong>
                        <strong>{{' '}}</strong>
                        <strong>{{ storeUser.user.detail_attributes.last_name }}</strong>
                        <br>
                        {{ storeUser.user.detail_attributes.title }}
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

        <nav class="level" v-if="false">
            <div class="level-left">
                <div class="level-item">
                    <button class="button is-small" @click="doRequestPasswordChange()">
                        <span class="icon">
                            <span class="material-icons">
                                key
                            </span>
                        </span>
                        <span> {{ translations.core.users.view_btn_request_password_change }}</span>
                    </button>
                </div>
                <div class="level-item">
                    <button class="button" @click="doUserLogout()">
                        <span class="icon">
                            <span class="material-icons">
                                logout
                            </span>
                        </span>
                        <span>  {{ translations.core.users.view_btn_force_logout }}</span>
                    </button>
                </div>
                <div class="level-item">
                    <button class="button is-white" @click="doRevokeAccess()">
                        <span class="icon">
                            <span class="material-icons">
                                lock_outline
                            </span>
                        </span>
                        <span> {{ translations.core.users.view_btn_revoke_access }} </span>
                    </button>
                </div>
                <div class="level-item">
                    <button class="button is-white" @click="confirmMarkUserAsDeleted()">
                        <span class="icon"><i class="fas fa-user-slash"></i></span>
                        <span> {{ translations.core.users.view_btn_mark_user_as_deleted }} </span>
                    </button>
                </div>
            </div>

            <div class="level-right">
                <div class="level-item">
                    <div class="dropdown is-hoverable header-language-selector">
                        <div class="dropdown-trigger">
                            <button class="button" aria-haspopup="true" aria-controls="dropdown-menu">
                                <span class="icon has-text-grey-light">
                                    <span class="flag-icon flag-icon-gb"></span>
                                </span>
                            </button>
                        </div>
                        <div class="dropdown-menu" id="dropdown-menu" role="menu">
                            <div class="dropdown-content">
                                <a class="dropdown-item" href="/language?locale=es">
                                    <span class="icon has-text-grey-light">
                                        <span class="flag-icon flag-icon-es"></span>
                                    </span>
                                    <span>Español</span>
                                </a>
                                <a class="dropdown-item" href="/language?locale=de">
                                    <span class="icon has-text-grey-light">
                                        <span class="flag-icon flag-icon-de"></span>
                                    </span>
                                    <span>Deutsch</span>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </nav>
    </div>
</template>
