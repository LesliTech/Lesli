<script>
export default {

}
</script>
<template>
    <nav class="sidenav">
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
