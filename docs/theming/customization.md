# Customization

The Lesli gem offers a seamless customization experience through an initialization file. By editing this file, you can tailor colors to create a unique and personalized theme for your Rails application.


## Color customization 
Inside our initialization file, you'll discover a dedicated section for customizing the color scheme. Simply edit the color values associated with different elements like primary color, sidebar, header, footer, background, and even hover effects.

See the example below

```ruby 
Lesli.configure do |config|

    # Main color palette for Lesli
    config.theme = {
        color_primary: "#193d8d",
        color_sidebar: "#ffffff",
        color_header: "transparent",
        color_footer: "transparent",
        color_background: "#eef2f6",
        color_sidebar_hover: "#dee7ec"
    }
end
```

<br>

This is going to modify the corresponding SASS variables in the Lesli core:

```
$primary (bulma) -> color_primary 
$lesli-color-primary -> color_primary 
$lesli-header-color -> color_header 
$lesli-footer-color -> color_footer 
$lesli-sidebar-color -> color_sidebar 
$lesli-sidebar-hover -> color_sidebar_hover 
$lesli-color-background -> color_background 
```

Lesli provide the same color palette as CSS variables:

```scss
:root {
    --lesli-color-primary: var(--lesli-theme-color-primary, #{$lesli-color-primary});    
    --lesli-header-color: var(--lesli-theme-header-color, #{$lesli-header-color});
    --lesli-navbar-color: var(--lesli-theme-header-color, #{$lesli-navbar-color});    
    --lesli-footer-color: var(--lesli-theme-footer-color, #{$lesli-footer-color});
    --lesli-sidebar-color: var(--lesli-theme-sidebar-color, #{$lesli-sidebar-color});
    --lesli-logo-color: var(--lesli-theme-logo-color, #{$lesli-logo-color});
    --lesli-font-color: var(--lesli-theme-font-color, #{$lesli-font-color});
}
```

> You can modify the CSS variables at runtime, so your users can modify the theme.

## Bulma customization 
You can customize bulma changing the value of the variables, see: [https://bulma.io/documentation/customize/variables/](https://bulma.io/documentation/customize/variables/)
