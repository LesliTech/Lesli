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

RSpec.configure do |config|
    config.include Devise::Test::IntegrationHelpers
end

RSpec.describe "PUT /users/:id", type: :request do

    before(:all) do
        @user = User.find_by(email: "dev@lesli.cloud")
        sign_in @user
    end
        
    it "Change role to admin user" do
        put "/users/#{@user.id}.json", params: {
            user: {
                roles_id: 1
            }
        }
        expect(response).to have_http_status(:success) 
        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(JSON.parse(response.body)["successful"]).to eql(true)
    end

end


RSpec.describe "PUT /users/:id", type: :request do

    before(:all) do
        @user = User.find_by(email: "dev@lesli.cloud")
        sign_in @user
    end

    it "Change role to admin user to lower role" do

        # create a dummy user
        user = Account.find(1).users.create({ 
            email: DateTime.now.strftime('%s')+"@lesli.cloud", 
            password: DateTime.now.strftime('%s'),
            password_confirmation: DateTime.now.strftime('%s'),
            roles_id: 1 
        })

        # get the lowest role
        role = Account.find(1).roles.last 

        # update user
        put "/users/#{user.id}.json", params: {
            user: {
                roles_id: role.id
            }
        }

        expect(response).to have_http_status(:success) 
        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(JSON.parse(response.body)["successful"]).to eql(true)

    end

end


RSpec.describe "PUT /users/:id", type: :request do

    before(:all) do
        @user = User.find_by(email: "dev@lesli.cloud")
        sign_in @user
    end

    it "Change role to user from limited role to admin role" do

        # get lowest role
        role = Account.find(1).roles.last

        # create a dummy user with limited user
        user = Account.find(1).users.create({ 
            email: DateTime.now.strftime('%s')+"_@lesli.cloud", 
            password: DateTime.now.strftime('%s'),
            password_confirmation: DateTime.now.strftime('%s'),
            roles_id: role.id
        })

        # update role of the user to admin
        put "/users/#{user.id}.json", params: {
            user: {
                roles_id: 1
            }
        }

        expect(response).to have_http_status(:success) 
        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(JSON.parse(response.body)["successful"]).to eql(true)
    end

end

RSpec.describe "PUT /users/:id", type: :request do

    before(:all) do
        @user = User.find_by(email: "dev@lesli.cloud")
        sign_in @user
    end

    it "Change role to user from limited role to admin role" do

        # get lowest role
        role = Account.find(1).roles.last

        # create a dummy user with limited user
        user = Account.find(1).users.create({ 
            email: DateTime.now.strftime('%s')+"__@lesli.cloud", 
            password: DateTime.now.strftime('%s'),
            password_confirmation: DateTime.now.strftime('%s'),
            roles_id: role.id
        })

        # confirm my new user so I'm able to login
        user.confirm

        # do login with my new brand test user
        sign_in user

        # update role of the user to admin
        put "/users/#{user.id}.json", params: {
            user: {
                roles_id: 1
            }
        }
        
        expect(response).to have_http_status(401) 
        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(JSON.parse(response.body)["successful"]).to eql(false)
    end

end

RSpec.describe "PUT /users/:id", type: :request do

    before(:all) do
        @user = User.find_by(email: "dev@lesli.cloud")
        sign_in @user
    end

    it "Change user password" do

        # get lowest role
        role = @user.account.roles.last

        # create a dummy user with limited user
        password = DateTime.now.strftime('%s')
        user = @user.account.users.create({ 
            email: DateTime.now.strftime('%s') + (rand(1000) + 1).to_s + "__@lesli.cloud", 
            password: password,
            password_confirmation: password,
            roles_id: role.id
        })

        # confirm my new user so I'm able to login
        user.confirm

        # do login with my new brand test user
        sign_in user

        #change password
        new_password = DateTime.now.strftime('%s') + (rand(1000) + 1).to_s
        
        put "/", params: {
            user: {
                password: new_password,
                password_confirmation: new_password
            }
        }

        expect(response).to have_http_status(:success) 
        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(JSON.parse(response.body)["successful"]).to eql(true)
    end
end
