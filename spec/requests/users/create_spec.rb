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

require 'rails_helper'
require 'spec_helper'
require 'byebug'

2.times do 

    RSpec.describe 'POST:/administration/users.json', type: :request do
        include_context 'user authentication'

        before(:all) do
            @email = Faker::Internet.email
            @roles_id = Role.first.id
            @first_name = Faker::Name.first_name
            @last_name = Faker::Name.last_name
            post("/administration/users.json", params: {
                user: {
                    email: @email,
                    roles_id: @roles_id,
                    active: true,
                    detail_attributes: {
                        salutation: "mr",
                        first_name: @first_name,
                        last_name: @last_name
                    }
                }
            })
        end

        include_examples 'successful standard json response'

        it 'is expected to create a new user' do
            expect(@response_body["data"]["category"]).to eql("user")
            expect(@response_body["data"]["active"]).to eql(true)
            expect(@response_body["data"]["email"]).to eql(@email)
        end
    end

end


RSpec.describe 'POST:/administration/users.json', type: :request do
    include_context 'user authentication'

    before(:all) do
        @email = Faker::Internet.email
        @roles_id = 0
        @first_name = Faker::Name.last_name
        @last_name = Faker::Name.last_name
        post("/administration/users.json", params: {
            user: {
                email: @email,
                roles_id: @roles_id,
                active: true,
                detail_attributes: {
                    salutation: "mr",
                    first_name: @first_name,
                    last_name: @last_name
                }
            }
        })
    end

    include_examples 'successful standard json response'

    it 'is expected to assign limited role to user' do
        roles = User.find(@response_body["data"]["id"]).roles
        expect(roles.find { |role| role[:name] == "limited" }).to_not be_nil
    end

end


RSpec.describe 'POST:/administration/users.json', type: :request do
    include_context 'user authentication'

    before(:all) do
        @email = "test@lesli.cloud"
        @roles_id = Role.first.id
        @first_name = Faker::Name.first_name
        @last_name = Faker::Name.last_name
        post("/administration/users.json", params: {
            user: {
                email: @email,
                roles_id: @roles_id,
                active: true,
                detail_attributes: {
                    salutation: "mr",
                    first_name: @first_name,
                    last_name: @last_name
                }
            }
        })
    end

    include_examples 'failed standard json response'

    it 'is expected to not create a user that already exists' do
        expect(@response_body["successful"]).to eql(false)
    end

end


RSpec.describe 'POST:/administration/users.json', type: :request do
    include_context 'user authentication'

    before(:all) do
        @email = nil
        @roles_id = Role.first.id
        @first_name = Faker::Name.last_name
        @last_name = Faker::Name.last_name
        post("/administration/users.json", params: {
            user: {
                email: @email,
                roles_id: @roles_id,
                active: true,
                detail_attributes: {
                    salutation: "mr",
                    first_name: @first_name,
                    last_name: @last_name
                }
            }
        })
    end

    include_examples 'failed standard json response'

    it 'is expected to not create a user with nil email' do
        expect(@response_body["successful"]).to eql(false)
    end

end


RSpec.describe 'POST:/administration/users.json', type: :request do
    include_context 'user authentication'

    before(:all) do
        @email = ""
        @roles_id = Role.first.id
        @first_name = Faker::Name.last_name
        @last_name = Faker::Name.last_name
        post("/administration/users.json", params: {
            user: {
                email: @email,
                roles_id: @roles_id,
                active: true,
                detail_attributes: {
                    salutation: "mr",
                    first_name: @first_name,
                    last_name: @last_name
                }
            }
        })
    end

    include_examples 'failed standard json response'

    it 'is expected to not create a user with an empty email' do
        expect(@response_body["successful"]).to eql(false)
    end

end
