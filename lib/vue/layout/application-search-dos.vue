<script>
/*

Copyright (c) 2020, all rights reserved.

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
export default {
    data() {
        return {
            text: "",
            show: false,
            timer: null,
            results: [],
            translations: {
            }
        }
    },
    mounted() {
        setTimeout(() => {
            this.getSearch()
        }, 3000)
    },
    methods: {

        getSearch() {

            this.http.get("/search").then(result => {

            })

        }

    }

}
</script>
<template>
    <section v-if="show" class="application-global-search">
        <div class="content">
            <h4>Global search</h4>
            {{ results }}
        </div>
    </section>
</template>
