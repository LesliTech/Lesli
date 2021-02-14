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


RSpec.describe "POST /administration/users/:id/roles", type: :request do
    include_context 'user authentication'

    before(:all) do
        post("/administration/users/#{@user.id}/roles.json", params: {
            user_role: {
                id: @user.account.roles.find_by(name: "admin").id
            }
        })
    end

    include_examples 'successful standard json response'
        
    it "Add admin role to user" do
        expect(@response_body["successful"]).to eql(true)
    end

end


RSpec.describe "POST /administration/users/:id/roles", type: :request do
    include_context 'user authentication'

    before(:all) do 

        # create a dummy user
        user = @user.account.users.create({ 
            email: DateTime.now.strftime('%s')+"@lesli.cloud", 
            password: DateTime.now.strftime('%s'),
            password_confirmation: DateTime.now.strftime('%s')
        })

        user.user_roles.create({ role: @user.account.roles.find_by(name: "admin") })

        # get the guest role
        role = @user.account.roles.find_by(name: "guest") 

        # Add the role to the user
        post("/administration/users/#{@user.id}/roles.json", params: {
            user_role: {
                id: role.id
            }
        })

    end

    include_examples 'successful standard json response'

    it "Add a lower role to a user that is admin" do
        expect(@response_body["successful"]).to eql(true)
    end

end


RSpec.describe "POST /administration/users/:id/roles", type: :request do
    include_context 'user authentication'

    before(:all) do 

        # create a dummy user with limited user
        user = Account.find(1).users.create({ 
            email: DateTime.now.strftime('%s')+"_@lesli.cloud", 
            password: DateTime.now.strftime('%s'),
            password_confirmation: DateTime.now.strftime('%s')
        })
        user.user_roles.create({ role: @user.account.roles.find_by(name: "limited") })

        # get the admin role
        admin_role = @user.account.roles.find_by(name: "admin") 

        # Add the role to the user
        post("/administration/users/#{@user.id}/roles.json", params: {
            user_role: {
                id: admin_role.id
            }
        })

    end

    include_examples 'successful standard json response'

    it "Add admin role to a user with limited role" do
        expect(@response_body["successful"]).to eql(true)
    end

end


RSpec.describe "POST /administration/users/:id/roles", type: :request do

    include_context 'user authentication'

    before(:all) do

        # create a dummy user with limited user
        user = Account.find(1).users.create({ 
            email: DateTime.now.strftime('%s')+"__@lesli.cloud", 
            password: DateTime.now.strftime('%s'),
            password_confirmation: DateTime.now.strftime('%s')
        })
        user.user_roles.create({ role: @user.account.roles.find_by(name: "limited") })

        # confirm my new user so I'm able to login
        user.confirm

        # do login with my new brand test user
        sign_in user

        # get the admin role
        admin_role = @user.account.roles.find_by(name: "admin") 

        # Add the role to the user
        post("/administration/users/#{user.id}/roles.json", params: {
            user_role: {
                id: admin_role.id
            }
        })

    end

    include_examples 'unauthorized standard json response'

    it "Add admin role to a user with limited role when you don't have the proper privileges" do
        expect(@response_body["successful"]).to eql(false)
    end

end


RSpec.describe "PUT /administration/users/:id", type: :request do
    include_context 'user authentication'

    before(:all) do 

        # create a dummy user with limited user
        password = DateTime.now.strftime('%s')
        user = @user.account.users.create({ 
            email: Faker::Internet.email, 
            password: password,
            password_confirmation: password
        })
        user.user_roles.create({ role: @user.account.roles.find_by(name: "limited") })

        # confirm my new user so I'm able to login
        user.confirm

        # do login with my new brand test user
        sign_in user

        #change password
        new_password = DateTime.now.strftime('%s') + (rand(1000) + 1).to_s
        
        put("/", params: {
            user: {
                password: new_password,
                password_confirmation: new_password
            }
        })

    end

    include_examples 'successful standard json response'

    it "Change user password" do
        expect(@response_body["successful"]).to eql(true)
    end
end
