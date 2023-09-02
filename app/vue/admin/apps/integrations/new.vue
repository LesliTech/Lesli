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
