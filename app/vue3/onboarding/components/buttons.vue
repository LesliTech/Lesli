<script setup>
</script>
<template>
<div class="field action-buttons">
    <div class="control mb-1">
        <button class="button is-primary" @click="storeOnboarding.next()">
            <span>{{ translations.core.onboardings.view_text_continue }}</span>
            <span class="icon">
                <span class="material-icons">
                    east
                </span>
            </span>
        </button>
    </div>
    <div class="control">
        <button class="button is-text skip">
            Skip for now
        </button>
    </div>
</div>
</template>
