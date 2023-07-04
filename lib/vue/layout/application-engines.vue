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
import { ref, reactive, onMounted, inject } from "vue"


// · import stores
import { useLayout } from "Lesli/shared/stores/layout"


// · 
const storeLayout = useLayout()

</script>
<template>
    <Transition>
        <section v-if="storeLayout.showEngines" class="application-engines" @click="storeLayout.toggleEngines()">
            <div class="engines">
                <slot></slot>
                <button class="button is-hidden-tablet">
                    <span class="icon">
                        <i class="ri-close-line"></i>
                    </span>
                    <span>close</span>
                </button>
            </div>
        </section>
    </Transition>
</template>
