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

require "rails_helper"
require "spec_helper"
require "byebug"

limited_user = nil

RSpec.describe "DEL:/administration/users/:id.json with user with invalid permissions", type: :request do
    include_context "user authentication"

    before(:all) do

        password = Faker::Alphanumeric.alpha(number: 10)

        admin_user = @user.account.users.create({
            email: Faker::Internet.email,
            password: password,
            password_confirmation: password
        })

        admin_user.user_roles.create({ role: @user.account.roles.find_by(name: "sysadmin") })
        admin_user.confirm

        limited_user = @user.account.users.create({
            email: Faker::Internet.email,
            password: password,
            password_confirmation: password
        })

        limited_user.user_roles.create({ role: @user.account.roles.find_by(name: "limited") })
        limited_user.confirm
        sign_in limited_user

        delete("/administration/users/#{admin_user.id}.json")
    end

    include_examples "unauthorized standard json response"
end


RSpec.describe "DEL:/administration/users/:id.json with valid user", type: :request do
    include_context "user authentication"

    before(:all) do
        delete("/administration/users/#{limited_user.id}.json")
    end

    include_examples "successful standard json response"
end
