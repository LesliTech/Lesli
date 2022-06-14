# NavigationItem

This component act as an extension for the sidebar navigation, allowing to created a group of items inside a collapse component, so we can have better navigation links organization.

## Props and emited functions
**:name**
Name of the list, this must be translated

**:icon**
Prints an icon from the Lesli family icons

**:rmi**
Prints an icon from the Remix family icons

## Rails helpers
This component works perfectly with the "navigation_lesli_item" Rails helper

**Example with rails helpers:**

```html
<!-- navigation list container -->
<lesli-navigation-list name="Team">

    <!-- simple navigation item withou icon -->
    <%= navigation_lesli_item(main_app.users_path, "Dashboard") %>

    <!-- navigation item with Lesli icon -->
    <%= navigation_lesli_item(main_app.users_path, "Dashboard", "dashboard"); %>

    <!-- navigation item with remix icon -->
    <%= navigation_lesli_item(main_app.users_path, "Dashboard", :rmi => "ri-pencil-ruler-2-line"); %>

</lesli-navigation-list>
```

**Example wih plain html:**

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
<lesli-navigation-list label="Dashboard" rmi="ri-pencil-ruler-2-line">
    <%= navigation_lesli_item(main_app.users_path, "Dashboard", "dashboard"); %>
    <%= navigation_lesli_item(main_app.users_path, "Design system", :rmi => "ri-pencil-ruler-2-line") %>
    <%= navigation_lesli_item(main_app.users_path, "Settings") %>
</lesli-navigation-list>
```


**Complete example**
```html
<%= navigation_lesli_item(main_app.users_path, "Dashboard", "dashboard"); %>
<%= navigation_lesli_item(main_app.users_path, "Design system", :rmi => "ri-pencil-ruler-2-line") %>
<%= navigation_lesli_item(main_app.users_path, "Settings") %>

<lesli-navigation-list label="Dashboard" rmi="ri-pencil-ruler-2-line">
    <%= navigation_lesli_item(main_app.users_path, "Dashboard", "dashboard"); %>
    <%= navigation_lesli_item(main_app.users_path, "Design system", :rmi => "ri-pencil-ruler-2-line") %>
    <%= navigation_lesli_item(main_app.users_path, "Settings") %>
</lesli-navigation-list>
```
