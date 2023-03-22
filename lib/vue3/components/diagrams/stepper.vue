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
import { onMounted, ref, watch } from "vue"

// · props
const props = defineProps({
    steps: {
        type: Object
    },
    currentStep: {
        type: Number,
        default: 1
    },
    modelValue: {
        type: Number,
        required: false
    },
    stepsOptions: {
        type: Object
    }
})


// · defining emits 
const emit = defineEmits(['update:modelValue'])


const activeStep = ref(props.modelValue)

watch(props.modelValue, () => {
    if (activeStep.value) {
        emit("update:modelValue", activeStep.value)
    }
})

</script>
<template>
    <div class="stepper-component">
        <div class="steps">
            <div v-for="(step, index) in props.steps" :key="step.number" :class="{ active: activeStep.number === step.number || step.number < activeStep.number  }">
                <div class="step-circle"></div>
                <div class="step-line" v-if="index !== steps.length - 1"></div>
                <div class="step-label">{{ step.name }}</div>
            </div>
        </div>
    </div>
</template>
