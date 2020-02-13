<script>

import dayjs from 'dayjs'

export default {
    props: {
        data: {}
    },
    data() {
        return {
            message: ""
        }
    },
    mounted() {
        this.postAttendance()
    },
    methods: {

        postAttendance() {
            this.message = "sending attendance entry..."
            this.http.post("/team/attendances", {
                attendance: {
                    detail_attributes: {
                        description: "day closed! - attendance entry saved from chatbot",
                        end: dayjs(),
                        start: dayjs()
                    }
                }
            }).then(result => {
                console.log(result)
                this.message= "record saved!"
            }).catch(error =>{
                console.log(error)
            })
        }

    }
}
</script>
<template>
    <div class="chat-response">
        <p>{{ message }}</p>
    </div>
</template>
