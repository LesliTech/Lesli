<script setup>
const palettes_variant = [100, 300, 500, 700, 900]
const palettes = [
    "silver", "blue", "lime", "mint", "banana", "orange", 
    "bubble", "berry", "grape", "cocoa", "slate", "black"
]
</script>

# Brand


## Logos

<div class="columns lesli-css-color-logos">
    <div class="column pt-4 pl-6 pb-5 has-background-grey-lighter">
        <h4 class="mb-2">Standard</h4>
        <img width="200" alt="Lesli Framework logo blue" src="/images/brand/lesli.svg" />
    </div>
    <div class="column pt-4 pl-6 pb-5 has-background-grey-darker">
        <h4 class="mb-2 has-text-white">Negative</h4>
        <img width="200" alt="Lesli Framework logo white" src="/images/brand/lesli-white.svg" />
    </div>
</div>


<hr />

## Icons

<div class="columns lesli-css-color-logos">
    <div class="column pt-4 px-6 pb-5 has-background-grey-lighter">
        <h4 class="mb-4">Standard</h4>
        <img width="180" class="m-auto" alt="Lesli Framework logo blue" src="/images/brand/lesli-icon.svg" />
    </div>
    <div class="column pt-4 px-6 pb-5 has-background-grey-darker">
        <h4 class="mb-4 has-text-white">Negative</h4>
        <img width="180" class="m-auto" alt="Lesli Framework logo white" src="/images/brand/lesli-icon-white.svg" />
    </div>
</div>

<hr />

## Lesli brand colors
<div class="columns lesli-css-brand-colors">
    <div class="column">
        <div class="has-text-centered py-6 has-text-white" style="background:#0d52bf;">
            LESLI BLUE <br> #0D52Bf
        </div>
    </div>
    <div class="column">
        <div class="has-text-centered py-6 has-text-white" style="background:#001f66;">
            DARK BLUE<br> #001F66
        </div>
    </div>
    <div class="column">
        <div class="has-text-centered py-6 has-text-info" style="background:#EBF1FF;">
            FADED BLUE <br> #EBF1FF
        </div>
    </div>
    <div class="column">
        <div class="has-text-centered py-6 has-text-white" style="background:#7E9BF1;">
            EASY BLUE <br> #7E9BF1
        </div>
    </div>
</div>

<hr />

## Collection colors
<div class="columns is-multiline lesli-css-color-collections">
    <div class="column"> 
        <div class="has-text-centered px-4 py-6 has-text-white bg-lesli-css-color-collection-administration">
            Administration
        </div>
    </div>
    <div class="column"> 
        <div class="has-text-centered px-4 py-6 has-text-white bg-lesli-css-color-collection-intelligence">
            Intelligence
        </div>
    </div>
    <div class="column">
        <div class="has-text-centered px-4 py-6 has-text-white bg-lesli-css-color-collection-productivity">
            Productivity
        </div>
    </div>
    <div class="column">
        <div class="has-text-centered px-4 py-6 has-text-black bg-lesli-css-color-collection-integration">
            Integration
        </div>
    </div>
    <div class="column">
        <div class="has-text-centered px-4 py-6 has-text-black bg-lesli-css-color-collection-analytics">
            Analytics
        </div>
    </div>
    <div class="column">
        <div class="has-text-centered px-4 py-6 has-text-black bg-lesli-css-color-collection-security">
            Security
        </div>
    </div>
    <div class="column">
        <div class="has-text-centered px-4 py-6 has-text-white bg-lesli-css-color-collection-finance">
            Finance
        </div>
    </div>
    <div class="column">
        <div class="has-text-centered px-4 py-6 has-text-white bg-lesli-css-color-collection-sales">
            Sales
        </div>
    </div>
    <div class="column">
        <div class="has-text-centered px-4 py-6 has-text-black bg-lesli-css-color-collection-it">
            IT
        </div>
    </div>
</div>

<hr />

## General colors

<div v-for="palette in palettes" class="columns lesli-css-colors">
    <div v-for="variant in palettes_variant" class="column">
        <div :class="'bg-lesli-css-color-'+palette+'-'+variant">
        </div>
        <p class="m-0 has-text-centered">
            {{ palette }} {{ variant }}
        </p>
    </div>
</div>

<style lang="scss">
    $border-radius: .4rem;
    $border-radius: .4rem;
    @import "lesli-css";
    @import "bulma/sass/grid/columns";
    @import "bulma/sass/helpers/color";
    @import "bulma/sass/helpers/spacing";
    @import "bulma/sass/helpers/typography";
    

    @include lesli-css-color-print(background, bg-lesli-css-color);

    .lesli-css-brand-colors .column div {
        border-radius: $border-radius;
    }

    .lesli-css-color-logos .column {
        &:first-child {
            border-radius: $border-radius 0 0 $border-radius;
        }
        &:last-child {
            border-radius: 0 $border-radius $border-radius 0;
        }
    }

    .lesli-css-color-collections .column div {
        border-radius: 6px;
        font-size: 1.1rem;
    }

    .lesli-css-colors .column div {
        border-radius: $border-radius;
        height: 3.2rem;
    }
</style>
