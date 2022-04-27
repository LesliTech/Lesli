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
                        :placeholder="translations.core.shared.search_placeholder || 'Search in Lesli'"
                        @input="searchText">
                    <span class="icon is-left has-text-gray">
                        <svg v-if="!search.searching" width="24" height="23" viewBox="0 0 24 23" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M9.23422 0.189957C4.59637 0.189957 0.824219 3.96211 0.824219 8.59996C0.824219 13.2378 4.59637 17.01 9.23422 17.01C11.3459 17.01 13.2754 16.2238 14.7533 14.9346L22.4564 22.6378C22.6707 22.8584 23.0648 22.8655 23.2811 22.6468C23.4974 22.4281 23.495 22.025 23.272 21.8131L15.578 14.119C16.8648 12.6418 17.6442 10.7096 17.6442 8.59996C17.6442 3.96211 13.8721 0.189957 9.23422 0.189957ZM9.23422 1.34996C13.2452 1.34996 16.4842 4.58902 16.4842 8.59996C16.4842 12.6109 13.2452 15.85 9.23422 15.85C5.22328 15.85 1.98422 12.6109 1.98422 8.59996C1.98422 4.58902 5.22328 1.34996 9.23422 1.34996Z" fill="#214FBD"/>
                        </svg>
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

                <a class="navbar-item" @click="data.global.show_panel_engines = true">
                    <svg width="35" height="35" viewBox="0 0 35 35" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <rect width="35" height="35" rx="10" fill="#E2E6F6"/>
                        <g clip-path="url(#clip0_573_490)">
                        <path d="M17.559 10.208C17.2207 10.208 16.9465 10.4822 16.9465 10.8205V16.9455H10.8215C10.4832 16.9455 10.209 17.2197 10.209 17.558C10.209 17.8963 10.4832 18.1705 10.8215 18.1705H16.9465V24.2955C16.9465 24.6338 17.2207 24.908 17.559 24.908C17.8973 24.908 18.1715 24.6338 18.1715 24.2955V18.1705H24.2965C24.6348 18.1705 24.909 17.8963 24.909 17.558C24.909 17.2197 24.6348 16.9455 24.2965 16.9455H18.1715V10.8205C18.1715 10.4822 17.8973 10.208 17.559 10.208Z" fill="#2F478D"/>
                        </g>
                        <defs>
                        <clipPath id="clip0_573_490">
                        <rect width="15.3125" height="15.3125" fill="white" transform="translate(10.209 10.208)"/>
                        </clipPath>
                        </defs>
                    </svg>
                    <!--
                    <span class="material-icons md-36">
                        add_box
                    </span>
                    -->
                </a>

                <a class="navbar-item header-notification-indicator">
                    <svg width="26" height="31" viewBox="0 0 26 31" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M12.9086 30.804C14.4665 30.804 15.7574 29.6162 15.98 28.063H9.83719C10.0598 29.6162 11.3506 30.804 12.9086 30.804Z" fill="#C8CEE1"/>
                    <path d="M14.0216 3.02798V1.70314C14.0216 1.06356 13.5319 0.561035 12.9087 0.561035C12.2856 0.561035 11.7959 1.06356 11.7959 1.70314V3.02798C7.03304 3.62188 3.33847 7.77914 3.33847 12.8044V21.8042C3.33847 22.992 2.84883 23.997 1.64699 23.997C0.89027 23.997 0.26709 24.5452 0.222577 25.2305C0.178064 25.6417 0.311602 26.0071 0.578679 26.2812C0.845756 26.5553 1.20186 26.7381 1.55796 26.7381H24.2595C24.6601 26.7381 24.9717 26.601 25.2388 26.2812C25.5059 26.0071 25.5949 25.596 25.5949 25.2305C25.5504 24.5452 24.8827 23.997 24.1705 23.997C23.0131 23.997 22.479 23.0377 22.479 21.8042V17.2815C18.0722 16.6876 14.6892 12.8501 14.6892 8.1903C14.6892 6.4543 15.1789 4.85535 15.9801 3.48483C15.3569 3.2564 14.6892 3.11935 14.0216 3.02798Z" fill="#E2E6F6"/>
                    </svg>
                    <span class="count">0</span>
                    <!--
                    <span class="material-icons md-36">
                        notifications
                    </span>
                    
                    -->
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
