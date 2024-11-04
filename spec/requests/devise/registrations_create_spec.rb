=begin

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Ruby on Rails SaaS Development Framework.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end


# ·
require "rails_helper"
require Lesli::RSpec.testers_request


# ·
RSpec.describe "POST:/register.json", type: :request do

    it "is expected to create a new account" do

        email = Faker::Internet.email
        password = Faker::Internet.password(min_length: 8)

        post("/", params: { 
            email: email,
            password: password,
            password_confirmation: password
        })

        # check for a successful response
        expect_response_with_successful

        # check user creation in the database 
        current_user = Lesli::User.find_by(:email => email)

        expect(current_user.active).to be(true)
        expect(current_user.confirmed?).to be(false)
        expect(current_user.account).not_to be(false)
    end


    it "is expected to fail when create an account without password" do

        email = Faker::Internet.email

        post("/", params: { 
            email: email,
            password: nil,
            password_confirmation: nil
        })

        # check for a successful response
        expect_response_with_error

        expect(response_body["message"]).to eql("Password can't be blank")

        # check user creation in the database 
        current_user = Lesli::User.find_by(:email => email)

        expect(current_user).to be(nil)
    end

    it "is expected to fail when create an account without email" do

        password = Faker::Internet.password(min_length: 8)

        post("/", params: { 
            email: nil,
            password: password,
            password_confirmation: password
        })

        # check for a successful response
        expect_response_with_error

        expect(response_body["message"]).to eql("Email can't be blank")
    end
end
