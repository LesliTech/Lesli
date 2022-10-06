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
import { onMounted } from "vue"
import { useRouter, useRoute } from 'vue-router'


// · import lesli stores
import { useUser } from "LesliVue/stores/user"

// · import profile components
import formInformation from "./components/form-information.vue"

// · implement stores
const storeUser = useUser()
const router = useRouter()
const route = useRoute()

// · translations
const translations = {
    core: {
        roles: I18n.t("core.roles"),
        users: I18n.t("core.users"),
        shared: I18n.t("core.shared")
    }

}

// · defining props
const props = defineProps({
    appMountPath: {
        type: String,
        required: false,
        default: "/administration/users",
    }
})

onMounted(() => {
    storeUser.getOptions()
})

</script>

<template>
    <section class="application-component">
        <lesli-header title="Create User">
            <lesli-button icon="list" :to="url.root(props.appMountPath)">
                All users
            </lesli-button>
        </lesli-header>
        <div class="box">
            <formInformation/>
        </div>
    </section>
</template>
