# Vue component for charts  
Vue global state management built on top of observables

Examples:

```html
<component-chart-general 
    type="bar"
    :data-sources="[{
        name: 'numeros',
        data: [1,2,3,4]
    }]"
    :data-labels="['uno', 'dos', 'tres', 'cuatro']">
</component-chart-general>

<component-chart-line 
    :data-sources="[{
        name: 'numeros',
        data: [1,2,6,3]
    }, {
        name: 'numeros',
        data: [2,6,3,10]
    }]"
    :data-labels="['uno', 'dos', 'tres', 'cuatro']">
</component-chart-line>

<component-chart-bar 
    :data-sources="[{
        name: 'numeros',
        data: [1,2,3,4]
    }]"
    :data-labels="['uno', 'dos', 'tres', 'cuatro']">
</component-chart-bar>

<component-chart-line 
    :data-sources="[{
        name: 'numeros',
        data: [1,2,6,3]
    }]"
    :data-labels="['uno', 'dos', 'tres', 'cuatro']"
    :options="{ stroke: { curve: 'smooth' } }">
</component-chart-line>

```
