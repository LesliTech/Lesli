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
    // · prop that indicates the distanceView of the map in meters
    distanceView : {
        type: Number,
        required: false,
        default: 240000,
    },
    // · prop that has all the annotation marks to set in the map
    locations : {
        type: Object,
        required: true,
        default: [{ latitude: "", longitude:""}]
    },
    mapId: {
        type: String,
        required: true,
        default: "apple-map"
    }
})

/**
 * @description this function is used to initialize apple map
 */
function initializeMap(){

    mapkit.init({
        authorizationCallback: function(done) {
            //ampkt is const used in javascript_apple_mapkit_js that contains the JWT token for apple maps
            done(ampkt)
        }
    })

    var landmarks = []

    // Landmarks data
    props.locations.forEach((location) => {
        landmarks.push({
            coordinate: new mapkit.Coordinate(Number(location.latitude), Number(location.longitude)),
            title: location.title,
            url: location.url ? location.url : "",
            color: location.color ? location.color : "",
            })
    })

    // Landmark annotation callout delegate
    var CALLOUT_OFFSET = new DOMPoint(-148, -78)
    var landmarkAnnotationCallout = {
        calloutElementForAnnotation: function(annotation) {
            return calloutForLandmarkAnnotation(annotation)
        },
    
        calloutAnchorOffsetForAnnotation: function(annotation, element) {
            return CALLOUT_OFFSET
        },
    
        calloutAppearanceAnimationForAnnotation: function(annotation) {
            return ".4s cubic-bezier(0.4, 0, 0, 1.5) 0s 1 normal scale-and-fadein"
        }
    }

    // Landmarks annotations
    var annotations = landmarks.map(function(landmark) {
        var annotation = new mapkit.MarkerAnnotation(landmark.coordinate, {
            callout: landmarkAnnotationCallout,
            color: landmark.color ? landmark.color : "#f52929"
        })
        annotation.landmark = landmark
        return annotation
    })

    var map = new mapkit.Map(props.mapId, { cameraDistance: props.distanceView })
    map.showItems(annotations)

    // Landmark annotation custom callout
    function calloutForLandmarkAnnotation(annotation) {
        var div = document.createElement("div")
        div.className = "landmark"
    
        var title = div.appendChild(document.createElement("h1"))
        title.textContent = annotation.landmark.title
    
        var section = div.appendChild(document.createElement("section"))

        if (annotation.landmark.url){
            var link = section.appendChild(document.createElement("p"))
            link.className = "homepage"

            var a = link.appendChild(document.createElement("a"))
            a.href = annotation.landmark.url
            a.textContent = "website"
        }

        return div
    }

}

// · initializing
onMounted(() => {
    initializeMap()
})

</script>

<template>
    <div class="apple-map" :id="props.mapId"></div>
</template>
