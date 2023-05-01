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
