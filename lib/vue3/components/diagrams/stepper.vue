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
const emit = defineEmits(['update:modelValue']);

const activeStep = ref(props.modelValue)
// const activeStep = ref(props.modelValue.number)
const dropdownActive = ref(false)

const setActiveStep = (step) => {
    emit("update:modelValue", activeStep.value)

    // activeStep.value = step
}


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
        <div class="editor">
            <div :class="['dropdown', 'is-right is-hoverable']">
                <div class="dropdown-trigger">
                    <button class="button" 
                        @blur="dropdownActive = false"
                        @click="dropdownActive = !dropdownActive">
                        <span class="icon">
                            <span v-if="!dropdownActive" class="material-icons">
                                edit
                            </span>
                            <span v-if="dropdownActive" class="material-icons">
                                close
                            </span>
                        </span>
                    </button>
                </div>
                <Transition>
                    <div v-if="dropdownActive" class="dropdown-menu" role="menu">
                        <div class="dropdown-content">
                            <div class="dropdown-item" v-for="option in props.stepsOptions">
                                <div :class="{ active: option.number === activeStep.number }">
                                    <!-- <a  @click="setActiveStep(option.number)" > -->
                                    <a  @click="setActiveStep(option)">
                                        {{ option.name }}
                                    </a>
                                    <span v-if="option.number === activeStep.number" class="material-icons">
                                            check_circle
                                    </span>
                                </div>
                             
                            </div>
                        </div>
                    </div>
                </Transition>
            </div>

        </div>
    </div>
</template>
