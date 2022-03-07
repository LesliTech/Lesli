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
        }
    }
}
</script>
<template>
    <aside class="application-sidebar">
        <slot name="brand"></slot>
        <nav class="application-navigation menu">
            <ul class="menu-list">
                <slot></slot>
            </ul>
            <ul class="menu-list">
                <slot name="nav-end"></slot>
                <b-menu-item v-if="slot_settings">
                    <template slot="label" slot-scope="props">
                        <i class="fas fa-cogs"></i>
                        <span>{{ translations.core.sidebar_nav_settings }}</span>
                        <b-icon class="is-pulled-right" :icon="props.expanded ? 'caret-down' : 'caret-right'"></b-icon>
                    </template>
                    <li>
                        <slot name="settings"></slot>
                        <a @click="postUserShortcut()">
                            <i class="fas fa-thumbtack"></i>
                            <span>pin page</span>
                        </a>
                    </li>
                </b-menu-item>
            </ul>
        </nav>
    </aside>
</template>
