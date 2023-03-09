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
require "rails_helper"


RSpec.describe "Lesli.rb" do

    it "should return a list of installed engines" do 
        engines = Lesli::engines()
        expect(engines).to be_an(Array)
    end

    it "should return lesli locales from lesli.yml" do 
        configuration = Rails.configuration.lesli.dig(:configuration)

        expect(configuration[:locales]).to include("en")
        expect(configuration[:locales]).to be_an(Array)
        expect(configuration[:locales_available]).to be_a(Hash)

        expect(configuration[:locales_available]).to have_key(:en)
        expect(configuration[:locales_available][:en]).to eql("English")
    end

end
