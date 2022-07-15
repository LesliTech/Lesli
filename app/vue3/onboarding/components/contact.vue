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
import { ref, reactive, onMounted, watch, computed, onUnmounted } from "vue";

// · import lesli stores
import { useOnboarding } from "Lesli/vue3/onboarding/store";

// · implement stores
const storeOnboarding = useOnboarding();

// . translations
const translations = storeOnboarding.translations;

</script>
<template>
    <form>
        <div class="field">
            <label class="label">{{
                translations.core.onboardings.view_text_email
            }}</label>
            <div class="control">
                <input
                    class="input"
                    type="text"
                    placeholder="Enter your main E-mail address"
                />
            </div>
        </div>

        <div class="field">
            <label class="label">{{translations.core.shared.view_text_telephone}}</label>
            <div class="control">
                <input class="input" type="text" placeholder="Enter your phone number" />
            </div>
        </div>

        <p>SOCIAL PROFILES</p>

        <div class="field">
            <label class="label">{{
                translations.core.accounts.column_github
            }}</label>
            <div class="control">
                <input
                    class="input"
                    type="text"
                    placeholder="Enter your Github profile URL"
                />
            </div>
        </div>


        <div class="field">
            <label class="label">{{
                translations.core.accounts.column_twitter
            }}</label>
            <div class="control">
                <input
                    class="input"
                    type="text"
                    placeholder="Enter your Twitter profile URL"
                />
            </div>
        </div>

        
        <div class="field">
            <label class="label">{{
                translations.core.accounts.column_youtube
            }}</label>
            <div class="control">
                <input
                    class="input"
                    type="text"
                    placeholder="Enter your Youtube profile URL"
                />
            </div>
        </div>

                
        <div class="field">
            <label class="label">{{
                translations.core.accounts.column_linkedin
            }}</label>
            <div class="control">
                <input
                    class="input"
                    type="text"
                    placeholder="Enter your LinkedIn profile URL"
                />
            </div>
        </div>

                
        <div class="field">
            <label class="label">{{
                translations.core.accounts.column_facebook
            }}</label>
            <div class="control">
                <input
                    class="input"
                    type="text"
                    placeholder="Enter your Facebook profile URL"
                />
            </div>
        </div>
    </form>
</template>
