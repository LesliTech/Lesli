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
    describe "GET:/administration/account/currencies.json", type: :request do
        include_context "request user authentication"

        # helper methods

        def create_element
            #if it necesary, define a method to create and object and be sure the table will not be empty of data
            @current_user.account.currencies.destroy_all

            #search posibles permit values to create an element
            params = Account::Currency.column_names
            params_hash_value = {}

            #cast column_names (its an Array) into a hash an insert values
            params.each do |value|
                if !((value.include? "id") || (value.include? "at") )
                    params_hash_value[value] = Faker::Lorem.word
                end
            end

            new_object =  @current_user.account.currencies.new({})
            new_object.attributes = params_hash_value.reject{|k,v| !new_object.attributes.keys.member?(k.to_s) }
            new_object.user_main_id = @current_user.id
            new_object.users_id = @current_user.id
            new_object.save!
            return new_object
        end

        # test cases
        #one or more test could fail when first run them, verify the routes, controller locations and names
        #

        it "is expected to respond with successful" do
            #make sure you have created some elements before run test 
            #create_element
            create_element

            get("/administration/account/currencies.json")

            #shared examples
            expect_response_with_successful

            #validate others custom values expected here
            expect(response_body).to be_a(Hash)

            expect(response_body).to have_key("pagination")
            expect(response_body["pagination"]).to have_key("total_pages")
            expect(response_body["pagination"]).to have_key("current_page")
            expect(response_body["pagination"]).to have_key("count_total")
            expect(response_body["pagination"]).to have_key("count_results")

            expect(response_body).to have_key("records")
            expect(response_body["records"]).to be_an(Array)
            expect(response_body["records"].first).to have_key("created_at_date")
            expect(response_body["records"].first).to have_key("updated_at_date")
            expect(response_body["records"].first).to have_key("created_at")
            expect(response_body["records"].first).to have_key("id")
            expect(response_body["records"].first).to have_key("name")
            expect(response_body["records"].first).to have_key("symbol")
            expect(response_body["records"].first).to have_key("country_alpha_3")
            expect(response_body["records"].first).to have_key("users_id")
            expect(response_body["records"].first).to have_key("user_main_id")
            expect(response_body["records"].first).to have_key("valid_from_text")
            expect(response_body["records"].first).to have_key("valid_to_text")
            expect(response_body["records"].first).to have_key("descriptive_name")
        end
    end
end
