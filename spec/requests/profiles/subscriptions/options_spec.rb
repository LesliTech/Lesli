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

require 'rails_helper'
require 'spec_helper'
require 'byebug'

RSpec.describe "GET:/administration/profile/subscriptions/options.json", type: :request do
    include_context "user authentication"

    before(:all) { get "/administration/profile/subscriptions/options.json" }

    include_examples "successful standard json response"

    it "is expected to respond with subscription options" do
        expect(@response_body_data).to be_a(Hash)
        expect(@response_body_data.keys.length).to be > 0
    end

    it "is expected to respond with a section of engines" do
        expect(@response_body_data).to have_key("engines")
        expect(@response_body_data["engines"]).to be_an(Array)
    end

    it "is expected to respond with a section of notification types" do
        expect(@response_body_data).to have_key("notification_types")
        expect(@response_body_data["notification_types"]).to be_a(Hash)
        expect(@response_body_data["notification_types"].keys.length).to be > 0
    end
end

RSpec.describe "GET:/administration/profile/subscriptions/options.json", type: :request do
    let(:login) { "/login?r=/administration/profile/subscriptions/options.json" }
    before(:all) { get "/administration/profile/subscriptions/options.json" }

    it "is expected to redirect to login when user is not authenticated" do
        expect(response).to redirect_to(login)
    end
end