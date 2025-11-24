# Rails router
The Rails router is defined in the ´config/routes.rb´ file of your Rails application. This file contains a set of routing rules that determine how URLs should be processed by the application. 

Each route specifies an HTTP verb (e.g., GET, POST, PUT, DELETE) and a URL pattern (or path) along with the controller and action that should handle the request. 

The Rails router takes care of parsing the incoming URLs, matching them against the defined routes in the config/routes.rb file, and dispatching the request to the appropriate controller and action, based on the HTTP verb and URL pattern. 

By configuring routes in the config/routes.rb file, you can define how different parts of your application respond to user requests and create the structure of your web application.

Lesli uses a standard and well structure pattern to load routes to make engines functionality available


## Mounting Lesli engines

You can mount Lesli engines just as any other Rails engine, just have in mind that the Lesli core gem is always required.

```ruby

# Your Rails_App/config/routes.rb

Rails.application.routes.draw do

    # loading a welcome page from the core :)
    root to: "lesli/abouts#welcome", as: :welcome

    # Lesli core gem is required
    mount Lesli::Engine => "/lesli"

    # Mount Rails engines
    mount LesliBell::Engine => "/bell"
    mount LesliAdmin::Engine => "/admin"
    mount LesliAudit::Engine => "/audit"
    mount LesliBabel::Engine => "/babel"
    mount LesliMailer::Engine => "/mailer"
    mount LesliShield::Engine => "/shield"
    mount LesliPapers::Engine => "/papers"
    mount LesliSupport::Engine => "/support"
    mount LesliSecurity::Engine => "/security"
    mount LesliCalendar::Engine => "/calendar"
    mount LesliDashboard::Engine => "/dashboard"
end
```

Lesli comes with a helper router class so you dont need to load Lesli engines manually, this helper is going to search for installed Lesli engines and is going to mount them automatically. 

> IMPORTANT: By default this helper is going to used pre-defined route paths to mount the Lesli engines, if you want/need to use different path you must mount every engine manually. 

```ruby
Rails.application.routes.draw do
    Lesli::Router.mount
end
```

## Mounting Devise 

Lesli comes with its own implementation of devise through the `LesliShield` engine, the recommended way to mount this engine and devise is using the short cut `Lesli::Router.mount`, however you can customize the engine loading it manually


**Mount engine manually**

```ruby
Rails.application.routes.draw do

    # Load dedicated mounting routes for devise from the LesliShield engine
    LesliShield::Router.mount_login_at()
end
```

By default this short cut is going to mount the login paths at root level, example:

```
https://demo.lesli.dev/login
https://demo.lesli.dev/logout
https://demo.lesli.dev/register
https://demo.lesli.dev/password
https://demo.lesli.dev/confirmation
```

You can customize the path using the helper:

```ruby
Rails.application.routes.draw do
    LesliShield::Router.mount_login_at("my-users")
end
```

Result:

```
https://demo.lesli.dev/my-users/login
https://demo.lesli.dev/my-users/logout
https://demo.lesli.dev/my-users/register
https://demo.lesli.dev/my-users/password
https://demo.lesli.dev/my-users/confirmation
```

**Mounting Devise manually**

It is possible to mount Devise manually if you need full control over the implementation, at low level Lesli works as standard Rails engines, so you can override all the defaults or you can just avoid using the wrapper helpers to have full access to all Rails/Ruby gems and tools used to build Lesli.

```ruby
# mount devise manually
Rails.application.routes.draw do
    devise_for :users, class_name: "Lesli::User", module: :devise,
    :path => "",
    :path_names => {
        :sign_in  => "login",
        :sign_out => "logout",
        :sign_up  => "register",
        :password => "password",
        :confirmation => "confirmation"
    },
    :controllers => {
        :registrations => "users/registrations",
        :confirmations => "users/confirmations",
        :passwords => "users/passwords",
        :sessions => "users/sessions"
    }
end
```

