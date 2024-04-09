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

Lesli · Ruby on Rails SaaS Development Framework.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

module Lesli
    class AboutsController < ApplicationLesliController

        # GET /status
        def show

            # get installed engines
            @lesli_engines = Lesli::System.engines.map { |engine, engine_info|
                {
                    :name => engine_info[:name],
                    :code => engine_info[:code],
                    :path => engine_info[:path],
                    :version => engine_info[:version],
                    :build => engine_info[:build]
                }
            }
    
            respond_to do |format|
                format.html {}
                format.json { 
                    if Rails.env.production?
                        respond_with_successful({ :Lesli => "Ruby on Rails SaaS Development Framework."}) 
                    else
                        respond_with_successful(@lesli_engines) 
                    end
                }
            end
        end
    end
end
