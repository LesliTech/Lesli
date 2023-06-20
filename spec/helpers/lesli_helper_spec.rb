=begin

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

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
