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

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

*/



// · import vue tools
import { ref, reactive, onMounted, watch, computed, inject } from "vue"


// · import stores
import { useProfile } from "Lesli/shared/stores/profile"
import { useLayout } from "Lesli/shared/stores/layout"


// · implement stores
const storeLayout = useLayout()
const storeProfile = useProfile()


// · initializing
onMounted(() => {
    storeProfile.fetch()
})
</script>
<template>
    <lesli-panel class="lesli-panel-profile" v-model:open="storeLayout.showProfile">
        <template #default>
            <figure class="image is-128x128 m-auto">
                <span class="alternative-avatar">
                        {{ storeProfile.profile.initials }}
                </span>
            </figure>
            <div class="panel-profile-details has-text-centered py-4">
                <h4 class="is-size-4">{{ storeProfile.profile.full_name }}</h4>
                <h6 class="is-size-6">{{ storeProfile.profile.email }}</h6>
            </div>
            <div class="panel-profile-actions py-4">
                <div class="buttons is-justify-content-center">
                    <lesli-button icon-only icon="logout">
                    </lesli-button>
                </div>
            </div>
        </template>
    </lesli-panel>
</template>
