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
    describe "POST:/administration/account/currencies.json", type: :request do
        include_context "request user authentication"

        # test cases
        #one or more test could fail when first run them, verify the routes, controller locations and names
        #

        it "is expected to test the creation of the record with values" do

            #search posibles permit values to create an element
            params = Account::Currency.column_names
            params_hash_value = {}
            puts "parametros de tabla #{params}"


            #cast column_names (its an Array) into a hash an insert values
            params.each do |value|
                if !(value.include? "id")
                    params_hash_value[value] = Faker::Name.name
                end
            end
            
            puts "parametros de tabla como hash #{params_hash_value}"
            post("/administration/account/currencies.json", params: {
                #permit name hash should have format "controller"_"module"
                account_currency: params_hash_value
            })

            #shared examples
            expect_response_with_successful

            # validate others custom values expected here

        end

        it "is expected to test the creation of the record with empty values" do

            #search posibles permit values to create an element
            params = Account::Currency.column_names
            params_hash_empty = {}
            
            #search posibles permit values to create an element
            params.each do |value|
                #assing empty values to test parameters
                params_hash_empty[value] =  ""
            end

            post("/administration/account/currencies.json", params: {
                account_currency: params_hash_empty
                #permit hash should have format "controller"_"module"
            })

            #shared examples
            #should respond with error when parameters are empty
            expect_response_with_error

            # validate others custom values expected here

        end

        it "is expected to test the creation of the record with empty values" do

            #search posibles permit values to create an element
            params = Account::Currency.column_names
            params_hash_nil = {}

            #search posibles permit values to create an element
            params.each do |value|
                #assing nil values to test parameters
                params_hash_nil[value] =  nil
            end

            post("/administration/account/currencies.json", params: {
                account_currency: params_hash_nil
                #permit hash should have format "controller"_"module"
            })

            # shared examples
            # should respond with error when parameters are nil or undefine
            expect_response_with_error

            # validate others custom values expected here

        end
    end
end
