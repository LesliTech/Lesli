<script>
/*

Copyright (c) 2021, all rights reserved.

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
            color: '#64baff'
        }
    },
    methods: {
        postTheme() {
            this.http.post(this.url.admin("account/settings"), {
                setting: {
                    name: "theme_primary_color",
                    value: this.color
                }
            }).then(result => {
                if (!result.successful) {
                    this.msg.error(result.error.message)
                    return
                }
                this.msg.info("color saved successfully")
            })
        }
    },
    watch: {
        color() {
            this.postTheme()
        }
    }

}
</script>
<template>
    <div class="box settings-theme">
        <div class="field">
            <label class="label">Primary color {{ color }}</label>
            <div class="control">
                <input v-model="color" class="input" type="color" placeholder="Select color">
            </div>
        </div>
    </div>
</template>
