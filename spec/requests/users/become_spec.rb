require "rails_helper"
require "spec_helper"
require "byebug"
require "faker"

RSpec.describe "GET:/administration/users/:id/resources/resources/become.json with an user with no privileges", type: :request do
    include_context "user authentication" 

    before(:all) do
        # We create a user with no privileges and attempt to become another user
        password = Faker::Internet.password
        limited_user = @user.account.users.create({ 
            email: Faker::Internet.email, 
            password: password,
            password_confirmation: password
        })
        limited_user.user_roles.create({ role: @user.account.roles.find_by(name: "limited") })
        limited_user.confirm
        sign_in limited_user

        random_user = User.where("id != ?", limited_user.id).order("random()").first

        get "/administration/users/#{random_user.id}/resources/become.json"
    end

    include_examples "unauthorized standard json response"
end

RSpec.describe "GET:/administration/users/:id/resources/resources/become.json with a user with the wrong email", type: :request do
    include_context "user authentication" 

    before(:all) do
        # We create a user with no privileges and attempt to become another user
        password = Faker::Internet.password
        owner_user = @user.account.users.create({ 
            email: Faker::Internet.email, 
            password: password,
            password_confirmation: password
        })
        owner_user.user_roles.create({ role: @user.account.roles.find_by(name: "owner") })
        owner_user.confirm
        sign_in owner_user

        random_user = User.where("id != ?", owner_user.id).order("random()").first

        get "/administration/users/#{random_user.id}/resources/become.json"
    end

    include_examples "unauthorized standard json response"
end


RSpec.describe "GET:/administration/users/:id/resources/resources/become.json with a the correct user", type: :request do
    include_context "user authentication" 

    before(:all) do
        # We create a user with no privileges and attempt to become another user
        crm_email = "crm.admin@deutsche-leibrenten.de"
        crm_user = User.find_by(email: crm_email)

        unless crm_user
            password = Faker::Internet.password
            crm_user = @user.account.users.create({ 
                email: crm_email, 
                password: password,
                password_confirmation: password
            })
        end

        
        crm_user.user_roles.create({ role: @user.account.roles.find_by(name: "admin") })
        crm_user.confirm
        sign_in crm_user

        random_user = User.where("id != ?", crm_user.id).order("random()").first

        get "/administration/users/#{random_user.id}/resources/become.json"
    end

    include_examples "successful standard json response"
end
