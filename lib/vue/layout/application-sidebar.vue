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
