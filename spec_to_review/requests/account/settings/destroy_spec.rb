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

require "rails_helper"
require "spec_helper"
require "byebug"


RSpec.describe "DELETE:/administration/account/settings/:id", type: :request do

    include_context "user authentication"

    before(:all) do

        @setting_params = {
            name: "color",
            value: Faker::Color.hex_color,
        }

        @setting = @user.account.settings.create(@setting_params)

        delete("/administration/account/settings/#{@setting.id}.json")

    end

    include_examples "successful standard json response"

    it "is expected to have deleted the setting" do
        expect(@response_body["data"]).to be_nil
        # the setting should no longer be in the database
        expect(@user.account.settings.find_by_id(@setting.id).to_json).to be_a(String)
        expect(@user.account.settings.find_by_id(@setting.id).to_json).to eql("null")

    end

end


RSpec.describe "DELETE:/administration/account/settings/:id", type: :request do

    include_context "user authentication"

    before(:all) do
        # Set setting id that does not exist
        @invalid_setting_id = @user.account.settings.all.order(id: :asc).last.id + 1

        delete("/administration/account/settings/#{@invalid_setting_id}.json")
    end

    include_examples "not found standard json response"

    it "is expected to respond with not found" do
        expect(@response_body).to have_key("error")
        expect(@response_body["error"]).to be_a(Hash)

        expect(@response_body["error"]).to have_key("message")
        expect(@response_body["error"]["message"]).to be_a(String)

        expect(@response_body["error"]).to have_key("details")
        expect(@response_body["error"]["details"]).to be_a(Array)
    end

end
