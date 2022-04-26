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
            translations: {
                core: {
                    shared: I18n.t("core.shared"),
                    users: I18n.t('deutscheleibrenten.users'),
                }
            },
            search: {
                searching: false
            },
            navigation: {
                active: false
            },
            browser_data: {
            },
            $navbar: null,
            $application_header: null
        }
    },

    mounted() {
        this.addListeners();
    },

    methods: {

        addListeners(){
            window.addEventListener('scroll', this.handleScroll);
            this.$navbar = document.querySelector('#lesli-application .application-header .header-navigation')
            this.$application_header = document.querySelector('#lesli-application .application-header')
        },

        handleScroll($event){
            let scrollTop = window.pageYOffset || document.body.scrollTop;
            if (scrollTop > this.$application_header.offsetHeight - 10) {
                this.$navbar.classList.add("scrolling-header-navigation")
            } else {
                this.$navbar.classList.remove("scrolling-header-navigation")
            }
        },

        searchText(input) {

            this.search.searching = !input.srcElement.value == ""
            this.data.global.search = input.srcElement.value

            setTimeout(() => { this.search.searching = false }, 1400)

        }

    },

    destroyed () {
        window.removeEventListener('scroll', this.handleScroll);
    }

}
</script>
<template>
    <header class="application-header">
        <div class="header-navigation">
            <div class="header-left">
                <div class="control is-medium has-icons-left has-text-grey">
                    <input 
                        type="email" 
                        name="global_search"
                        class="input is-medium is-shadowless" 
                        :placeholder="translations.core.shared.search_placeholder"
                        @input="searchText">
                    <span class="icon is-left has-text-gray">
                        <span v-if="!search.searching" class="material-icons md-24">
                            search
                        </span>
                        <component-data-loading v-if="search.searching && searchText!=''" :icon-only="true"/>
                    </span>
                </div>
            </div>
            <div class="header-right">

                <slot></slot>
                <slot name="languages"></slot>
                <slot name="announcements"></slot>
                <slot name="tickets"></slot>
                <slot name="tasks"></slot>
                <slot name="notifications"></slot>

                <a class="navbar-item header-navigation-engine core" @click="data.global.show_panel_engines = true">
                    <span class="icon">
                        <span class="material-icons md-24">
                            add_box
                        </span>
                    </span>
                </a>

                <slot name="engines"></slot>

                <div class="dropdown is-right is-hoverable header-user-options">
                    <div class="dropdown-trigger">
                        <button class="button" aria-haspopup="true" aria-controls="dropdown-menu">
                            <span><slot name="username"></slot></span>
                            <span class="icon is-small">
                                <i class="fas fa-angle-down" aria-hidden="true"></i>
                            </span>
                        </button>
                    </div>
                    <div class="dropdown-menu" id="dropdown-menu" role="menu">
                        <div class="dropdown-content">
                            <a href="/administration/profile" class="dropdown-item header-user-options-profile ">
                                <span class="icon has-text-grey-light">
                                    <i class="fas fa-user"></i>
                                </span>
                                <span>{{ translations.core.shared.view_text_profile }}</span>
                            </a>
                            <hr class="dropdown-divider">
                            <a href="/logout" class="dropdown-item">
                                <span class="icon has-text-grey-light">
                                    <i class="fas fa-sign-out-alt"></i>
                                </span>
                                <span>{{ translations.core.shared.view_text_logout }}</span>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </header>
</template>
