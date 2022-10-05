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

require 'lesli_request_helper'

RSpec.describe "DELETE:/administration/account/integrations/:id", type: :request do
    include_context "request user authentication"

    let!(:integration) do
        @new_integration = @current_user.account.integrations.new({name: Faker::Lorem.word})

        @new_integration_user_email = Faker::Lorem.word
        .downcase
        .gsub(/[^0-9A-Za-z\s\-\_]/, "")
        .gsub(/\s+/, "-")
        .concat("-", SecureRandom.hex(4), "@integrations")

        user = @current_user.account.users.find_or_create_by(email: @new_integration_user_email) do |user|
            user.category = "integration"
            user.active = true
            user.confirm
            user.user_roles.create({ role: ::Role.find_by(:name => "api") })
            user.save!
        end

        @new_integration.user_main = @current_user
        @new_integration.user = user
        @new_integration.save!

        # create session
        @user_integration_session = user.sessions.create({
            :session_source => "dispatcher_standar_session",
            :last_used_at   => LC::Date.now
        })

        @new_integration
    end

    let!(:limited_user) { User.joins(:user_roles, :roles).where("roles.name = ?", "limited").first }

    it "is expected to destroy a integration successfully" do
        delete "/administration/account/integrations/#{integration.id}.json"

        # shared examples
        expect_json_response_successful
    end

    it "is expected to reject the request when the user is not authorized" do
        sign_out @current_user
        sign_in limited_user

        delete "/administration/account/integrations/#{integration.id}.json"
        
        # shared examples
        expect_json_response_unauthorized
    end

    it "is expected to return with not found when the ID does not exist" do
        delete "/administration/account/integrations/0.json"

        # shared examples
        expect_json_response_not_found
    end
end
