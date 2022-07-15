<script setup>
// · import lesli stores
import { useOnboarding } from "Lesli/vue3/onboarding/store"


// · implement stores
const storeOnboarding = useOnboarding()

// . translations
const translations = storeOnboarding.translations

</script>
<template>
    <div class="field action-buttons">
        <div class="control mb-1">
            <button class="button is-primary" @click="storeOnboarding.next()">
                <span>{{ translations.core.onboardings.view_btn_continue }}</span>
                <span class="icon">
                    <span class="material-icons">
                        east
                    </span>
                </span>
            </button>
        </div>
        <div class="control">
            <button class="button is-text skip">
                {{translations.core.onboardings.view_text_skip_onboarding_title}}
            </button>
        </div>
    </div>
</template>
