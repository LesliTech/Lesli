<script>
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


// ·
export default {
    data() {
        return {
            slot_settings: false,
            translations: {
                core: {
                    sidebar_nav_settings: I18n.t("core.shared.sidebar_nav_settings")
                }
            }
        }
    },
    mounted() {
        this.slot_settings = this.$slots['settings']
    },
    methods: {
        postUserShortcut() {
            /*
            this.http.post(this.url.admin("users/:id/shortcuts", { id: this.lesli.current_user.id}), {
                user_shortcut: {
                    name: document.title,
                    url: window.location.toString()
                }
            }).then(result => {
                if (result.successful) {
                    this.msg.success("Shortcut created successfuly")
                }
                console.log(result)
            }).catch(error => {
                console.log(error)
            })
            */
        }
    }
}
</script>
<template>
    <aside class="application-sidebar">
        <slot name="brand"></slot>
        <span @click="data.global.show_panel_engines = true">engines</span>
        <nav class="application-navigation menu">
            <ul class="menu-list">
                <slot></slot>

            </ul>
            <ul class="menu-list">
                <slot name="nav-end"></slot>
            </ul>
        </nav>
    </aside>
</template>
