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
            navbar: null,
            application_header: null
        }
    },

    mounted() {
        this.addListeners();
    },

    methods: {

        addListeners(){
            this.application_header = document.querySelector('#lesli-application .application-header')
            window.addEventListener('scroll', () => {

                let scrollTop = window.pageYOffset || document.body.scrollTop;

                // check if the users scroll, 100 is equal to header height
                if (scrollTop > this.application_header.offsetHeight - 100) {
                    this.application_header.classList.add("scrolling-header-navigation")
                } else {
                    this.application_header.classList.remove("scrolling-header-navigation")
                }
                
            });
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
                        :placeholder="translations.core.shared.search_placeholder || 'Search in Lesli'"
                        @input="searchText">
                    <span class="icon is-left has-text-gray">
                        <lesli-svg id="search" />
                        <lesli-data-loading v-if="search.searching && searchText!=''" :icon-only="true"/>
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

                <a class="navbar-item">
                    <lesli-svg id="add" size="35" />
                </a>

                <a class="navbar-item header-notification-indicator">
                    <lesli-svg id="bell" size="35" />
                    <span class="count">0</span>
                </a>

                <div class="dropdown is-right is-hoverable header-user-options">
                    <div class="dropdown-trigger">
                        <span class="material-icons md-36">
                            account_circle
                        </span>
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
