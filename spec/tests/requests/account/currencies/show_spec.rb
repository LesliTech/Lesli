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
    describe "GET:/administration/account/currencies/:id.json", type: :request do
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
                #avoid fill id and date values
                if !((value.include? "id") || (value.include? "at") )
                    params_hash_value[value] = Faker::Lorem.word
                end
            end

            #create new object
            new_object =  @current_user.account.currencies.new({})

            #avoid  unknown attribute when create objects
            new_object.attributes = params_hash_value.reject{|k,v| !new_object.attributes.keys.member?(k.to_s) }
            new_object.user_main_id = @current_user.id
            new_object.users_id = @current_user.id
            #save object
            new_object.save!
            return new_object
        end
        
        # test cases
        #one or more test could fail when first run them, verify the routes, controller locations and names
        #

        it "is expected to respond with the record data" do
            #make sure you have created some elements before run test and reference its id 
            account_object = create_element

            get("/administration/account/currencies/#{account_object.id}.json")

            # shared examples
            expect_response_with_successful

        end

        it "is expected to respond with not found when an invalid ID is sent" do
            # this ID does not exist, so should return with not found
            invalid_id = @current_user.account.currencies.last.id + 1

            #before run test, you must create an object of the class youll like to test

            #test will fail if element id exist
            get("/administration/account/currencies/#{invalid_id}.json")

            # shared examples
            # this ID does not exist, so should return with not found
            expect_response_with_not_found

            # validate others custom values expected here
            expect(response_body).to have_key("message")
            expect(response_body["message"]).to be_a(String)
        end
    end
end
