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


// ·
const platform = require('platform');


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
        this.getBrowserData();
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

        getBrowserData(){
            this.browser_data = {
                name: platform.name,
                full_version: platform.version,
                version: parseInt(platform.version.split('.')[0]),
                layout: platform.layout
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
    },

    computed: {
        supportedBrowser(){
            if(this.browser_data.name == 'Microsoft Edge' && this.browser_data.version < 84){
                return false
            }
            return true
        }
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
                        <i v-if="!search.searching" class="fas fa-search"></i>
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

        <b-notification v-if="! supportedBrowser" type="is-warning">
            {{translations.core.shared.notice_browser_not_supported_1}}
            {{browser_data.name}} - {{browser_data.full_version}}
            {{translations.core.shared.notice_browser_not_supported_2}}
            <a target="_blank" href="/system-requirements">
                {{translations.core.shared.notice_browser_not_supported_3}}
            </a>
        </b-notification>

    </header>
</template>
