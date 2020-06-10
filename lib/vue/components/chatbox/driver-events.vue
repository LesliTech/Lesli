<script>
export default {
    props: {
        data: {}
    },
    data() {
        return {
            events: []
        }
    },
    mounted() {
        this.http.get("driver/calendars/default.json").then(result => {
            this.events =  result.data.focus_tasks
        })
    }
}
</script>
<template>
   <ul>
       <li v-for="event in events" :key="event.id">
           {{ event.title }} due {{ event.end }}
       </li>
   </ul>
</template>
