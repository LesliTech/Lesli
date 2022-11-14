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