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


## Testing index request

```ruby

# include helper code  
# spec_helper also includes support/shared context and support/shared examples
require 'rails_helper'
require 'spec_helper'
require 'byebug'


# Describe the test with the full api url for the controller
RSpec.describe 'GET:/administration/users.json', type: :request do

    # include user authentication context from: spec/support/shared contexts
    include_context 'user authentication'

    # execute requests to the api
    before(:all) do
        get '/administration/users.json' 
    end

    # include standard tests for a standard successful json response
    # this file is at spec/support/shared examples
    include_examples 'successful standard json response'

    # write specific tests for the controller
    it 'is expected to respond with successful' do
        expect(JSON.parse(response.body)["successful"]).to eql(true)
    end

end
```
