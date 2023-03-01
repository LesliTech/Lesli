<script setup>
/*

Copyright (c) 2023, all rights reserved.

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
import { onMounted, ref, watch } from "vue"


// · import third-party libraries
import mermaid from "mermaid";


// · props
const props = defineProps({
    type: {
        type: String,
        default: "graph"
    },
    direction: {
        type: String,
        default: "TB"
    },
    markers: {
        type: Array,
        required: true
    }
})


// · mermaid global configuration
const config = { 
    startOnLoad: false,
    init: {
        theme: 'base', 
        gitGraph: {
            mainBranchName: 'master'
        }
    }
}


// · Graph container (as SVG plain string)
const graphSVG = ref(null)


// · Mermaid graph markers container
const graphDefinitionMarkers  = ref([])


// · initialize graph
mermaid.initialize(config);


// · General metod to add nodes to the graph
// params:
//      a = initial state
//      b = final state
//      c = conector
function addMarker(a,b=false,c="-->") {
    if (!b ) {
        graphDefinitionMarkers.value.push(`${a}`)    
        return
    }
    graphDefinitionMarkers.value.push(`${a}${c}${b}`)
}


// · Add marker to Graph & State Diagram
function addGraphMarker(a,b) {
    addMarker(a,b)
}


// · load individual marker
function loadMarkers() {

    var addMarkerFunction = addGraphMarker;

    switch (props.type) {
        case 'graph': addMarkerFunction = addGraphMarker; break;
        case 'stateDiagram-v2': addMarkerFunction = addGraphMarker; break;
    }

    props.markers.forEach(marker => {

        addMarkerFunction(`${marker.id}(${marker.name})`)

        if (marker.next) {
            marker.next.forEach(next => {
                addMarkerFunction(`${marker.id}[${marker.name}]`, next)
            })
        } 
    })
}


// · 
onMounted(() => {

    // add diagram type and direction 
    graphDefinitionMarkers.value = [props.type + " " + props.direction]

    // load markers sent as props
    loadMarkers()

    // render diagram
    graphSVG.value = mermaid.mermaidAPI.render("graphDiv", graphDefinitionMarkers.value.join(" \n"));

})


</script>
<template>
    <div id="graphDiv"></div>
    <div class="has-text-centered">
        <div v-html="graphSVG"></div>
    </div>
</template>
