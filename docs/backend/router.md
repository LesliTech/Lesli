---
aside: false
---

# Rails router
The Rails router is defined in the ´config/routes.rb´ file of your Rails application. This file contains a set of routing rules that determine how URLs should be processed by the application. Each route specifies an HTTP verb (e.g., GET, POST, PUT, DELETE) and a URL pattern (or path) along with the controller and action that should handle the request.

The Rails router takes care of parsing the incoming URLs, matching them against the defined routes in the config/routes.rb file, and dispatching the request to the appropriate controller and action, based on the HTTP verb and URL pattern.

By configuring routes in the config/routes.rb file, you can define how different parts of your application respond to user requests and create the structure of your web application.



## Router for standard engines
Standard routes for CRUD operations

```ruby
resources :notebooks, only: [:index, :show, :edit, :update, :new, :create, :destroy] do
# GET       /notebooks(.:format)                              cloud_text/notebooks#index
# POST      /notebooks(.:format)                              cloud_text/notebooks#create
# GET       /notebooks/new(.:format)                          cloud_text/notebooks#new
# GET       /notebooks/:id/edit(.:format)                     cloud_text/notebooks#edit
# GET       /notebooks/:id(.:format)                          cloud_text/notebooks#show
# PUT       /notebooks/:id(.:format)                          cloud_text/notebooks#update
# DELETE    /notebooks/:id(.:format)                          cloud_text/notebooks#destroy


    # resources for cloud objects implementation
    scope module: :notebook do

        resources :files,       only: [:index, :get, :create, :update, :destroy]
        # GET    /notebooks/:notebook_id/files(.:format)           cloud_text/notebook/files#index
        # POST   /notebooks/:notebook_id/files(.:format)           cloud_text/notebook/files#create
        # PATCH  /notebooks/:notebook_id/files/:id(.:format)       cloud_text/notebook/files#update
        # PUT    /notebooks/:notebook_id/files/:id(.:format)       cloud_text/notebook/files#update
        # DELETE /notebooks/:notebook_id/files/:id(.:format)       cloud_text/notebook/files#destroy


        resources :actions,     only: [:index, :get, :create, :update, :destroy]
        # GET    /notebooks/:notebook_id/actions(.:format)         cloud_text/notebook/actions#index
        # POST   /notebooks/:notebook_id/actions(.:format)         cloud_text/notebook/actions#create
        # PATCH  /notebooks/:notebook_id/actions/:id(.:format)     cloud_text/notebook/actions#update
        # PUT    /notebooks/:notebook_id/actions/:id(.:format)     cloud_text/notebook/actions#update
        # DELETE /notebooks/:notebook_id/actions/:id(.:format)     cloud_text/notebook/actions#destroy


        resources :activities,  only: [:index, :get, :create, :update, :destroy]
        # GET    /notebooks/:notebook_id/activities(.:format)      cloud_text/notebook/activities#index
        # POST   /notebooks/:notebook_id/activities(.:format)      cloud_text/notebook/activities#create
        # PATCH  /notebooks/:notebook_id/activities/:id(.:format)  cloud_text/notebook/activities#update
        # PUT    /notebooks/:notebook_id/activities/:id(.:format)  cloud_text/notebook/activities#update
        # DELETE /notebooks/:notebook_id/activities/:id(.:format)  cloud_text/notebook/activities#destroy


        resources :discussions, only: [:index, :get, :create, :update, :destroy]
        # GET    /notebooks/:notebook_id/discussions(.:format)     cloud_text/notebook/discussions#index
        # POST   /notebooks/:notebook_id/discussions(.:format)     cloud_text/notebook/discussions#create
        # PATCH  /notebooks/:notebook_id/discussions/:id(.:format) cloud_text/notebook/discussions#update
        # PUT    /notebooks/:notebook_id/discussions/:id(.:format) cloud_text/notebook/discussions#update
        # DELETE /notebooks/:notebook_id/discussions/:id(.:format) cloud_text/notebook/discussions#destroy


        resources :subscribers, only: [:index, :get, :create, :update, :destroy]
        # GET    /notebooks/:notebook_id/subscribers(.:format)      cloud_text/notebook/subscribers#index
        # POST   /notebooks/:notebook_id/subscribers(.:format)      cloud_text/notebook/subscribers#create
        # PATCH  /notebooks/:notebook_id/subscribers/:id(.:format)  cloud_text/notebook/subscribers#update
        # PUT    /notebooks/:notebook_id/subscribers/:id(.:format)  cloud_text/notebook/subscribers#update
        # DELETE /notebooks/:notebook_id/subscribers/:id(.:format)  cloud_text/notebook/subscribers#destroy

        # ANY OTHER RESOURCE THAT BELONGS TO NOTEBOOKS

    end

    # Adicional methods that belongs to an specific resource
    member do

        get  :aditional_action_get
        # GET    /notebooks/:id/aditional_action_get(.:format)   cloud_text/notebooks#aditional_action_get

        post :aditional_action_post
        # POST   /notebooks/:id/aditional_action_post(.:format)  cloud_text/notebooks#aditional_action_post

    end

    # Aditional mehtods to extended resource controller scope
    collection do

        get  :list
        # GET    /notebooks/list(.:format)       cloud_text/notebooks#list

        get  :options
        # GET    /notebooks/options(.:format)    cloud_text/notebooks#options

        post :search
        # POST   /notebooks/search(.:format)     cloud_text/notebooks#search

    end
end
```



## Router for builder engines
Builder engines are capable of modifying core routes through a special `routes.rb` file located at the root of the builder engine folder. This unique routes file is loaded at the very beginning of the Rails app, giving each defined route priority in the Rails routes definition.

```ruby
module RoutesEngine
    def self.extended(router)
        router.instance_exec do

            # Builder engines require manual mounting, which offers the advantage of being able to mount the 
            # builder just like any other standard engine or at the root of the app. This flexibility allows 
            # us to create custom software using the builder engine and present it to users as the main module 
            # of the app.

            # Remember to be cautious with route aliases, as Rails does not allow overriding aliases that 
            # already exist in the entire routes collection.

            # self-mount builder engine at root path
            mount LesliCloud::Engine => "/"

            # self-mount builder engine with a path
            mount LesliCloud::Engine => "/crm"


            # Builder engines are able to customize the behavior of the routes for authenticated and anonymous users

            # after login routes
            authenticated :user do
                
                # override default root path
                get "dashboard", to: "lesli_cloud/dashboards#show"
                
            end

            # public routes
            unauthenticated :user do 

                # override public root path with a redirection
                root to: redirect("/login"), as: :root_lesli_unauthenticated

                # override public root path with a custom page
                root to: "lesli_cloud/websites#landing", as: :root_lesli_unauthenticated

            end
        end
    end
end
```
