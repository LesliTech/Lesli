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
import { ref, computed } from 'vue'

// · defining props
const props = defineProps({
    // · left side of the navbar links
    startLinks: {
        type: Array,
        required: true
    },
    // · right side of the navbar links
    endLinks: {
        type: Array,
        required: false
    },
    // · object with the url image and the alt text
    brand: {
        type: Object,
        required: false
    },
    

})

// · id for the navbar burger menu
const uniqueId = Math.random().toString(36).slice(3, 9)
// · state of the navbar burger menu
const isNavbarMenuOpen = ref(false)


// Toggle the "is-active" class on both the "navbar-burger" and the "navbar-menu"
const onNavbarBurgerClick = () => {
    isNavbarMenuOpen.value = !isNavbarMenuOpen.value
}

// · is active class for navbar menu and navbar burger
const isActive = computed(() => isNavbarMenuOpen.value ? 'is-active' : '')

</script>

<template>
    <nav class="application-navbar navbar" role="navigation" aria-label="main navigation">
        <div class="container">
            <div class="navbar-brand">
                <router-link v-if="brand" :to="brand.url" class="application-navbar-brand">
                    <img :src="brand.image" :alt="brand.name">
                </router-link>
                <a @click="onNavbarBurgerClick" :class="['navbar-burger', isActive ]" :data-target="uniqueId" role="button" aria-label="menu" aria-expanded="false">
                    <span aria-hidden="true"></span>
                    <span aria-hidden="true"></span>
                    <span aria-hidden="true"></span>
                </a>
            </div>
            <div :class="['navbar-menu', isActive]" :id="uniqueId">
                <div v-if="startLinks" class="navbar-start">
                    <router-link v-for="(link, i) in startLinks" :key="link.name" :to="link.url" class="application-navbar-link">
                        {{ link.name }}
                    </router-link>
                </div>
                <div v-if="endLinks" class="navbar-end">
                    <template v-for="(link, i) in endLinks" :key="link.name">
                        <a v-if="link.reload" :href="link.url" class="application-navbar-link">
                            {{ link.name }}
                        </a>
                        <router-link v-else :to="link.url" class="application-navbar-link">
                            {{ link.name }}
                        </router-link>
                    </template>
                </div>
            </div>
        </div>
    </nav>
</template>
    