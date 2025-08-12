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

Lesli · Ruby on Rails Development Platform.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// ·     
=end


# This module is mainly used as common helpers needed through
# the Core or engines extracting functionalities that take long
# to develop so we prefer to use it like a RSpec module helper

module LesliHelper

    # @param path [String] the location of the file you want to load
    # @return [FILE] image/JSON/HTML/CSV...
    # @description This method will look for the file according to the
    #   path given and return it so will be ready to use in the HTTP request
    # @example
    # RSpec.describe "POST:administration/account/files" do
    #     subject(:file_example) { lesli_fixture_file("spec/fixtures/files/lesli-icon.png") }
    #     it "..." do
    #         puts "/administration/account/files", params: { file: file_example }
    #     end
    # end
    def lesli_fixture_file path
        Rack::Test::UploadedFile.new(Rails.root.join(path))
    end
end

# Devise Rails 8 patch

require 'devise'

module Devise
    def self.mappings
        Rails.application.try(:reload_routes_unless_loaded)
        @@mappings
    end
end
