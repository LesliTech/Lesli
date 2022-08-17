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
    describe "DELETE:/administration/account/files/:id.json", type: :request do
        include ActionDispatch::TestProcess::FixtureFile
        include_context "request user authentication"
        
        it "is expected to response with successful destroyed file" do

            @current_user.account.files.destroy_all
        
            file_subject = @current_user.account.files.create!({
                name: "lesli-icon",
                file_type: "app_logo",
                user_creator: @current_user,
                attachment: fixture_file_upload("lesli-icon.png", "image/png"),
            })
            
            delete("/administration/account/files/#{file_subject.id}.json")
            #share example
            expect_response_with_successful

            #expect the file to do not exist 
            expect(@current_user.account.files.find_by(id: file_subject.id).to_json).to eql("null")
            
        end

        it "is expected to response with fail destroying file" do

            @current_user.account.files.destroy_all
        
            file_subject = @current_user.account.files.create!({
                name: "lesli-icon",
                file_type: "app_logo",
                user_creator: @current_user,
                attachment: fixture_file_upload("lesli-icon.png", "image/png"),
            })
            
            delete("/administration/account/files/#{file_subject.id + 1 }.json")
            
            #respond with an error when id is not valid
            expect_response_with_not_found

            #validate error message
            expect(response_body).to be_a(Hash)
            expect(response_body).to have_key("message")
            expect(response_body["message"]).to be_a(String)

        end
    end 
end 
