# Assets helper

## lesli\_stylesheet\_path

Return a string path to load the template stylesheet by default we always return the latest version of the template

**params:**

- engine:string (optional): The **Rails engine name** (e.g., `:lesli`) to scope the asset search. 
- stylesheet:string (optional|default:application): Name of stylesheet to load. 

**returns:** string: The full public path to the specified stylesheet (e.g., `/assets/application.css`).


### Usage

Get path to main application stylesheet from main app

```ruby
lesli_stylesheet_path() 
```

**Result:** `/assets/application.css`

<br />

Get path to main application stylesheet from an engine

```ruby
lesli_stylesheet_path(:lesli) 
```

**Result:** `/assets/lesli/application.css`

<br />

Get specific stylesheet from engine

```ruby
lesli_stylesheet_path(:lesli_assets, 'templates/application')
```

**Result:** `/assets/lesli_assets/templates/application.css`
