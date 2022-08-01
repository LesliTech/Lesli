# Avatar

The component lesli avatar is registered globally and is meant to be used in all the vue apps as lesli-avatar

## Props

**:letter**
This prop is used to define the letter that will be used to show in the avatar. It is required because it is the only way to show a letter by default if the user doesn't provide a url.
- **type**: String
- **required**: true

**:url-image**
This prop is used to define the url of the image that will be used to show in the avatar.
- **type**: String
- **required**: false
- **default**: null

**:size**
This prop is used to define the size of the avatar. It can be a number of pixels.
- **type**: Number
- **required**: false
- **default**: 50

**:font-size**
This prop is used to define the font size of the letter. It can be 1, 2, 3, 4, 5 or 6.
- **type**: Number
- **required**: false
- **default**: 4

## Events
No events are defined for this component.

## Slots
No slots are defined for this component.

## Example 1

The letter is requerided to be used in the component.

```html
<lesli-avatar 
    letter="A" 
    url-image="https://www.example.com/image.jpg" 
    :size="170" 
    :font-size="1"
/>
```

## Example 2

If url image is not defined, the component will use the letter as the image.

```html
<lesli-avatar 
    letter="A" 
    :size="170" 
    :font-size="1"
/>
```
