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
import { useRouter } from 'vue-router'

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

const router = useRouter()

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

const onClickLink = (link) => {
    if (link?.reload) window.location.href = link.url
    else router.push(link.url)
}

</script>

<template>
    <nav class="lesli-navbar navbar" role="navigation" aria-label="main navigation">
        <div class="container">
            <div class="navbar-brand">
                <template v-if="brand">
                    <a @click="onClickLink(brand)" class="lesli-navbar-brand">
                        <img :src="brand.image" :alt="brand.name">
                    </a>
                    
                </template>
                <a @click="onNavbarBurgerClick" :class="['navbar-burger', isActive ]" :data-target="uniqueId" role="button" aria-label="menu" aria-expanded="false">
                    <span aria-hidden="true"></span>
                    <span aria-hidden="true"></span>
                    <span aria-hidden="true"></span>
                </a>
            </div>
            <div :class="['navbar-menu', isActive]" :id="uniqueId">
                <div v-if="startLinks" class="navbar-start">
                    <a v-for="(link, i) in startLinks" :key="link.name" @click="onClickLink(link)"  class="lesli-navbar-link">
                        {{ link.name }}
                    </a>
                </div>
                <div v-if="endLinks" class="navbar-end">
                    <a v-for="(link, i) in endLinks" :key="link.name" @click="onClickLink(link)" class="lesli-navbar-link">
                        {{ link.name }}
                    </a>
                </div>
            </div>
        </div>
    </nav>
</template>
