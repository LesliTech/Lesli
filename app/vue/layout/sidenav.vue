<script>
export default {

    data() {
        return {
            show:false
        }
    },

    mounted() {
        this.bus.$on('lesli.layout.sidenav.show', this.showMenu)
    },

    methods: {

        showMenu() {

            this.show = !this.show
            setTimeout(() => this.show = false, 4000)

        }

    }

}
</script>
<template>
    <nav :class="['sidenav', { 'show':show }]">
        <ul>
            <li v-for="(a,i) in [1,2,3,4,5,6,7,8,9,1,2,3,4,5,6]" :key="i">
                <a href="">
                    <img src="https://cdn.lesli.tech/leslicloud/chaos/chaos.svg" alt="">
                    chaos
                </a>
            </li>
        </ul>
    </nav>
</template>
