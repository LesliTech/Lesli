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


RSpec.describe "POST:/administration/users.json", type: :request  do
    include_context "request user authentication"

    it "is expected to create a user through the administration area" do
        user = FactoryBot.attributes_for(:user)
        user[:account] = nil # by default the method creates an account for the user, so we do not need it
        user[:roles_id] = Role.first.id

        post("/administration/users.json", params: {
            user: user
        })

        # shared examples
        expect_json_response_successful

        # custom specs
        expect(response_data["category"]).to eql("user")
        expect(response_data["active"]).to eql(true)
        expect(response_data["email"]).to eql(user[:email])
    end

    it "is expected to assign limited role to user" do
        user = FactoryBot.attributes_for(:user)
        user[:account] = nil # by default the method creates an account for the user, so we do not need it

        post("/administration/users.json", params: {
            user: user
        })
        
        # shared examples
        expect_json_response_successful

        # custom specs
        roles = User.find(response_data["id"]).roles
        expect(roles.find { |role| role[:name] == "limited" }).to_not be_nil
    end  
    
    it "is expected to not create a user that already exists" do
        user = FactoryBot.attributes_for(:user)
        user[:email] = "test@lesli.cloud"
        user[:account] = nil # by default the method creates an account for the user, so we do not need it
        user[:roles_id] = Role.first.id

        post("/administration/users.json", params: {
            user: user
        })
        
        # shared examples
        expect_json_response_error
    end

    it "is expected to not create a user with nil email" do
        user = FactoryBot.attributes_for(:user)
        user[:email] = nil
        user[:account] = nil # by default the method creates an account for the user, so we do not need it
        user[:roles_id] = Role.first.id

        post("/administration/users.json", params: {
            user: user
        })

        # shared examples
        expect_json_response_error
    end

    it "is expected to not create a user with an empty email" do
        user = FactoryBot.attributes_for(:user)
        user[:email] = ""
        user[:account] = nil # by default the method creates an account for the user, so we do not need it
        user[:roles_id] = Role.first.id
        
        post("/administration/users.json", params: {
            user: user
        })

        # shared examples
        expect_json_response_error
    end

    it "is expected to create a new user with the specific account and region" do
        account = Account.first
        account = FactoryBot.create(:account) unless account
        region = account.locations.create!(
            name: Faker::Address.state,
            level: "region"
        )

        user = FactoryBot.attributes_for(:user)
        user[:account] = nil # by default the method creates an account for the user, so we do not need it
        user[:roles_id] = Role.first.id
        user[:accounts_id] = account.id
        user[:detail_attributes][:work_region] = region.id
        
        post("/administration/users.json", params: {
            user: user
        })

        # shared examples
        expect_json_response_successful

        # custom specs
        expect(response_data["category"]).to eql("user")
        expect(response_data["active"]).to eql(true)
        expect(response_data["email"]).to eql(user[:email])
        expect(User.find(response_data["id"]).detail.work_region).to eql(region.id)
    end

    it "is expected to not to create a user with invalid region id" do
        account = Account.first
        account = FactoryBot.create(:account) unless account
        region = account.locations.create!(
            name: Faker::Address.state,
            level: "region"
        )
        invalid_region_id = region ? (region.id + 1) : 1

        user = FactoryBot.attributes_for(:user)
        user[:account] = nil # by default the method creates an account for the user, so we do not need it
        user[:roles_id] = Role.first.id
        user[:accounts_id] = account.id
        user[:detail_attributes][:work_region] = invalid_region_id
        
        post("/administration/users.json", params: {
            user: user
        })

        # shared examples
        expect_json_response_error
    end
end
