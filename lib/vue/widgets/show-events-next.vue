<script>
export default {
    props: {
        component: Object
    }
}
</script>
<template>
    <div class="card">
        <div class="card-header">
            <h3 class="card-header-title">{{ component.name }}</h3>
        </div>
        <div class="card-content">
            <ul>
                <li>
                    <span class="icon is-medium">
                        <i class="fas fa-lg fa-bell"></i>
                    </span>
                    <span class="title">Cyber Week</span>
                    <p>27 March 2020, at 12:30 PM</p>
                </li>
                <li>
                    <span class="icon is-medium">
                        <i class="fas fa-lg fa-calendar"></i>
                    </span>
                    <span class="title">Cyber Week</span>
                    <p>27 March 2020, at 12:30 PM</p>
                </li>
            </ul>
        </div>
    </div>
</template>
<style lang="css" scoped>
    ul {
        padding-left: 1rem;
    }
    li {
        margin-bottom: 1rem;
    }
    .icon {
        float: left;
        color: #344767;
    }
    .title {
        font-size: 1rem;
        font-weight: 500;
        color: #344767;
    }
    p {
        color: #67748e;
        font-size: .9rem;
    }
</style>
