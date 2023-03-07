<script setup>
/*

Copyright (c) 2023, all rights reserved.

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
import { onMounted, watch, inject } from "vue"
import { useRouter, useRoute } from 'vue-router'


// · import lesli stores
import { useAccountIssues } from "../../stores/accountIssues"


// · initialize/inject plugins
const route = useRoute()
const url = inject("url")


// · 
const storeIssues = useAccountIssues()


const translations = {
    core: {
        shared: I18n.t("core.shared"),
        issues: I18n.t("core.account/issues"),
        users: I18n.t("core.users")
    }
}

// · 
onMounted(() => {
    storeIssues.getIssue(route.params.id)
    storeIssues.getOptions()
})


// · 
watch(() => storeIssues.issue.status, () => {
    storeIssues.updateStatus()
} , { immediate: false })


</script>
<template>
    <section class="application-component">
        <lesli-header :title="`${storeIssues.issue.id} - ${storeIssues.issue.status}`">
            <lesli-dropdown
                :options="storeIssues.options.statuses"
                label="Change status"
                v-model="storeIssues.issue.status"
            ></lesli-dropdown>
            <lesli-button icon="list" :to="url.admin('account/issues')">
                {{ translations.core.shared.view_tab_title_list }}
            </lesli-button>
        </lesli-header>

        <div class="card">
            <div class="card-content">
                <div class="media">
                    <div class="media-content">
                        <p class="title is-4">{{ storeIssues.issue.first_name + " " +storeIssues.issue.last_name}}</p>
                        <h6>
                            <span class="icon is-small">
                                <span class="material-icons">
                                    email
                                </span>
                                </span>
                            <span> {{ translations.core.shared.view_text_email }}</span>
                        </h6>
                        <p class="subtitle is-6"><a :href="'mailto:' + storeIssues.issue.email">{{ storeIssues.issue.email }}</a></p>
                        
                        <h6>
                            <span class="icon is-small">
                                <span class="material-icons">
                                    call
                                </span>
                                </span>
                            <span> {{ translations.core.shared.view_text_telephone }}</span>
                        </h6>
                        <p class="subtitle is-6">{{ storeIssues.issue.telephone }}</p>

                        <h6>
                            <span class="icon is-small">
                                <span class="material-icons">
                                    list
                                </span>
                                </span>
                            <span> {{ translations.core.shared.view_text_category }}</span>
                        </h6>
                        <p class="subtitle is-6">{{ storeIssues.issue.category }}</p>

                    </div>
                </div>

            <div class="content">
                <h6>{{ translations.core.issues.view_text_message }}</h6>
                <textarea readonly class="textarea has-fixed-size">{{ storeIssues.issue.message }}</textarea>
                <br>
                <p class="subtitle is-6">{{ translations.core.shared.column_created_at }}</p>
                <time datetime="2016-1-1">{{ storeIssues.issue.created_at }}</time>
            </div>
        </div>
</div>



       
    </section>
</template>
