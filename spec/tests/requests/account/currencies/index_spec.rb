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

        #def create_element
            #if it necesary, define a method to create and object and be sure the table will not be empty of data
        #end

        # test cases
        #one or more test could fail when first run them, verify the routes, controller locations and names
        #

        it "is expected to respond with successful" do
            
            #make sure you have created some elements before run test 
            #create_element

            get("/administration/account/currencies.json")

            #shared examples
            expect_response_with_successful

            #validate others custom values expected here

        end
    end
end
