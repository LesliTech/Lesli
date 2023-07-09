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
import { onMounted, ref } from "vue"

// · defining props
const props = defineProps({
    // · prop that indicates the distanceView of the map in meters
    zoom : {
        type: Number,
        required: false,
        default: 240,
    },
    // · prop that has all the annotation marks to set in the map
    locations : {
        type: Object,
        required: true,
        default: [{ latitude: "", longitude:""}]
    }
})

// · Initialize map ref
const mapRef = ref(null)

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

    let landmarks = []

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
    const CALLOUT_OFFSET = new DOMPoint(-148, -78)
    let landmarkAnnotationCallout = {
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
    const annotations = landmarks.map(function(landmark) {
        const annotation = new mapkit.MarkerAnnotation(landmark.coordinate, {
            callout: landmarkAnnotationCallout,
            color: landmark.color ? landmark.color : "#f52929"
        })
        annotation.landmark = landmark
        return annotation
    })

    const map = new mapkit.Map(mapRef.value, { cameraDistance: (props.zoom * 1000) })
    map.showItems(annotations)

    // Landmark annotation custom callout
    function calloutForLandmarkAnnotation(annotation) {
        const div = document.createElement("div")
        div.className = "landmark"

        const title = div.appendChild(document.createElement("h1"))
        title.textContent = annotation.landmark.title

        const section = div.appendChild(document.createElement("section"))

        if (annotation.landmark.url){
            const link = section.appendChild(document.createElement("p"))
            link.className = "homepage"

            const a = link.appendChild(document.createElement("a"))
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
    <div class="lesli-map" ref="mapRef"></div>
</template>
