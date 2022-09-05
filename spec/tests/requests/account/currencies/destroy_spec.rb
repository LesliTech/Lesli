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
    describe "DELETE:/administration/account/currencies/:id.json", type: :request do
        include_context "request user authentication"
        
        # helper methods

        #def create_element
            #if it necesary, define a method to create and object and be sure the table will not be empty of data
        #end

        # test cases
        #one or more test could fail when first run them, verify the routes, controller locations and names
        #

        it "is expected that the record has been removed from the database" do
             #make sure you have created some elements before run test and reference its id 
            #create_element

            #test will fail if element id does not exist
            #please be sure the element searched exist creating the elemnt before run tests
            delete("/administration/account/currencies/#{@account/currencies.id}.json")

            #shared examples
            expect_response_with_successful

            #validate others custom values expected here

        end

        it "is expected to respond with not found when an invalid ID is sent" do
            
            #this ID does not exist, so should return with not found
            #@invalid_id = create_element.last.id + 1
            #before run test, you must create an object of the class youll like to test

            #test will fail if element id exist
            delete("/administration/account/currencies/#{@invalid_id}.json")
            
            # shared examples
            # this ID does not exist, so should return with not found
            expect_response_with_not_found

            #validate others custom values expected here

        end
    end
end
