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


RSpec.describe "PUT:/otp", type: :request, :unless => defined?(DeutscheLeibrenten) do
    
    it "is expected to redirect to '/otp/new' when the param 't' is not sent" do
        put("/otp.json")
        expect_response_with_error
        expect(response_body["message"]).to eql("Not valid authorization token found")
    end

    it "is expected to redirect to '/login' when an invalid token is sent" do
        put("/otp.json", params: { t: Faker::Lorem.characters(number: 30) })
        expect_response_with_error
        expect(response_body["message"]).to eql("Not valid authorization token found")
    end

    it "is expected to redirect to root '/' if everything happened correctly" do
        otp = User.first.access_codes.new({ token_type: "otp" })
        raw, enc = ::Devise.token_generator.create(otp.class, :token)
        otp.token = enc
        otp.save

        put("/otp.json", params: { t: raw })
        expect_response_with_successful
    end
end
