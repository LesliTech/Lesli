# Select 

The component lesli select is registered globally and is meant to be used in all the vue apps as lesli-select. The difference between this component and the lesli-dropdown component is that lesli-select is used to display a list of options in a form.


```html
<lesli-select
    v-model="selection"
    icon="public"
    :options="[{
        label: 'Primera opcion',
        value: 'option_one'
    }, {
        label: 'Segunda opcion',
        value: 'option_two'
    }]">
</lesli-select>
```

```raw
<lesli-select
    v-model="selection"
    icon="public"
    :options="[{
        label: 'Primera opcion',
        value: 'option_one'
    }, {
        label: 'Segunda opcion',
        value: 'option_two'
    }]">
</lesli-select>
```
