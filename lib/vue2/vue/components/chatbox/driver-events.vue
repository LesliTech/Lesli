<script>
export default {
    props: {
        data: {}
    },
    data() {
        return {
            events: {
                data: {}
            }
        }
    },
    mounted() {
        this.http.get("http://localhost:3000/driver/calendars/default.json?filters[include][driver_events]=true&filters[start_date]=2021-07-01T06:00:00.000Z&filters[end_date]=2021-07-31T05:59:59.000Z").then(result => {
            this.events =  result
        })
    }
}
</script>
<template>
    <div>
        <h3 class="is-size-3">Next events</h3>
        <ul>
            <li v-for="event in events.data.driver_events" :key="event.id">
                {{ event.title }} at {{ event.date }}
            </li>
        </ul>
    </div>
</template>
