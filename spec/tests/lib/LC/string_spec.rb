=begin

Copyright (c) 2023, all rights reserved.

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


RSpec.describe LC::String do

    it "should sanitize a simple string" do 
        string = LC::String.sanitize("Luis")
        expect(string).to eql("Luis")
    end

    it "should sanitize a string removing symbol" do 
        string = LC::String.sanitize("Luis%")
        expect(string).to eql("Luis")
    end

    it "should sanitize a string removing symbol in the middle" do 
        string = LC::String.sanitize("Luis%Donis")
        expect(string).to eql("LuisDonis")
    end

    it "should sanitize a string with numbers" do 
        string = LC::String.sanitize("Luis 18")
        expect(string).to eql("Luis 18")
    end

    it "should sanitize a \"nil\" string" do 
        string = LC::String.sanitize(nil)
        expect(string).to eql("")
    end

    it "should sanitize a empty string" do 
        string = LC::String.sanitize("")
        expect(string).to eql("")
    end

    it "should sanitize numbers" do 
        string = LC::String.sanitize("12345")
        expect(string).to eql("12345")
    end

    it "should sanitize with spaces" do 
        string = LC::String.sanitize("1 2 3 4 5")
        expect(string).to eql("1 2 3 4 5")
    end

end
