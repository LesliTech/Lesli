# =begin

# Copyright (c) 2020, all rights reserved.

# All the information provided by this platform is protected by international laws related  to 
# industrial property, intellectual property, copyright and relative international laws. 
# All intellectual or industrial property rights of the code, texts, trade mark, design, 
# pictures and any other information belongs to the owner of this platform.

# Without the written permission of the owner, any replication, modification,
# transmission, publication is strictly forbidden.

# For more information read the license file including with this software.

# // · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
# // · 

# =end

# include helpers, configuration & initializers for request tests
require "lesli_request_helper"

RSpec.describe "Tests for Lesli 3", :unless => defined?(DeutscheLeibrenten) do

    describe "GET:/administration/users/:id.json", type: :request do
        include_context "request user authentication"
        
        it "is expected to respond with the first user created" do
            user = FactoryBot.create(:user)

            get "/administration/users/#{user.id}.json"

            # shared examples
            expect_response_with_successful

            # custom specs
            expect(response_body["id"]).to eql(user.id)
            expect(response_body["email"]).to eql(user.email)
            expect(response_body["alias"]).to eql(user.alias)
            expect(response_body["active"]).to eql(user.active)
            expect(response_body["full_name"]).to eql(user.full_name)
        end

        it 'is expected to respond with the development user' do
            get "/administration/users/#{@current_user.id}.json"

            # shared examples
            expect_response_with_successful

            # custom specs
            expect(response_body["id"]).to eql(@current_user.id)
            expect(response_body["email"]).to eql(@current_user.email)
            expect(response_body["alias"]).to eql(@current_user.alias)
            expect(response_body["active"]).to eql(@current_user.active)
            expect(response_body["full_name"]).to eql(@current_user.full_name)
        end

        it "is expected to respond with unauthorized when is using limited user" do
            limited_user = FactoryBot.create(:user, role_name: "limited")

            sign_in(limited_user)
            get "/administration/users/#{@current_user.id}.json"

            expect_response_with_unauthorized
        end
    end

end
