=begin

Copyright (c) 2020, all rights reserved.

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


# include helpers, configuration & initializers for request tests
require "lesli_service_helper"


RSpec.describe LesliService do

    before(:each) do
        @lesli_service = LesliService.new(User.first)
    end

    it "is expected to return only the authorized methods for services" do

        lesli_service_methods = [
            :find,
            :list,
            :index,
            :show,
            :create,
            :update,
            :delete,
            :found?,
            :successful?,
            :errors,
            :errors_as_sentence,
            :error,
            :result
        ]

        expect(lesli_service_methods).to match_array(LesliService.instance_methods(false))

    end

    it "is expected to return successful? true if no errors found" do 

        expect(@lesli_service.successful?).to eql(true)

    end 

    it "is expected to return successful? false if errors found" do 

        @lesli_service.error("Testing errors")
        expect(@lesli_service.successful?).to eql(false)

    end 

    it "is expected to return an empty array of errors if no errors found" do 

        expect(@lesli_service.errors).to eql([])

    end 

    it "is expected to return an empty string of errors if no errors found" do 

        expect(@lesli_service.errors_as_sentence).to eql("")

    end 

    it "is expected to return an array of errors" do 

        @lesli_service.error("First error")
        @lesli_service.error("Second error")
        expect(@lesli_service.errors).to eql(["First error", "Second error"])

    end 

    it "is expected to return a string of errors" do 

        @lesli_service.error("First error")
        @lesli_service.error("Second error")
        expect(@lesli_service.errors_as_sentence).to eql("First error and Second error")

    end 

end
