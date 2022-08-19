# Dropdown

The component lesli dropdown is registered globally and is meant to be used in all the vue apps as lesli-dropdown

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

## Example 1

V-model is required to be used in the component.

```html
<lesli-dropdown 
    :options="[{ label: 'A', value: 'a' }, { label: 'B', value: 'b' }, { label: 'C', value: 'c' }]" 
    label="Change status" 
    v-model="dropdownValue"
/>
```
