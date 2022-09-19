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


RSpec.describe LC::Sql do

    it "should sanitize a simple string for like query" do 
        sql = LC::Sql.sanitize_for_like("Luis")
        expect(sql).to eql("%luis%")
    end

    it "should sanitize a compound string for like query" do 
        sql = LC::Sql.sanitize_for_like("Luis Donis")
        expect(sql).to eql("%luis%donis%")
    end

    it "should sanitize a string with percentage sign for like query" do 
        sql = LC::Sql.sanitize_for_like("Luis%Donis")
        expect(sql).to eql("%luis\\%donis%")
    end

    it "should sanitize a string with percentages sign for like query" do 
        sql = LC::Sql.sanitize_for_like("%Luis%Donis%")
        expect(sql).to eql("%\\%luis\\%donis\\%%")
    end

    it "should sanitize a string with underscore for like query" do 
        sql = LC::Sql.sanitize_for_like("Luis_Donis")
        expect(sql).to eql("%luis\\_donis%")
    end

end
