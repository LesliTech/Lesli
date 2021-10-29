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

RSpec.describe "GET:/administration.json", type: :request do

    include_context 'user authentication'

    before(:all) do
        get("/administration.json")
    end

    include_examples 'successful standard json response'

    it "is expected to return with administration account(s)" do

        expect(@response_body_data).to be_a(Hash)
        
        expect(@response_body_data).to have_key("id")
        expect(@response_body_data["id"]).to be_a(Numeric)
        
        expect(@response_body_data).to have_key("status")
        expect(@response_body_data["status"]).to be_a(String)

        expect(@response_body_data).to have_key("company_name")
        expect(@response_body_data["company_name"]).to be_a(String)

        expect(@response_body_data).to have_key("company_name_legal")
        expect(@response_body_data["company_name_legal"]).to be_a(String)

        expect(@response_body_data).to have_key("company_tag_line")
        expect(@response_body_data["company_tag_line"]).to be_a(String)

        expect(@response_body_data).to have_key("country")
        expect(@response_body_data["country"]).to be_nil

        expect(@response_body_data).to have_key("address")
        expect(@response_body_data["address"]).to be_a(String)

        expect(@response_body_data).to have_key("region")
        expect(@response_body_data["region"]).to be_a(String)

        expect(@response_body_data).to have_key("website")
        expect(@response_body_data["website"]).to be_a(String)

        expect(@response_body_data).to have_key("phone_number_1")
        expect(@response_body_data["phone_number_1"]).to be_a(String)

        expect(@response_body_data).to have_key("phone_number_2")
        expect(@response_body_data["phone_number_2"]).to be_a(String)

        expect(@response_body_data).to have_key("phone_number_3")
        expect(@response_body_data["phone_number_3"]).to be_a(String)

        expect(@response_body_data).to have_key("phone_number_4")
        expect(@response_body_data["phone_number_4"]).to be_a(String)

        expect(@response_body_data).to have_key("public_email")
        expect(@response_body_data["public_email"]).to be_a(String)

        expect(@response_body_data).to have_key("github")
        expect(@response_body_data["github"]).to be_a(String)

        expect(@response_body_data).to have_key("twitter")
        expect(@response_body_data["twitter"]).to be_a(String)

        expect(@response_body_data).to have_key("youtube")
        expect(@response_body_data["youtube"]).to be_a(String)

        expect(@response_body_data).to have_key("linkedin")
        expect(@response_body_data["linkedin"]).to be_a(String)

        expect(@response_body_data).to have_key("facebook")
        expect(@response_body_data["facebook"]).to be_a(String)

        expect(@response_body_data).to have_key("created_at")
        expect(@response_body_data["created_at"]).to be_a(String)

        expect(@response_body_data).to have_key("updated_at")
        expect(@response_body_data["updated_at"]).to be_a(String)

        expect(@response_body_data).to have_key("users_id")
        expect(@response_body_data["users_id"]).to be_a(Numeric)

    end

end
