<script>
/*
Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

LesliCloud - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@license  Propietary - all rights reserved.
@version  0.1.0-alpha

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/
export default {
    props: {
        size: {
            default: "is-large"
        }
    },

    computed: {
        textSizeClass(){
            switch(this.size){
                case "is-large": 
                    return "is-size-2"
                case "is-medium":
                    return "is-size-4"
                case "is-small":
                    return "is-size-7"
                default:
                    return "is-size-4"
            }
        }
    }
}
</script>
<template>
    <div class="component-data-loading has-text-centered">
        <b-icon icon="spinner" :size="size" custom-class="fa-spin"/>
        <span :class="textSizeClass">Loading...</span>
    </div>
</template>
