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


require 'lesli_request_helper'
require 'spec_helper'   
require 'byebug'


RSpec.describe "GET:/administration/users/options.json", type: :request do 
    include_context "request user authentication"

    before do
        get "/administration/users/options.json"
    end

    it "is expected to respond with successful standard json response" do
        expect_json_response_successful
    end

    it "is expected that the response has a property of roles" do
        expect(response_data).to be_a(Hash)
        expect(response_data).to have_key("roles")
        expect(response_data["roles"]).to be_an(Array)
        expect(response_data["roles"].length).to be >= 1
    end

    it "is expected that the response has a property of regions" do
        expect(response_data).to have_key("regions")
        expect(response_data["regions"]).to be_a(Array)
    end

    it "is expected that the response has a property of salutations" do
        expect(response_data).to have_key("salutations")
        expect(response_data["salutations"]).to be_an(Array)
    end
end


# If no one user is authenticated should be redirected to login view
RSpec.describe "GET:/administration/users/options.json", type: :request do 
    let(:login) { "/login?r=/administration/users/options.json" }
    before(:all) do
        get "/administration/users/options.json"
    end

    it "is expected to redirect to login when user is not authenticated" do
        expect(response).to redirect_to(login)
    end
end
