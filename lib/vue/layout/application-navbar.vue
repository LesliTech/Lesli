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
    