# File Uploader

The component lesli gallery is registered globally and is meant to be used in all the vue apps as lesli-gallery

## Props

**:images**
prop that indicates the images that will be displayed in the gallery.
- **type**: Array
- **required**: true

## Events
**@delete**
Eevent that emits the image that user wants to delete when the user clicks on the delete button.
- **emits**: Image

## Slots
No slots are defined for this component.

## Example 1

If you want to display a gallery with the images that are in the images array, you can use the following code:

```javascript

    // this method will be called when user clicks on the file delete button
    const onDeleteFile = (image) => {
        console.log(image) // { id: 1, name: 'image1.jpg', url: 'https://images.com/photo-1.jpg' }
    }
```


```html
<lesli-gallery 
    @delete="onDeleteImage"
    :images="[
        { 
            id: 1,
            name: 'image1',
            url: 'https://images.com/photo-1.jpg'
        },
        { 
            id: 2,
            name: 'image2',
            url: 'https://images.com/photo-2.jpg'
        },
    ]"
>
</lesli-gallery>
```
