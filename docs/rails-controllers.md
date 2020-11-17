<p align="center">
	<img width="200" alt="LesliCloud logo" src="https://cdn.lesli.tech//lesli/brand/lesli-logo.svg" />
</p>

<h3 align="center">LesliController @query</h3>

<hr/>


#### Description
@query is a global variable that provide a standard way to access request parameters in every controller, to have access to @query you must inherit from ApplicationLesliController.  

__Note:__ @query is available only at controller level, if you need to use @query into a model you have to pass as second parameter to your model method.  

Example:  

```ruby
module CloudAudit
    class UsersController < ApplicationLesliController
        before_action :set_user, only: [:show, :edit, :update, :destroy]

        # GET /user logs
        def index
            respond_to do |format|
                format.html { }
                format.json do
                    respond_with_successful(User.index(current_user, @query))
                end
            end
        end
    end
end

module CloudAudit
    class User < ApplicationRecord

        def self.index current_user, query

            logs = ::User::Log.joins(:user).select(
                :id,
                "users.id as user_id",
                "users.email",
                :session_uuid,
                :description,
                :created_at
            )
            .page(query[:pagination][:page])
            .per(query[:pagination][:perPage])
            .order(:created_at)
            
            LC::Response.pagination(
                logs.current_page,
                logs.total_pages,
                logs.total_count,
                logs.length,
                logs.map do |log|
                    {
                        id: log[:id],
                        user_id: log[:user_id],
                        email: log[:email],
                        session_uuid: log[:session_uuid],
                        description: log[:description],
                        created_at: LC::Date.to_string_datetime(log[:created_at])
                    }
                end
            )

        end

    end
end
```


#### Structure
```ruby
@query = {
    filters: {},
    pagination: {
        perPage: 15,
        page: 1,
        order: "desc",
        orderColumn: "id"
    }
}
```
