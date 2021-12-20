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

RSpec.describe "GET:/administration/roles/:id/activities.json", type: :request do
    include_context "user authentication"

    before(:all) do
        @role = create(:role, account: @user.account)

        get "/administration/roles/#{@role.id}/activities.json" # no filter is given
    end

    include_examples "successful standard json response"

    it "is expected to respond with activities filtered" do
        expect(@response_body_data).to be_a(Hash)

        expect(@response_body_data).to have_key("activities_count")
        expect(@response_body_data["activities_count"]).to be_a(Numeric)

        expect(@response_body_data).to have_key("activities")
        expect(@response_body_data["activities"]).to be_a(Array)
    end
end

RSpec.describe "GET:/administration/roles/:id/activities.json", type: :request do
    let(:login) { "/login?r=/administration/roles/#{@role.id}/activities.json" }
    before(:all) do
        @account = create(:account)
        @role = create(:role, account: @account)

        get "/administration/roles/#{@role.id}/activities.json"
    end

    it "is expected to redirect to login whe user is not authenticated" do
        expect(response).to redirect_to(login)
    end
end