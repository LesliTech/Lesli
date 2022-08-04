# Toggle

The component lesli toggle is registered globally and is meant to be used in all the vue apps as lesli-toggle. This component is used to create a toggle, and needs to be used like a input type checkbox.


## Props
No props are defined for this component.

## Events
No events are defined for this component.

## Slots
No slots are defined for this component.

## Example 1

v-model is required because it is the only way to control the state of the toggle.

```javascript
const isChecked = ref(false);
```

```html
<lesli-toggle v-model="isChecked"/>
```
