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
import { ref, reactive, onMounted, inject } from "vue"


// · import & implement stores
import { useLayout } from "LesliVue/stores/layout"


// · 
const storeLayout = useLayout()


// · 
function onEscape(event) {
    if (event.keyCode === 27) {
        storeLayout.toggleEngines()
        document.removeEventListener('keydown', onEscape)
    }
}


// · 
function toggleEngines() {
    storeLayout.toggleEngines()
    document.addEventListener('keydown', onEscape)
}

</script>
<template>
    <aside class="application-sidebar">
        <div class="brand">
            <a href="/">
                <slot name="brand"></slot>
            </a>
            <Transition>
                <span class="icon">
                    <lesli-icon 
                        class="is-hidden-touch"
                        :id="storeLayout.showEngines ? 'menu-open' : 'menu'" 
                        @click="toggleEngines()">
                    </lesli-icon>
                </span>
            </Transition>
        </div>
        <nav class="menu is-flex-grow-1">
            <ul class="menu-list">
                <li class="is-hidden-desktop">
                    <a>
                        <!-- engine navigation trigger for mobile -->
                        <Transition>
                            <lesli-icon 
                                :id="storeLayout.showEngines ? 'menu-open' : 'menu'" 
                                @click="toggleEngines()">
                            </lesli-icon>
                        </Transition>
                    </a>
                </li>
                <slot></slot>
            </ul>
            <ul class="menu-list">
                <slot name="nav-end"></slot>
            </ul>
        </nav>
        <slot name="context"></slot>
    </aside>
</template>
