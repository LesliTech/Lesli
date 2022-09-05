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
    describe "PUT:/administration/account/currencies/:id.json", type: :request do
        include_context "request user authentication"

        # helper methods


        #def create_element
            #if it necesary, define a method to create and object and be sure the table will not be empty of data
        #end

        # test cases
        #one or more test could fail when first run them, verify the routes, controller locations and names
        #

        it "is expected to update record" do
            #make sure you have created some elements before run test and reference its id 
            #create_element

            #search posibles permit values to update an element
            params = Account::Currencie.column_names
            params_hash_value = {}
            params.each do |value|
                params_hash_value[value] =   Faker::Name.name
            end

            put("/administration/account/currencies/#{@account/currencies.id}.json", params: {
                #permit hash should have format "controller"_"module"
                account_currencie: params_hash_value
            })

            # shared examples
            expect_response_with_successful

            #validate others custom values expected here
            #@account/currencies_params.each do |key, value|
            #   expect(response_data[key.to_s]).to eq(value)
            #end
        end

        it "is expectd to respond with not found when an invalid ID is sent" do
            # this ID does not exist, so should return with not found
            #@invalid_id = create_element.last.id + 1

            put("/administration/account/currencies/#{@invalid_id}.json", params: {
                #permit hash should have format "controller"_"module"
                account_currencie: @account/currencies_params
            })

            # shared examples
            expect_response_with_not_found
        end

        it "is expected to update record when value is empty" do
            #make sure you have created some elements before run test and reference its id 
            #create_element

            #search posibles permit values to update an element
            params = Account::Currencie.column_names
            params_hash_empty = {}
            params.each do |value|
                params_hash_empty[value] =   ""
            end

            put("/administration/account/currencies/#{@account/currencies.id}.json", params: {
                #permit hash should have format "controller"_"module"
                account_currencie: params_hash_empty
            })

            # shared examples
            expect_response_with_successful

            #validate others custom values expected here
            #@account/currencies_params.each do |key, value|
            #   expect(response_data[key.to_s]).to eq(value)
            #end
        end

        it "is expected to update record when value is nil or undefine" do
            #make sure you have created some elements before run test and reference its id 
            #create_element

            #search posibles permit values to update an element
            params = Account::Currencie.column_names
            params_hash_nil = {}
            params.each do |value|
                params_hash_nil[value] =   ""
            end

            put("/administration/account/currencies/#{@account/currencies.id}.json", params: {
                #permit hash should have format "controller"_"module"
                account_currencie: params_hash_nil
            })

            # shared examples
            expect_response_with_error

            #validate others custom values expected here
            #@account/currencies_params.each do |key, value|
            #   expect(response_data[key.to_s]).to eq(value)
            #end
        end
    end
end

