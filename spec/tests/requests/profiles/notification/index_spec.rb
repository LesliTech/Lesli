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
RSpec.describe "GET:/administration/profile/notifications.json", type: :request, :unless => defined?(DeutscheLeibrenten) do
    describe "GET:/administration/profile/notifications.json", type: :request do
        include_context "request user authentication"
        it "is expected to respond a hash not empty whit diferent key value" do
            get("/administration/profile/notifications.json")
            puts "respuesta!!!!!!!!!!!!!!! #{response_body}"
            expect_response_with_successful
            puts "respuesta!!!!!!!!!!!!!!! #{response_body}"
        end
    end
end
