# Header

The component lesli input tag is registered globally and is meant to be used in all the vue apps as input tag

**Example:**

options should be a object with the following properties:
```
    const myOptions = [
        {
            id: 1,
            name: 'tag 1',
        },
        {
            id: 2,
            name: 'tag 2',
        },
        {
            id: 3,
            name: 'tag 3',
        }
    ]
```

v-model should be an array with the tags and each tag should be an object with the following properties:

```
    const myTags = [
        {
            id: 1,
            name: 'tag 1',
        },
        {
            id: 2,
            name: 'tag 2',
        },
    ]
```


```html
<lesli-input-tag 
    placeholder="Enter a category..." 
    :options="myOptions" 
    v-model="myTags">
</lesli-input-tag>
```
