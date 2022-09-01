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
    describe "DELETE:/administration/account/locations/:id.json", type: :request do
        include_context "request user authentication"
        
        # helper methods

        #def create_record(record_params)
            #define a method to create and object and be sure the table will not be empty of data
        #end

        # test cases

        it "is expected that the record has been removed from the database" do
            #@account/locations = create_record({})
            #before run test, you must create an object of the class youll like to test

            delete("/administration/account/locations/#{@account/locations.id}.json")

            # shared examples
            expect_response_with_successful

        end

        it "is expected to respond with not found when an invalid ID is sent" do
            # this ID does not exist, so should return with not found
            #@invalid_id = create_record({}).id + 1

            delete("/administration/account/locations/#{@invalid_id}.json")
            
            # shared examples
            expect_response_with_not_found
        end
    end
end
