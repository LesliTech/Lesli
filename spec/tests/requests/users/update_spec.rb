=begin

Copyright (c) 2020, all rights reserved.

All the information provided by this platform is protected by international laws related  to 
industrial property, intellectual property, copyright and relative international laws. 
All intellectual or industrial property rights of the code, texts, trade mark, design, 
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

# include helpers, configuration & initializers for request tests
require "lesli_request_helper"

RSpec.describe "Tests for Lesli 3", :unless => defined?(DeutscheLeibrenten) do

    describe "POST:/administration/users.json", type: :request  do
        include_context "request user authentication"

        it "is expected to create a user through the administration area" do
            user = FactoryBot.attributes_for(:user)
            user[:account] = nil # by default the method creates an account for the user, so we do not need it
            user[:roles_id] = Role.first.id

            post("/administration/users.json", params: {
                user: user
            })

            # shared examples
            expect_response_with_successful

            # custom specs
            expect(response_body["category"]).to eql("user")
            expect(response_body["active"]).to eql(true)
            expect(response_body["email"]).to eql(user[:email])

            # activity spec
            expect(User.find_by_id(response_body["id"]).activities.find_by(category: 'action_create')).to_not be_nil
        end

        it "is expected to update a user information the administration area" do
            last_user = User.last

            new_attributes = {
                email: Faker::Internet.email,
                detail_attributes: {
                    first_name: Faker::Name.first_name,
                    last_name: Faker::Name.last_name,
                    telephone: Faker::PhoneNumber.cell_phone,
                }
            }

            put("/administration/users/#{last_user.id}.json", params: {
                user: new_attributes
            })

            # shared examples
            expect_response_with_successful

            puts "response"
            puts response_body
            puts "email"
            puts new_attributes


            expect(response_body["email"]).to eql(new_attributes[:email])
            # expect(response_body["first_name"]).to eql(new_attributes.detail_attributes.first_name)

            puts response_body
            puts response_body["email"]

        end



    end

end
