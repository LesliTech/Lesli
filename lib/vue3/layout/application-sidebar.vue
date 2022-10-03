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
import { useSlots } from "vue"


// · 
const slots = useSlots()


</script>
<template>
    <aside class="application-sidebar">
        <a class="brand" href="/">
            <slot name="brand"></slot>
        </a>
        <nav class="menu is-flex-grow-1 is-flex is-flex-direction-column is-justify-content-space-between">
            <ul class="menu-list">
                <slot></slot>
            </ul>
            <ul class="menu-list">
                <lesli-navigation-list v-if="slots.settings" icon="ri-list-settings-line" label="Settings">
                    <slot name="settings"></slot>
                </lesli-navigation-list>
            </ul>
        </nav>
        <slot name="context"></slot>
    </aside>
</template>
