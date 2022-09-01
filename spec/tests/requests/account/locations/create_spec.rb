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
    describe "POST:/administration/account/locations.json", type: :request do
        include_context "request user authentication"

        # test cases

        it "is expected to test the creation of the record with values" do
            #@account/locations_params = {}

            params = Account::Location.column_names
            params_hash_value = {}
            params.each do |value|
                params_hash_value[value] =   Faker::Name.name
            end
            

            post("/administration/account/locations.json", params: {
                #account/locations: params_hash_value
            })

            # shared examples
            expect_response_with_successful

        end

        it "is expected to test the creation of the record with empty values" do
            #@account/locations_params = {}

            params = Account::Location.column_names
            params_hash_empty = {}
            params.each do |value|
                params_hash_empty[value] =  ""
            end

            post("/administration/account/locations.json", params: {
                #account/locations: params_hash_empty
            })

            # shared examples
            expect_response_with_successful


        end

        it "is expected to test the creation of the record with empty values" do
            #@account/locations_params = {}

            params = Account::Location.column_names
            params_hash_nil = {}
            params.each do |value|
                params_hash_nil[value] =  nil
            end

            post("/administration/account/locations.json", params: {
                #account/locations: params_hash_nil
            })

            # shared examples
            expect_response_with_error

        end
    end
end
