<script>
export default {
    data() {
        return {
            index: 0,
            total: 0,
            announcement: {}
        }
    },
    mounted() {
        this.total = lesli.announcements.length
        setInterval(() => {
            this.announcement = lesli.announcements[this.index];
            this.index++;
            if (this.index >= this.total) {
                this.index = 0
            }
        }, 2000);
    }
}
</script>
<template>
    <section class="application-notices">
        <article 
            v-for="announcement in lesli.announcements" 
            :key="announcement.id"
            :class="['message', `is-${announcement.category}`]">
            <div class="message-header">
                <p>{{ announcement.name }}</p>
                <button :v-if="announcement.can_be_closed" class="delete" aria-label="delete"></button>
            </div>
            <div class="message-body" v-if="announcement.message" v-html="announcement.message.html">
            </div>
        </article>

        <article :class="['message', `is-${announcement.category}`]">
            <div class="message-header">
                <p>{{ announcement.name }}</p>
                <button :v-if="announcement.can_be_closed" class="delete" aria-label="delete"></button>
            </div>
            <div class="message-body" v-if="announcement.message" v-html="announcement.message.html">
            </div>
        </article>
    </section>
</template>
