# Input tag

The component lesli input tag is registered globally and is meant to be used in all the vue apps as input tag

## Props

**:placeholder**
prop that contains the placeholder for the input tag
- **type**: String
- **required**: false
- **default**: "Select..."

**:options**
prop that contains the options for the input tag
- **type**: Array of objects
- **required**: true

**:filteredFields**
prop that indicates which fields to be filtered
- **type**: Array of strings
- **required**: true

**:showField**
prop that indicates which field to show as suggested by the input tag
- **type**: String
- **required**: true


**Example:**

options should be a object with the following properties:
```javascript
    const myOptions = [
        {
            id: 1,
            name: 'tag 1',
            email: "example1@email.com"
        },
        {
            id: 2,
            name: 'tag 2',
            email: "example2@email.com"
        },
        {
            id: 3,
            name: 'tag 3',
            email: "example3@email.com"
        }
    ]
```

v-model should be an array of objects:

```javascript
    const myTags = [
        {
            id: 1,
            name: 'tag 1',
            email: "example1@example.com"
        },
        {
            id: 2,
            name: 'tag 2',
            email: "example2@example.com"
        },
    ]
```


```html
<lesli-input-tag 
    v-model="myTags"
    placeholder="Enter a category..." 
    :options="myOptions"
    :filter-fields="['name', 'email']"
    show-field="name">
</lesli-input-tag>
```
