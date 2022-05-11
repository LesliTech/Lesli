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


// · import stores
import { useCoreLayout } from "LesliVue/stores/layout"


// · 
const coreLayout = useCoreLayout()


</script>
<template>
    <aside class="application-sidebar">
        <div class="brand">
            <a href="/">
                <slot name="brand"></slot>
            </a>
            <lesli-svg @click="coreLayout.toggleEngines()" id="menu" class="is-hidden-touch" />
        </div>
        <nav class="menu is-flex-grow-1">
            <ul class="menu-list">
                <li class="is-hidden-desktop">
                    <a>
                        <lesli-svg @click="coreLayout.toggleEngines()" id="menu" />
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
