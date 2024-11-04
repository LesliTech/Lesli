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
RSpec.describe "POST:/password", type: :request do

    it "is expected to request a password recovery email" do

        @user = FactoryBot.create(:lesli_user)

        post("/password", params: {
            user: { 
                email: @user.email
            }
        })

        expect_response_with_successful

        @user.reload

        expect(@user.reset_password_token).not_to be(nil)
        expect(@user.reset_password_sent_at).not_to be(nil)
    end

    it "is expected to fail when request a password recovery for not active user" do

        @user = FactoryBot.create(:lesli_user)

        @user.update(:active => false)

        post("/password", params: {
            user: { 
                email: @user.email
            }
        })

        expect_response_with_error

        expect(response_body["message"]).to eql(I18n.t("core.users/passwords.messages_danger_inactive_user"))
    end

    it "is expected to fail when request a password recovery for not valid email" do

        post("/password", params: {
            user: { 
                email: "not_valid_email"
            }
        })

        expect_response_with_error

        expect(response_body["message"]).to eql(I18n.t("core.shared.messages_warning_user_not_found"))
    end

    it "is expected to fail when request a password recovery for a nil email" do

        post("/password", params: {
            user: { 
            }
        })

        expect_response_with_error

        expect(response_body["message"]).to eql(I18n.t("core.shared.messages_warning_user_not_found"))
    end
end
