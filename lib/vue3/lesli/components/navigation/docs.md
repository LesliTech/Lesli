# NavigationItem

This component act as an extension for the sidebar navigation, allowing to created a group of items inside a collapse component, so we can have better navigation links organization.

## Props and emited functions
**:name**
Name of the list, this must be translated


```html
<lesli-navigation-list name="Team">
    <li>
        <a>
            <i class="ri-building-4-fill"></i>
            <span><%= I18n.t("core.shared.sidebar_nav_account") %></span>
        </a>
    </li>
</lesli-navigation-list>
```

<br>

**Example of a list of navigation items using the html helper:**

```html
<lesli-navigation-list name="Administration">
    <%= navigation_vue_item(main_app.root_administration_path) do %>
        <i class="ri-building-4-fill"></i>
        <span><%= I18n.t("core.shared.sidebar_nav_account") %></span>
    <% end %>
</lesli-navigation-list>
```

**Result:**

```raw
<lesli-table
    :columns="[{field: 'id', label: 'ID'},{field: 'email', label: 'Email'}]"
    :records="[{id:0,email:'ldonis@lomax.com.gt'},{id:0,email:'ldonis@gmail.com'},{id:0,email:'emc2@ldonis.com'}]">
</lesli-table>
```
