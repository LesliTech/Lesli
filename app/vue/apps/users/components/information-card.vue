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
    <div class="information-card mb-5">
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
                            {{ storeUser.user.first_name }}
                            {{ storeUser.user.last_name }}
                        </h5>
                        <p>{{ storeUser.user.detail_attributes.title }}</p>
                    </p>
                </div>

                <div class="level is-mobile">
                    <div class="level-left">
                        <a  class="level-item mr-4"
                            v-if="storeUser.user.email"  
                            :href="'mailto:'+storeUser.user.email">
                            <span class="icon is-small mr-2">
                                <span class="material-icons">
                                    email
                                </span>
                            </span>
                            {{ storeUser.user.email }}
                        </a>
                        <a  class="level-item mr-4"
                            v-if="storeUser.user.telephone"
                            :href="'tel:'+storeUser.user.telephone">
                            <span class="icon is-small mr-2">
                                <span class="material-icons">
                                    phone
                                </span>
                            </span>
                            {{ storeUser.user.telephone }}
                        </a>

                        <!-- Show the max role -->
                        <p class="level-item">
                            <span class="icon is-small mr-2">
                                <span class="material-icons">
                                    security
                                </span>
                            </span>
                            {{ storeUser.role_names }}
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
