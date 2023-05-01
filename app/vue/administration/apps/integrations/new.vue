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
import { useRouter, useRoute } from 'vue-router'


// · import lesli stores
import { useIntegration } from "../../stores/integration"


// · initialize/inject plugins
const router = useRouter()
const msg = inject("msg")
const url = inject("url")


// · 
const storeIntegration = useIntegration()


// · 
onMounted(() => {

})

</script>
<template>
    <section class="application-component">
        <lesli-header title="New integration token">
            <lesli-button icon="list" :to="url.admin('account/integrations')">
                List integrations
            </lesli-button>
        </lesli-header>
        <form class="box" v-on:submit.prevent="storeIntegration.post">
            <div class="field">
                <label class="label">Name</label>
                <div class="control">
                    <input v-model="storeIntegration.integration.name" class="input" type="text" placeholder="Integration name">
                </div>
            </div>
            <div class="field is-grouped">
                <div class="control">
                    <button type="submit" class="button is-link">Submit</button>
                </div>
            </div>
        </form>
        <div v-if="storeIntegration.token != ''" class="notification is-info">
            <h4>Your integration token</h4>
            <p class="my-4">{{ storeIntegration.token }}</p>
            <p><b>Important: </b>You will not be able to see this token again, please copy and store it in a safe place.</p>
        </div>
    </section>
</template>
