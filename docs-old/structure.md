
# GET    /notebooks(.:format)                                       cloud_text/notebooks#index
# POST   /notebooks(.:format)                                       cloud_text/notebooks#create
# GET    /notebooks/new(.:format)                                   cloud_text/notebooks#new
# GET    /notebooks/:id/edit(.:format)                              cloud_text/notebooks#edit
# GET    /notebooks/:id(.:format)                                   cloud_text/notebooks#show
# PATCH  /notebooks/:id(.:format)                                   cloud_text/notebooks#update
# PUT    /notebooks/:id(.:format)                                   cloud_text/notebooks#update
# GET    /notebooks/:notebook_id/actions(.:format)                  cloud_text/notebook/actions#index
# POST   /notebooks/:notebook_id/actions(.:format)                  cloud_text/notebook/actions#create
# PATCH  /notebooks/:notebook_id/actions/:id(.:format)              cloud_text/notebook/actions#update
# PUT    /notebooks/:notebook_id/actions/:id(.:format)              cloud_text/notebook/actions#update
# DELETE /notebooks/:notebook_id/actions/:id(.:format)              cloud_text/notebook/actions#destroy
# GET    /notebooks/:notebook_id/activities(.:format)               cloud_text/notebook/activities#index
# POST   /notebooks/:notebook_id/activities(.:format)               cloud_text/notebook/activities#create
# PATCH  /notebooks/:notebook_id/activities/:id(.:format)           cloud_text/notebook/activities#update
# PUT    /notebooks/:notebook_id/activities/:id(.:format)           cloud_text/notebook/activities#update
# DELETE /notebooks/:notebook_id/activities/:id(.:format)           cloud_text/notebook/activities#destroy
# GET    /notebooks/:notebook_id/discussions(.:format)              cloud_text/notebook/discussions#index
# POST   /notebooks/:notebook_id/discussions(.:format)              cloud_text/notebook/discussions#create
# PATCH  /notebooks/:notebook_id/discussions/:id(.:format)          cloud_text/notebook/discussions#update
# PUT    /notebooks/:notebook_id/discussions/:id(.:format)          cloud_text/notebook/discussions#update
# DELETE /notebooks/:notebook_id/discussions/:id(.:format)          cloud_text/notebook/discussions#destroy
# GET    /notebooks/:notebook_id/files(.:format)                    cloud_text/notebook/files#index
# POST   /notebooks/:notebook_id/files(.:format)                    cloud_text/notebook/files#create
# PATCH  /notebooks/:notebook_id/files/:id(.:format)                cloud_text/notebook/files#update
# PUT    /notebooks/:notebook_id/files/:id(.:format)                cloud_text/notebook/files#update
# DELETE /notebooks/:notebook_id/files/:id(.:format)                cloud_text/notebook/files#destroy
# GET    /notebooks/:notebook_id/subscribers(.:format)              cloud_text/notebook/subscribers#index
# POST   /notebooks/:notebook_id/subscribers(.:format)              cloud_text/notebook/subscribers#create
# PATCH  /notebooks/:notebook_id/subscribers/:id(.:format)          cloud_text/notebook/subscribers#update
# PUT    /notebooks/:notebook_id/subscribers/:id(.:format)          cloud_text/notebook/subscribers#update
# DELETE /notebooks/:notebook_id/subscribers/:id(.:format)          cloud_text/notebook/subscribers#destroy
# GET    /notebooks/list(.:format)                                  cloud_text/notebooks#list
# GET    /notebooks/options(.:format)                               cloud_text/notebooks#options
# POST   /notebooks/search(.:format)                                cloud_text/notebooks#search
# GET    /notebooks/:id/resources/aditional_action_get(.:format)    cloud_text/notebooks#aditional_action_get
# POST   /notebooks/:id/resources/aditional_action_post(.:format)   cloud_text/notebooks#aditional_action_post



# /notebooks                                       cloud_text/notebooks
# /notebooks/new                                   cloud_text/notebooks
# /notebooks/:id/edit                              cloud_text/notebooks
# /notebooks/:id                                   cloud_text/notebooks

# /notebooks/:id/resources/images                  cloud_text/notebooks#images
# /notebooks/:id/resources/details                 cloud_text/notebooks#details

# /notebooks/list                                  cloud_text/notebooks#list
# /notebooks/options                               cloud_text/notebooks#options
# /notebooks/search                                cloud_text/notebooks#search

# /notebooks/:id/actions/sync                      cloud_text/notebooks#sync
# /notebooks/:id/actions/update                    cloud_text/notebooks#update

# /notebooks/:notebook_id/actions                  cloud_text/notebook/actions
# /notebooks/:notebook_id/actions/:id              cloud_text/notebook/actions
# /notebooks/:notebook_id/activities               cloud_text/notebook/activities
# /notebooks/:notebook_id/activities/:id           cloud_text/notebook/activities
# /notebooks/:notebook_id/discussions              cloud_text/notebook/discussions
# /notebooks/:notebook_id/discussions/:id          cloud_text/notebook/discussions
# /notebooks/:notebook_id/files                    cloud_text/notebook/files
# /notebooks/:notebook_id/files/:id                cloud_text/notebook/files
# /notebooks/:notebook_id/subscribers              cloud_text/notebook/subscribers
# /notebooks/:notebook_id/subscribers/:id          cloud_text/notebook/subscribers

# /notebooks/files/options                         cloud_text/notebook/files

# /notebooks/:notebook_id/files.zip
# /notebooks/:notebook_id/files.pdf
# /notebooks/:notebook_id/files.xlsx
# /notebooks/:notebook_id/files.json
