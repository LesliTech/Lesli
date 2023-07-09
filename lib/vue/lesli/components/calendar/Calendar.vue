<script setup>
/*

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

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
    mode: {
        type: String,
        default: 'date',
    },
    range: {
        type: Boolean,
        required: false,
        default: false
    },
    minDate: {
        type: [Date, Object]
    },
    required: {
        type: Boolean,
        required: false,
        default: false
    },
    placeholderValue: {
        type: String,
    }
})


// ·
const date = props.modelValue ? ref(props.modelValue) : ref(new Date())


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
    <DatePicker v-if="!range" v-model="date" :mode="mode" class="lesli-calendar" :min-date="props.minDate" :is-required="props.required" >
        <template v-slot="{ inputValue, inputEvents }">
            <input
                class="input is-default"
                v-on="inputEvents"
                :value="placeholderValue ? placeholderValue : inputValue"
            />
            <span class="icons is-small">
                <span class="material-icons">
                    date_range
                </span>
            </span>
        </template>
    </DatePicker>

    <DatePicker v-if="range" v-model="dateRange" is-range >
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
