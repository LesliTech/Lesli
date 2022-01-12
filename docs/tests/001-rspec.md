# RSpec tests
Integration tests for Rails applications

## Generate tests
There is a custom generator to scaffold a basic set of CRUD tests

```bash

# generate tests for a core feature
rails generate test core/invite

# generate tests for a module feature
rails generate test cloud_focus/tasks
```

## Folder structure

```plaintext
Rails app or engine/
└── spec
    ├── controllers/
    ├── requests/                       -> (your tests goes here!) 
    │   └── [controllers_name]/         -> (your tests goes here!) 
    │       └── method_name_spec.rb     -> (your tests goes here!) 
    ├── support/
    ├── rails_helper.rb
    └── spec_helper.rb
```


## Testing GET request

```ruby

# include helper code  
# spec_helper also includes support/shared context and support/shared examples
require "lesli_request_helper"
require "spec_helper"
require "byebug"


# Describe the test with the full api url for the controller
RSpec.describe 'GET:/administration/users.json', type: :request do

    # include user authentication context from: spec/lesli_request_helper.rb
    include_context 'request user authentication'

    # write specific tests for the controller
    it 'is expected to respond with successful' do
        # execute requests to the api
        get '/administration/users.json' 

        # include standard tests for a standard successful json response
        # this file is at spec/support/helpers/response_helper.rb
        expect_json_response_successful

        # specific tests for the response
        expect(response_data.first["id"]).to be >= 1
    end

end
```


## Testing POST request

```ruby

# include helper code  
# spec_helper also includes support/shared context and support/shared examples
require "lesli_request_helper"
require "spec_helper"
require "byebug"


# Describe the test with the full api url for the controller
RSpec.describe 'POST:/administration/users.json', type: :request do

    # include user authentication context from: spec/lesli_request_helper.rb
    include_context 'request user authentication'

    # test cases

    # write specific tests for the controller
    it 'is expected to respond with successful' do
        # params that will be send through the request
        @user_params = {
            email: Faker::Internet.email,
            roles_id: Role.first.id,
            active: true,
            detail_attributes: {
                salutation: "mr",
                first_name: Faker::Name.first_name,
                last_name: Faker::Name.last_name
            }
        }

        # execute requests to the api
        post("/administration/users.json", params: {
            user: @user_params
        })

        # include standard tests for a standard successful json response
        # this file is at spec/support/helpers/response_helper.rb
        expect_json_response_successful

        # specific tests of the response
        expect(response_data["category"]).to eql("user")
        expect(response_data["active"]).to eql(true)
        expect(response_data["email"]).to eql(@user_params[:email])
    end

end
```


## Testing PUT request

```ruby

# include helper code  
# spec_helper also includes support/shared context and support/shared examples
require "lesli_request_helper"
require "spec_helper"
require "byebug"


# Describe the test with the full api url for the controller
RSpec.describe 'PUT:/administration/users/:id.json', type: :request do

    # include user authentication context from: spec/lesli_request_helper.rb
    include_context 'request user authentication'

    # test cases

    # write specific tests for the controller
    it 'is expected to respond with successful' do
        # we will update curent user's email
        @user_params = {
            email: Faker::Internet.email
        }

        # execute requests to the api
        put("/administration/users/#{@current_user.id}.json", params: {
            user: @user_params
        })

        # include standard tests for a standard successful json response
        # this file is at spec/support/helpers/response_helper.rb
        expect_json_response_successful

        # specific tests of the response
        expect(User.find_by(id: @current_user.id).email).to eql(@user_params[:email])
    end

end
```


## Testing DELETE request

```ruby

# include helper code  
# spec_helper also includes support/shared context and support/shared examples
require "lesli_request_helper"
require "spec_helper"
require "byebug"


# Describe the test with the full api url for the controller
RSpec.describe 'DELETE:/administration/users/:id.json', type: :request do

    # include user authentication context from: spec/lesli_request_helper.rb
    include_context 'request user authentication'

    # helper methods go here
    # You can add helper methods used to automate the tests if they are needed across examples

    def create_record(record_params = {})
        @user_record = User.new(record_params)
        @user_record.save!
    end

    # test cases

    # write specific tests for the controller
    it 'is expected to respond with successful' do
        # we use the helper method indicated above to create records
        @user = create_record()

        # execute requests to the api
        delete "/administration/users/#{@user.id}.json"

        # include standard tests for a standard successful json response
        # this file is at spec/support/helpers/response_helper.rb
        expect_json_response_successful

        # specific tests of the response
        expect(User.find_by(id: @user.id)).to be_nil
    end

    it "is expected to respond with not found when and invalid ID is sent" do
        # we use the helper method indicated above to create records
        # this id does not exist in the database, so should return with not found
        @invalid_id = create_record().id + 1

        # execute requests to the api
        delete "/administration/users/#{@invalid_id}.json"

        # include standard tests for a standard successful json response
        # this file is at spec/support/helpers/response_helper.rb
        expect_json_response_not_found
    end

end
```


