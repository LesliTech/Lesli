<script>
export default {
    
}
</script>
<template>
    <div class="today">
        <p class="day">19</p>
        <p class="month">august</p>
    </div>
</template>
<style lang="css" scoped>

    .today {
        display: flex;
        flex-direction: column;
        justify-content: center;
        padding: 1rem 0 1.5rem;
        border-radius: 5px;
        text-align: center;
        background: #e66b6b;
        color: #fff;
    }

    .day {
        line-height: 1;
        font-size: 4rem;
        font-weight: 900;
    }

    .month {
        line-height: 1;
        font-size: 2.8rem;
        text-transform: lowercase;
    }

</style>
