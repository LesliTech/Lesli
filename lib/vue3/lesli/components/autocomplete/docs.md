# Autocomplete

The component lesli autocomplete is registered globally and is meant to be used in all the vue apps as lesli-autocomplete.

## Props and emited functions

**@select(item)** 
Function executed every time we select an item, clicking or with the keyboard keys

**@selectBy**
Function to specify the item when the option item is a hash, this function receive an entire item and must return the element of the hash used to filter the items in the autocomplete.

**:placeholder**
String to show as placeholder for autocomplete input

**:options**
Array with the options available in the select

<br><br>

**Simple usage:**

```vue
<lesli-autocomplete
    placeholder="Start writing..."
    :items="['One','Onee','Oneee']">
</lesli-autocomplete>
```

**Result:**

```raw
<lesli-autocomplete
    placeholder="Start writing..."
    :items="['One','Onee','Oneee']">
</lesli-autocomplete>
```

<br><br>

**Use the autocomplete with a hash**

```vue
<lesli-autocomplete
    placeholder="Start writing..."
    :items="[{
            id: 1,
            first_name: 'Luis',
            last_name: 'Donis',
            email: 'hello@lesli.tech',
            ip_address: '000.000.00.00',
        },
        {
            id: 2,
            first_name: 'Luis',
            last_name: 'Donis',
            email: 'hello@lesli.cloud',
            ip_address: '000.000.00.00',
    }]"
    :selectBy="item => item.email">
</lesli-autocomplete>
```

**Result:**

```raw
<lesli-autocomplete
    placeholder="Start writing..."
    :items="[{
            id: 1,
            first_name: 'Luis',
            last_name: 'Donis',
            email: 'hello@lesli.tech',
            ip_address: '000.000.00.00',
        },
        {
            id: 2,
            first_name: 'Luis',
            last_name: 'Donis',
            email: 'hello@lesli.cloud',
            ip_address: '000.000.00.00',
    }]"
    v-model="t"
    @select="select"
    :selectBy="item => item.email">
</lesli-autocomplete>
```
