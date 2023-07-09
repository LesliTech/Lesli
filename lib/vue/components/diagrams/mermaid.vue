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
import { onMounted, ref, watch } from "vue"

// · import third-party libraries
import mermaid from "mermaid"


// · defining emits
const emit = defineEmits(['change']);





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
