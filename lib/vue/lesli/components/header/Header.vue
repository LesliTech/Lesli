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
import { ref, reactive, onMounted, watch, computed, getCurrentInstance } from "vue"
import { useRouter } from "vue-router"

const router = useRouter()

// · defining props
const props = defineProps({
    title: {
        type: String,
        default: null
    },
    back: {
        type: Object,
        required: false
    }
})

function goBack() {
    router.go(-1)
}

</script>
<template>
    <nav class="navbar lesli-header">
        <div class="navbar-brand">
            <div class="navbar-item">
                <button v-if="false" class="button is-ghost" @click="goBack()">
                    <span class="material-icons">
                        arrow_back
                    </span>
                </button>
                <h1 class="title is-4" v-if="title">{{ title }}</h1>
            </div>
        </div>
        <div class="navbar-menu">
            <div class="navbar-end">
                <div class="navbar-item">
                    <div class="actions">
                        <slot></slot>
                    </div>
                </div>
            </div>
        </div>
    </nav>
</template>
