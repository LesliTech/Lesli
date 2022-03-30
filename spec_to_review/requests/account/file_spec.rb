=begin

Copyright (c) 2020, all rights reserved.

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

RSpec.describe "POST:/administration/account/files", type: :request do
    include ActionDispatch::TestProcess::FixtureFile
    include_context "user authentication"

    before(:all) do
        @name = "company_logo"
        @file_type = "app_logo"
        @attachment = fixture_file_upload("lesli-icon.png", "image/png")

        post("/administration/account/files.json", params: {
            account_file: {
                name: @name,
                file_type: @file_type,
                attachment: @attachment,
            }
        })
    end

    include_examples "successful standard json response"

    it "can upload image and get it" do
        expect(@response_body["data"]["name"]).to eql(@name)
        expect(@response_body["data"]["file_type"]).to eql(@file_type)
        get("/administration/account/files/#{@response_body["data"]["id"]}")
    end

end
