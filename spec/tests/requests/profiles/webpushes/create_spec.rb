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

require "lesli_request_helper"
RSpec.describe "POST:/administration/profile/webpushes.json", type: :request, :unless => defined?(DeutscheLeibrenten) do
    describe "POST:/administration/profile/webpushes.json", type: :request do
        include_context "request user authentication"
        profile_webpush_params = FactoryBot.attributes_for(:webpush)

        it "is expected to respond a hash not empty whit diferent key value" do

            post("/administration/profile/webpushes.json", params: {
                webpush: profile_webpush_params
            })

            expect_response_with_successful
        end
    end
end
