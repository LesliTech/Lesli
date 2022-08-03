=begin
    Copyright (c) 2022, all rights reserved.
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
RSpec.describe "Tests for Lesli3", type: :request, :unless => defined?(DeutscheLeibrenten) do
    describe "GET:/administration/profile/subscriptions", type: :request do
        include_context "request user authentication"
        let!(:user) { FactoryBot.create(:user) }
            #share example
        it "is expected pass share example response with successful" do
            get("/administration/profile/subscriptions.json")
            expect_response_with_successful
        end
    end
end
