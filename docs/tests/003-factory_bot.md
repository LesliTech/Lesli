# FactoryBot Rails


FactoryBot is a fixtures replacement with a straightforward definition syntax, support for multiple build strategies (saved instances, unsaved instances, attribute hashes, and stubbed objects), and support for multiple factories for the same class (user, admin_user, and so on), including factory inheritance.

We mostly use FactoryBot to create data of our models in a dynamically way, which has been very useful when we had to scale the app and ensure that is working as is expected.


## Table of contents
- [Define a factory](#define-a-factory)
- [Build strategies](#build-strategies)
    - [Specification of build strategies](#specification)
    - [Attribute overrides](#attribute-overrides)


--------

## Define a Factory
By default, we save our factories in a folder called `spec/factories/`      
There you can create ruby files where you'll define the factories, and you have to follow the same convention of `app/models/` at naming the files.

We have already configurated FactoryBot in our LesliCore Rails Application, so you just have to start writing your factories.

See the following examples:

> `spec/factories/user.rb`
```ruby

FactoryBot.define do
    factory :user, class: "User" do
        email { Faker::Internet.email }
    end
end
```

- With `FactoryBot.define` method you create the factories themselves, which receives a block where you have to define each factory depending the model you're working on (in this case user).
- With `factory :user` we create and define the factory name we'll be using through our specifications (with rspec)
- `class: "User"` helps us to specify the model we wanna create its factory, it is useful when you have nested models in your app.
- The whole sentence `factory :user, class: "User"` receives a block where we will fill with the properties of this specific model, for example in this case in the migration of users we have the `active` property, as well as others (password, ...).     We are able to define all properties of the model, or just the ones we wanna get while using that factory.

For example, we're gonna define more properties in the factory.

> `spec/factories/user.rb`
```ruby

FactoryBot.define do
    factory :user, class: "User" do
        email { Faker::Internet.email }
        password { Devise.friendly_token }
        active { true }
        detail_attributes do
            {
                salutation: ["mr", "mrs"][rand(2)],
                first_name: Faker::Name.first_name,
                last_name: Faker::Name.last_name,
                address: Faker::Address.full_address
            }
        end
        # ...
    end
end
```

You can use Faker through the whole test environment (as you can we are using Faker in our factory)

## Build strategies
The build strategies are used to generate the data defined inside each factory. For example the last examples of users, we defined `email`, `email`, `active`...         
So using build stretegines is the way (and the unique actually) we generate that data.

See the following example using FactoryBot inside a test of RSpec.

```ruby
require "lesli_request_helper"

RSpec.describe "POST:/administration/users.json", type: :request do
    include_context "request user authentication"

    it "is expected to create a user using factory bot" do

        # Using Build Strategies of Factory Bot
        user = FactoryBot.attributes_for(:user)

        post("/administration/users.json", params: {
            user: user
        })

        expect_json_response_successful
    end
end
```

In this case we used the build strategy `FactoryBot.attributes_for(:factory_name)`     

### Specification
- `attributes_for(:factory_name)` Returns a hash with all properties declared inside the factory
- `create(:factory_name)` Returns a saved model instance
- `build(:factory_name)` Returns a model instance that's not saved
- `build_stubbed(:factory_name)` Returns an object with all defined attributes stubbed out

### Attribute overrides
No matter which strategy is used, it's possible to override the defined attributes by passing a hash.

```ruby
user = FactoryBot.attributes_for(:user, email: "test@lesli.clou")

puts user.email # "test@lesli.cloud"
```

--------
