<script>
export default {
    data() {
        return {
            text: "",
            show: false,
            timer: null
        }
    },
    mounted() {
        this.initListeners()
    },
    methods: {
        initListeners() {
            this.bus.subscribe("search:/core/layouts/component-global-search", text =>{
                this.text = text
            })
        }
    },
    watch: {
        text() {
            if (this.text == "") {
                this.show = false
                return 
            }
            clearTimeout(this.timer)
            this.timer = setTimeout(() => {
                this.show = true
                console.log(this.text)    
            }, 800);
        }
    }
}
</script>
<template>
    <section v-if="show" class="application-global-search">
        <div class="content">
            <h4>Projects</h4>
            
        </div>
    </section>
</template>
