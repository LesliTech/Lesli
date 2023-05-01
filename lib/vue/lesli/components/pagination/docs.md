# Pagination
This component allows you to navigate between the pages of the records that contain a response with pagination.

**:pagination**
Prop that contain the pagination structure, this is the same returned by "response_with_pagination".

**:simple-mode**
Prop that allows to show simple pagination, only prev and next buttons.

**@paginate(page)**
Function executed every time the user clicks on pagination buttons, this function receive the page the user requested for.

**Example of a simple use of pagination:**

```html
<lesli-pagination
    :pagination="store.pagination"
    @paginate="store.paginate"
>
</lesli-pagination>
```

**Example of a simple use of pagination with simple mode:**

```html
<lesli-pagination
    :pagination="store.pagination"
    @paginate="store.paginate"
    mode="simple"
>
</lesli-pagination>
```

