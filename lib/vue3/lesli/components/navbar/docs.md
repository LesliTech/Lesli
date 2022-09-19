# Navbar
The component lesli navbar isn't registered globally. For this reason, you have to import it in your app.js file that loads the vue app.

## Props

**:start-links**
The links in the start of the toggle. This is an array of objects.
- **type**: Array
- **required**: true

**:end-links**
The links in the end of the toggle. This is an array of objects.
- **type**: Array
- **required**: false

**:brand**
The brand of the toggle. This is an object. With url, image and name of the brand.
- **type**: Object
- **required**: true

## Events
No events are defined for this component.

## Slots
No slots are defined for this component.

## Example
```html
<lesli-navbar
    :brand="{
        url: '/',
        image: '/assets/mitwerken_cloud/website/logos/mitwerken-logo-blue.svg',
        name: 'Mitwerken logo',
    }"
    :start-links="[
        {
            url: '/app/projects',
            name: 'Projekte',
        },
        {
            url: '/app/profile/projects',
            name: 'Meine Projekte',
        },
        {
            url: '/app/projects/new',
            name: 'Neues Projekt',
        },
        {
            url: '/app/chatrooms?type=general',
            name: 'Chatraum',
        },
    ]"
    :end-links="[
        {
            url: '/logout',
            name: 'Logout',
            reload: true,
        }
    ]"
>
</lesli-navbar>
```
