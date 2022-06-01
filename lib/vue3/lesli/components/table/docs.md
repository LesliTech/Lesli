# Table

The table component globally and is meant to be used in together with the vue store, this component works in conjunction with pagination, loading and empty components. The state is meant to be managed by the vue stores.

## Props and emited functions

**@sort(column, order)** 
Function executed every time the user click on the header of the table to sort by column

- column: (string) name of the column selected for sorting 
- order: (string) order direction ['desc'|'asc'] 

**@paginate(page)**
Function executed every time the user clicks on pagination buttons, this function receive the page the user requested for.

**:pagination**
Prop that contain the pagination structure, this is the same returned by "response_with_pagination"

**:loading**
Prop that indicates if the store is working or requesting the data

**:columns**
Prop that defines the columns to be rendered into the table, the columns will be showned in the order defined in this array.

- field: (String) the name of the column
- label: (String) the label of the column for the user
- order: (Boolean) enable/disable sorting the data by this column  

**:records**
Array with the data to be rendered within the table

**Example:**

```html
<lesli-table
    @sort="store.sort"
    @paginate="store.paginate"
    :pagination="store.pagination"
    :loading="store.loading"
    :columns="columns"
    :records="store.records">
</lesli-table>
```

<br>

**Example of a simple table that shows a list of ids and emails:**

```html
<lesli-table
    :columns="[{field: 'id', label: 'ID'},{field: 'email', label: 'Email'}]"
    :records="[{id:0,email:'ldonis@lomax.com.gt'},{id:0,email:'ldonis@gmail.com'},{id:0,email:'emc2@ldonis.com'}]">
</lesli-table>
```

**Result:**

```raw
<lesli-table
    :columns="[{field: 'id', label: 'ID'},{field: 'email', label: 'Email'}]"
    :records="[{id:0,email:'ldonis@lomax.com.gt'},{id:0,email:'ldonis@gmail.com'},{id:0,email:'emc2@ldonis.com'}]">
</lesli-table>
```

<br>

**Example of a simple table that is waiting for the store to complete the data request:**

```html
<lesli-table
    :loading="true"
    :columns="[]"
    :records="[]">
</lesli-table>
```

**Result:**

```raw
<lesli-table
    :loading="true"
    :columns="[{field: 'id', label: 'ID'},{field: 'email', label: 'Email'}]"
    :records="[]">
</lesli-table>
```
