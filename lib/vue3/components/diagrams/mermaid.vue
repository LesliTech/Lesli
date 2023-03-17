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


// · defining emits
const emit = defineEmits(['change']);


// · import third-party libraries
import mermaid from "mermaid";


// · props
const props = defineProps({
    type: {
        type: String,
        default: "flowchart"
    },
    direction: {
        type: String,
        default: "TB"
    },
    markers: {
        type: Array,
        required: true
    },
    centered: {
        type: Boolean,
        default: true,
        required: false
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


// · Mermaid hard html id
const diagramID = `component-diagram-${Math.floor(Math.random() * 100)}`


// · initialize graph
mermaid.initialize(config);


// · Method to initialize diagrams
// · what this function does:
//      - set the diagram type
//      - set the diagram direction
function setDiagramDetails() {
    if (props.type=='flowchart') {
        addMarker(`${props.type} ${ props.direction }`);
        return;
    }
    if (props.type=='stateDiagram-v2') {
        addMarker(props.type); 
        addMarker(`direction ${props.direction}`); 
        return;
    }
}


// · Initialize markers for the different types of diagrams
// · what this function does:
//      - add marker name (if provided)
//      - add diagram initial marker (if needed, usually only for state diagrams)
function addMarkerDetails(marker) {

    // add default style classes a.k.a klase
    // Note: class is a reserved js word so instead we use klase to refer to css classes in code
    addMarker("classDef selected fill:white,color:blue,stroke:blue")

    if (props.type=='flowchart') {
        addMarker(`${marker.id}(${ (marker.name || marker.id) })`);
        return;
    }

    if (props.type=='stateDiagram-v2') {
        // register the name of the marker for the respective diagram type
        addMarker(`${marker.id} : ${ (marker.name || marker.id) }`); 
        // state diagrams can have initial and final statuses
        if (marker.status_type == 'initial') {
            addMarker('[*]', marker.id); 
        }
        if (marker.status_type == 'completed_successfully' || marker.status_type == 'completed_unsuccessfully') {
            addMarker(marker.id, '[*]'); 
        }
        
        return;
    }
}


// · General metod to add nodes to the graph
// · params:
//      a = initial state
//      b = next state
//      c = conector
function addMarker(a,b=false,c="-->") {

    // if next state is not defined, we defined the data for the state
    if (!b ) {

        // if name was provided for the state
        graphDefinitionMarkers.value.push(a);

        // stop the execution
        return
    }

    // define the status machine using initial, next and the connector
    graphDefinitionMarkers.value.push(`${a}${c}${b}`)
}


// · Add marker for flow diagrams
function addFlowMarker(a,b, klase=null) {

    // add state machine marker
    addMarker(a,b)
}


// · Add marker for state diagrams
function addStateMarker(a,b, klase=null) {

    if (klase) {
        a = `${a}:::${klase}`
    }
    
    // add state machine marker
    addMarker(a,b)
}


// · load individual marker
function loadMarkers() {

    var addMarkerFunction = addMarker;

    switch (props.type) {
        case 'flowchart': addMarkerFunction = addFlowMarker; break;
        case 'stateDiagram-v2': addMarkerFunction = addStateMarker; break;
    }

    props.markers.forEach(marker => {

        addMarkerDetails(marker)

        if (marker.next_statuses) {

            marker.next_statuses.forEach(next => {
                addMarkerFunction(marker.id, next, marker.klase)
            })
        } 
    })
}


// · 
function renderDiagram() {

    // reset internal markers container
    graphDefinitionMarkers.value = []

    // initialize diagram
    setDiagramDetails()

    // load markers sent as props
    loadMarkers()

    // render diagram
    graphSVG.value = mermaid.mermaidAPI.render(diagramID, graphDefinitionMarkers.value.join(" \n"));
}


// · 
onMounted(() => {
    renderDiagram()
})


// · listen for changes on markers
watch(() => props.markers, () => {

    // update diagram to render new diagram markers 
    renderDiagram();

    // let the parent component know that markers have changed
    emit('change');

}, { 

    // watch for nested attributes in the markers array
    deep: true 
})

</script>
<template>
    <div :id="diagramID"></div>
    <div :class="{'has-text-centered': props.centered }" v-html="graphSVG"></div>
</template>
