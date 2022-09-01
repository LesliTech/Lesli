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
    describe "PUT:/administration/account/locations/:id.json", type: :request do
        include_context "request user authentication"

        # helper methods


        #def create_record(record_params)
            #define a method to create and object and be sure the table will not be empty of data
        #end

        # test cases

        it "is expected to update record" do
            #@account/locations = create_record({})
            #before run test, you must create an object of the class youll like to test

            params = Account::Location.column_names
            params_hash_value = {}
            params.each do |value|
                params_hash_value[value] =   Faker::Name.name
            end

            put("/administration/account/locations/#{@account/locations.id}.json", params: {
                #account/locations: params_hash_value
            })

            # shared examples
            expect_response_with_successful

            # custom examples
            #@account/locations_params.each do |key, value|
            #   expect(response_data[key.to_s]).to eq(value)
            #end
        end

        it "is expectd to respond with not found when an invalid ID is sent" do
            #@invalid_id = create_record({}).id + 1
            #before run test, you must create an object of the class youll like to test

            put("/administration/account/locations/#{@invalid_id}.json", params: {
                #account/locations: @account/locations_params
            })

            # shared examples
            expect_response_with_not_found
        end

        it "is expected to update record when value is empty" do
            #@account/locations = create_record({})
            #before run test, you must create an object of the class youll like to test

            params = Account::Location.column_names
            params_hash_empty = {}
            params.each do |value|
                params_hash_empty[value] =   ""
            end

            put("/administration/account/locations/#{@account/locations.id}.json", params: {
                #account/locations: params_hash_empty
            })

            # shared examples
            expect_response_with_successful

            # custom examples
            #@account/locations_params.each do |key, value|
            #   expect(response_data[key.to_s]).to eq(value)
            #end
        end

        it "is expected to update record when value is nil or undefine" do
            #@account/locations = create_record({})
            #before run test, you must create an object of the class youll like to test

            params = Account::Location.column_names
            params_hash_nil = {}
            params.each do |value|
                params_hash_nil[value] =   ""
            end

            put("/administration/account/locations/#{@account/locations.id}.json", params: {
                #account/locations: params_hash_nil
            })

            # shared examples
            expect_response_with_error
        end
    end
end

