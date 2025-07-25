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


# · 
require Lesli::Engine.root.join("lib/rspec/helpers/rails_helper")
require Lesli::Engine.root.join("lib/rspec/helpers/lesli_helper")
require Lesli::Engine.root.join("lib/rspec/helpers/response_request_helper")


# · Dynamically build a path where the engine is mounted
def build_engine_path(engine_name, path)

    # get the engine information
    engine = LesliSystem.engine(engine_name)

    # return the path if no engine found
    return path unless engine

    engine_constant = engine[:name].constantize

    # build the path inside the engine mounted path
    "#{engine_constant::Engine.routes.find_script_name({})}/#{path}"
end


# · Authentication context
RSpec.shared_context "request user authentication" do

    # Creates a new valid user session
    before(:each) do
        @query = {
            search: "",
            filters: {},
            pagination: {
                perPage: 15,
                page: 1,
                order: "desc",
                orderBy: "id",
                orderColumn: "id"
            }
        }

        @current_user = FactoryBot.create(:lesli_user)
        sign_in(@current_user)
    end
end


# · Configuration
RSpec.configure do |config|

    # Include devise helpers to be able to login on test runtime
    config.include Devise::Test::IntegrationHelpers

    # Include helper methods
    config.include ResponseRequestHelper

    config.before(:each, type: :request) do
        #host! 'localhost:3000'
        #default_url_options[:host] = 'https://localhost:3000'
    end

end
