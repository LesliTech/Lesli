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
import { ref, onMounted } from "vue"


// · 
import mermaid from "mermaid"


// · 
const mermaidnode = ref(null)


// · load the mermaid diagram
mermaid.initialize({
    startOnLoad: true,
    sequence: { showSequenceNumbers: true }
})


// · change some default settings
mermaid.sequenceConfig = {
    diagramMarginX: 50,
    diagramMarginY: 10,
    boxTextMargin: 5,
    noteMargin: 10,
    messageMargin: 35,
    mirrorActors: true,
    actorFontSize: 16
};


// · 
onMounted(() => {

    // re-render the diagram every time we visit the page
    // this is necessary for SPAs
    mermaidnode.value.removeAttribute("data-processed")
    mermaid.init(undefined, mermaidnode.value)

})
</script>
<template>
    <div ref="mermaidnode" class="mermaid">
        <slot></slot>
    </div>
</template>
