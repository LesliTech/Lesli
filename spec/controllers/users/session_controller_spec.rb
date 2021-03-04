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
require 'faker'

RSpec.describe 'POST:/administration/asdfroles.json', type: :request do
    before(:all) do
        user = Account.first.users.create!({
                                                   email: Faker::Internet.email,
                                                   password: "tardis2021$",
                                                   password_confirmation: "tardis2021$"
                                           })
        user.user_roles.create({ role: Account.first.roles.find_by(name: "limited") })
        user.confirm
        post "/login", params: {
                "user": {
                        "email": user.email,
                        "password": "tardis2021$"
                }
        }
    end
    it "Sign in with valid credentials" do
        expect(response).to have_http_status(:success)
    end
end