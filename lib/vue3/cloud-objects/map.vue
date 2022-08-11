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
import { onMounted } from "vue"


// · defining props
const props = defineProps({
    // · prop that indicates if the will be shown the new file tab, by default it is true.
    longitude: {
        type: String,
        required: true,
        default: "",
    },
    // · prop that indicates if the will be shown the list files tab, by default it is true.
    latitude: {
        type: String,
        required: true,
        default: "",
    },
    markerTitle: {
        type: String,
        required: false,
        default: "",
    },
    distanceView : {
        type: Number,
        required: false,
        default: 240000,
    }
})


//. Initializing apple map
function initializeMap(){

    var MarkerAnnotation = mapkit.MarkerAnnotation

    var titleAnnotation = props.markerTitle
    // Get coordinates defined in props
    var location = new mapkit.Coordinate(Number(props.latitude), Number(props.longitude))

    mapkit.init({
        authorizationCallback: function(done) {
            //ampkt is const used in javascript_apple_mapkit_js that contains the JWT token for apple maps
            done(ampkt);
        }
    })
    var maps = new mapkit.Map('summary-map', { cameraDistance: props.distanceView })

    // Add a marker to the map in the coordinates for the location specified
    var locationAnnotation = new MarkerAnnotation(location, { color: "#ffffff", title: titleAnnotation, glyphText: "📍" })
    maps.showItems([locationAnnotation])

}

// · initializing
onMounted(() => {
    initializeMap()
})

</script>

<template>
    <div id="summary-map" class="component-summary-map"></div>
</template>


<style>
#summary-map {
    width: 100%;
    height: 300px;
}
</style>
