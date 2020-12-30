# Rails router



## Builder routes
Routes specification for builder engine routes file

```ruby
module RoutesEngine
    def self.extended(router)
        router.instance_exec do

            # after login routes
            authenticated :user do
                
                # self-mount builder engine at root path
                mount LesliCloud::Engine => "/"

                # self-mount builder engine with a path
                mount LesliCloud::Engine => "/crm"

                # override default root path
                get "dashboard", to: "lesli_cloud/dashboards#show"
                
            end

            # public routes
            unauthenticated :user do 

                # override public root path with a redirection
                root to: redirect("/login"), as: :root_lesli_app_unauthenticated

                # override public root path with a custom page
                root to: "lesli_cloud/websites#landing", as: :root_lesli_app_unauthenticated

            end

        end
    end
end
```



## App routes
Standard routes for CRUD operations

```ruby
resources :notebooks, only: [:index, :show, :edit, :update, :new, :create] do
# GET    /notebooks(.:format)                              cloud_text/notebooks#index
# POST   /notebooks(.:format)                              cloud_text/notebooks#create
# GET    /notebooks/new(.:format)                          cloud_text/notebooks#new
# GET    /notebooks/:id/edit(.:format)                     cloud_text/notebooks#edit
# GET    /notebooks/:id(.:format)                          cloud_text/notebooks#show
# PATCH  /notebooks/:id(.:format)                          cloud_text/notebooks#update
# PUT    /notebooks/:id(.:format)                          cloud_text/notebooks#update


    # resource cloud objects
    scope module: :notebook do

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


        resources :files,       only: [:index, :get, :create, :update, :destroy]
        # GET    /notebooks/:notebook_id/files(.:format)           cloud_text/notebook/files#index
        # POST   /notebooks/:notebook_id/files(.:format)           cloud_text/notebook/files#create
        # PATCH  /notebooks/:notebook_id/files/:id(.:format)       cloud_text/notebook/files#update
        # PUT    /notebooks/:notebook_id/files/:id(.:format)       cloud_text/notebook/files#update
        # DELETE /notebooks/:notebook_id/files/:id(.:format)       cloud_text/notebook/files#destroy


        resources :subscribers, only: [:index, :get, :create, :update, :destroy]
        # GET    /notebooks/:notebook_id/subscribers(.:format)      cloud_text/notebook/subscribers#index
        # POST   /notebooks/:notebook_id/subscribers(.:format)      cloud_text/notebook/subscribers#create
        # PATCH  /notebooks/:notebook_id/subscribers/:id(.:format)  cloud_text/notebook/subscribers#update
        # PUT    /notebooks/:notebook_id/subscribers/:id(.:format)  cloud_text/notebook/subscribers#update
        # DELETE /notebooks/:notebook_id/subscribers/:id(.:format)  cloud_text/notebook/subscribers#destroy

    end

    # extended resource methods
    collection do

        get  :list
        get  :options
        post :search

        # GET    /notebooks/list(.:format)       cloud_text/notebooks#list
        # GET    /notebooks/options(.:format)    cloud_text/notebooks#options
        # POST   /notebooks/search(.:format)     cloud_text/notebooks#search

    end

    # extend resource actions
    member do
        scope :resources do

            get  :aditional_action_get
            post :aditional_action_post

            # GET    /notebooks/:id/resources/aditional_action_get(.:format)   cloud_text/notebooks#aditional_action_get
            # POST   /notebooks/:id/resources/aditional_action_post(.:format)  cloud_text/notebooks#aditional_action_post

        end
    end

end
```
