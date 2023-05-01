<script setup>
/*
Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Ruby on Rails Development Platform.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/


// · import vue tools
import { ref, reactive, onMounted, watch, computed } from "vue"


// · import lesli stores
import { useUser } from "LesliApp/administration/stores/user"


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
