# Dropdown

The component lesli dropdown is registered globally and is meant to be used in all the vue apps as lesli-dropdown. The difference between this component and the lesli-select component is that lesli-dropdown is used to display a list of options in a view and the design is similar to the button.

## Props

**:options**
This prop is used to define the array of options to be displayed in the dropdown.
- **type**: Array
- **required**: true

**:label**
This prop is used to define the label of the dropdown.
- **type**: String
- **required**: false
- **default**: 'Select'

## Events
No events are defined for this component.

## Slots
No slots are defined for this component.

## Example

V-model is required to be used in the component. Icon property is optional and is used to display an icon in the dropdown's options.


```html
<lesli-dropdown 
    :options="[
        { label: 'A', value: 'a', icon: 'add' }, 
        { label: 'B', value: 'b' }, 
        { label: 'C', value: 'c', icon: 'chat' }
    ]" 
    label="Change status" 
    v-model="dropdownValue"
/>
```

```raw
<lesli-dropdown
    v-model="dropdownValue"
    label="Change status"
    :options="[
        { label: 'A', value: 'a', icon: 'add' }, 
        { label: 'B', value: 'b' }, 
        { label: 'C', value: 'c', icon: 'chat' }
    ]"
>
</lesli-dropdown>
```
