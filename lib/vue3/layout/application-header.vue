<script setup>
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


// · import vue tools
import { ref, reactive, onMounted, onUnmounted, inject } from "vue"


// · import stores
import { useLayout } from "LesliVue/stores/layout"
import { useSearch } from "LesliVue/stores/search"


// · implement stores
const storeLayout = useLayout()
const storeSearch = useSearch()


// · translations
const translations = {
    core: {
        shared: I18n.t("core.shared"),
        users: I18n.t('deutscheleibrenten.users'),
    }
}


// · defining variables
const applicationHeader = ref(null)
const search = {}


// · initializing
onMounted(() => {

})


// · capture user scroll to add special styles for the header
function handleScroll($event) {

    let scrollTop = window.pageYOffset || document.body.scrollTop;
    if (scrollTop > applicationHeader.value.offsetHeight - 100) {
        applicationHeader.value.classList.add("scrolling-header-navigation")
    } else {
        applicationHeader.value.classList.remove("scrolling-header-navigation")
    }

}


// · listen for all the scroll event
window.addEventListener('scroll', handleScroll);


// · stop listeners
onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
})

</script>
<template>
    <header ref="applicationHeader" class="application-header">
        <div class="header-navigation">
            <div class="header-left">
                <div class="control is-medium has-icons-left has-text-grey">
                    <input 
                        type="email" 
                        name="global_search"
                        class="input is-medium is-shadowless" 
                        :placeholder="translations.core.shared.search_placeholder || 'Search in Lesli'"
                        @input="storeSearch.doSearch"
                        v-model="storeSearch.text" 
                    />
                    <span class="icon is-left has-text-gray">
                        <lesli-icon 
                            id="search"
                            v-if="(storeSearch.loading == false)">
                        </lesli-icon>
                        <lesli-loading 
                            :icon="true"
                            v-if="(storeSearch.loading == true)">
                        </lesli-loading>
                    </span>
                </div>
            </div>
            <div class="header-right">

                <slot></slot>


                <!-- header action button -->
                <a class="navbar-item">
                    <span class="material-icons md-36">
                        add_box
                    </span>
                </a>

                <!-- Notifications -->
                <a class="navbar-item header-notification-indicator" @click="storeLayout.showNotifications = true">
                    <span class="material-icons md-36 is-active">
                        notifications
                    </span>
                    <span class="count">
                        {{ storeLayout.header.notifications }}
                    </span>
                </a>

                <!-- Profile options -->
                <div class="dropdown is-right is-hoverable header-user-options">
                    <div class="dropdown-trigger">
                        <span class="material-icons md-36">
                            account_circle
                        </span>
                    </div>
                    <div class="dropdown-menu" id="dropdown-menu" role="menu">
                        <div class="dropdown-content">
                            <a href="/administration/profile" class="dropdown-item header-user-options-profile ">
                                <span class="icon-text">
                                    <span class="icon has-text-grey-light">
                                        <span class="material-icons">
                                            person
                                        </span>
                                    </span>
                                    <span>{{ translations.core.shared.view_text_profile }}</span>
                                </span>
                            </a>
                            <hr class="dropdown-divider">
                            <a href="/logout" class="dropdown-item">
                                <span class="icon-text">
                                    <span class="icon">
                                        <span class="material-icons">
                                            logout
                                        </span>
                                    </span>
                                    <span>{{ translations.core.shared.view_text_logout }}</span>
                                </span>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </header>
</template>
