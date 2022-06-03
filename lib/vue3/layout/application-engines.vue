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
import { useLayout } from "LesliVue/stores/layout"

const show = ref(true)

// · 
const storeLayout = useLayout()

</script>
<template>
    <Transition>
        <section v-if="storeLayout.showEngines" class="application-engines" @click="storeLayout.toggleEngines()">
            <div>
                <slot></slot>
            </div>
        </section>
    </Transition>
</template>
