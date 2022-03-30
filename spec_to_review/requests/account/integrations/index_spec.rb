=begin
Copyright (c) 2021, all rights reserved.

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


require "rails_helper"
require "spec_helper"
require "byebug" 

data = [   
    { :name => Faker::Superhero.power },
    { :name => Faker::Superhero.power },
    { :name => Faker::Superhero.power },
    { :name => Faker::Superhero.power },
]

RSpec.describe "GET:/administration/account/integrations", type: :request do 

    include_context "user authentication"

    before(:all) do 
        # Delete all records in the db to work with a clean table
        @user.account.integrations.destroy_all

        data.each do |integration|    
            # The next code is used to create valid integrations, and then will be tested

            @new_integration = @user.account.integrations.new({name: integration[:name]})
    
            @new_integration_user_email = integration[:name]
            .downcase                           
            .gsub(/[^0-9A-Za-z\s\-\_]/, "")     
            .gsub(/\s+/, "-")                  
            .concat("-", SecureRandom.hex(4), "@integrations")
    
            user = @user.account.users.find_or_create_by(email: @new_integration_user_email) do |user|
                user.category = "integration"
                user.active = true
                user.confirm
                user.user_roles.create({ role: ::Role.find_by(:name => "api") })
                user.save!
            end
    
            @new_integration.user_main = @user
            @new_integration.user = user
            @new_integration.save
    
            # create session
            user.sessions.create({
                :session_source => "dispatcher_standar_session",
                :last_used_at   => LC::Date.now
            })
        end
         
        # the endpoint to test will be the one of "index"
        get "/administration/account/integrations.json"
    end

    include_examples "successful standard json response"

    it "is expected to respond with integrations" do 
        expect(@response_body_data).to be_an(Array)

        expect(@response_body_data.length).to eql(data.length)
        expect(@response_body_data.at(0).keys).to contain_exactly("id", "name", "active", "email", "usage_count", "last_used_at", "expiration_at")

        expect(@response_body_data.at(0)).to have_key("id")
        expect(@response_body_data.at(0)["id"]).to be_a(Numeric)

        expect(@response_body_data.at(0)).to have_key("name")
        expect(@response_body_data.at(0)["name"]).to be_a(String)

        expect(@response_body_data.at(0)).to have_key("active")
        expect(@response_body_data.at(0)["active"]).to be(true)

        expect(@response_body_data.at(0)).to have_key("email")
        expect(@response_body_data.at(0)["email"]).to be_a(String)

        expect(@response_body_data.at(0)).to have_key("usage_count")
        expect(@response_body_data.at(0)["usage_count"]).to be_nil

        expect(@response_body_data.at(0)).to have_key("last_used_at")
        expect(@response_body_data.at(0)["last_used_at"]).to be_a(String)

        expect(@response_body_data.at(0)).to have_key("expiration_at")
        expect(@response_body_data.at(0)["expiration_at"]).to be_nil

    end

end