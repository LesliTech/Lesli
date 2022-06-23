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


# · 
require "rails_helper"


# · 
RSpec.describe LesliHelper do

    it "must return the lesli_instance_code" do
        expect(helper.lesli_instance_code).to eql('lesli_cloud') if defined?(LesliCloud)
        expect(helper.lesli_instance_code).to eql('deutsche_leibrenten') if defined?(DeutscheLeibrenten)
    end

    it "must return the lesli_engine" do
        expect(helper.lesli_engine).to eql('lesli')
    end

    it "check if lesli administration" do
        expect(helper.is_lesli_administration?).to eql(false)
    end

end
