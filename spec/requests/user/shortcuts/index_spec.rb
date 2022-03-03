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

RSpec.describe "GET:/administration/users/:id/shortcuts.json", type: :request do

    include_context "request user authentication"

    # helper methods
    let!(:shortcuts_count) { User.joins(:shortcuts).where("users.id = ?", @current_user.id).count }
    let(:limited_user) do
        @new_user = User.new(attributes_for(:user))
        @account = create(:account)
        @role = Role.find_by(name: "limited")

        @new_user.account = @account
        @new_user.confirm
        @new_user.save!

        @new_user.user_roles.create!({ role: @role })
        @new_user
    end


    # it "is expected to respond with a pagination of records" do
        
    #     get "/administration/users/#{@current_user.id}/shortcuts.json"


    #     # shared examples
    #     expect_json_response_successful

    #     # specific specs
    #     expect(response_data).to be_a(Hash)
    #     expect(response_data).to have_key("pagination")
    #     expect(response_data["pagination"]).to be_a(Hash)
    #     expect(response_data["pagination"]).to have_key("total_pages")
    #     expect(response_data["pagination"]["total_pages"]).to be_a(Numeric)

    #     expect(response_data["pagination"]).to have_key("current_page")
    #     expect(response_data["pagination"]["current_page"]).to be_a(Numeric)

    #     expect(response_data["pagination"]).to have_key("count_total")
    #     expect(response_data["pagination"]["count_total"]).to be_a(Numeric)

    #     expect(response_data["pagination"]).to have_key("count_results")
    #     expect(response_data["pagination"]["count_results"]).to be_a(Numeric)
    #     expect(response_data["pagination"]["count_results"]).to eql(shortcuts_count)

    #     expect(response_data).to have_key("records")
    #     expect(response_data["records"]).to be_an(Array)
    # end

    it "is expected to respond with unauthorized" do
        limited_user
        sign_in @new_user

        get "/administration/users/#{@current_user.id}/shortcuts.json"

        # shared examples
        expect_json_response_unauthorized
    end
    
    it "is expected redirect to login when no user is authenticated" do
        login = "/login?r=/administration/users/#{@current_user.id}/shortcuts.json"
        sign_out @current_user
        
        get "/administration/users/#{@current_user.id}/shortcuts.json"

        # specific specs
        expect(response).to redirect_to(login)
    end

end
