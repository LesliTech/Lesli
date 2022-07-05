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
import { ref, reactive, onMounted, watch, computed } from "vue"
import { SetupCalendar, Calendar, DatePicker } from 'v-calendar';
import 'v-calendar/dist/style.css';


// · defining emits
const emit = defineEmits(['update:modelValue']);


// · defining props
const props = defineProps({
    modelValue: {
        type: [Date, Object],
    },
    range: {
        type: Boolean,
        required: false,
        default: false
    }
})


// · 
const date = ref(new Date())


// · 
const dateRange = ref({
    start: new Date(),
    end: new Date()
})


// · 
watch(date, () => {
    emit('update:modelValue', date.value)
})


// · 
watch(dateRange, () => {
    emit('update:modelValue', dateRange.value)
})

</script>
<template>
    <DatePicker v-if="!range" v-model="date">
        <template v-slot="{ inputValue, inputEvents }">
            <input
                class="input is-default"
                v-on="inputEvents"
                :value="inputValue"
            />
        </template>
    </DatePicker>

    <DatePicker v-if="range" v-model="dateRange" is-range>
        <template v-slot="{ inputValue, inputEvents }">
            <input
                class="input is-default"
                :value="inputValue.start + ' - ' + inputValue.end"
                v-on="inputEvents.start"
                readonly
            />
            <!--
            <input
                class="input is-default"
                :value="inputValue.start"
                v-on="inputEvents.start"
            />
            <input
                class="input is-default"
                :value="inputValue.end"
                v-on="inputEvents.end"
            />
            -->
        </template>
    </DatePicker>
</template>
