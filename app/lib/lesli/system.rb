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
    class System
        ENGINES = {}

        # engine("LesliAdmin")
        # engine("LesliAdmin", "name")
        def self.engine(engine, property=nil)

            engine = engine.camelize

            engines() if ENGINES.empty?

            # the Root engine represents the host Rails app
            engine = "Root" unless LESLI_ENGINES.include?(engine)

            # return specific property if requested
            return ENGINES[engine][property.to_sym] unless property.blank?

            # return the engine info
            return ENGINES[engine]
        end


        # Lesli::System.engines()
        # Lesli::System.engines(:local => true)
        def self.engines local: false

            return ENGINES unless ENGINES.empty?

            # due we do not know the engine mounted path we have to look up for it every
            # time we load the html view so we can use the dynamic route from the main rails app
            # we use this in the url plugin 
            LESLI_ENGINES.each do |engine|

                # skip if engine is not installed
                next unless Object.const_defined?(engine)

                # convert engine name to Ruby object
                engine_instance = "#{engine}".constantize

                # check if engines installed locally are required
                if local 

                    # build the path were engines should be installed
                    engine_local_path = Rails.root.join("engines", engine)

                    # do not include engines if not is locally installed
                    next unless File.exist?(engine_local_path)
                end
                
                # engine completelly information
                ENGINES[engine] = {
                    :code => engine.underscore, 
                    :name => engine, 
                    :path => engine_instance::Engine.routes.find_script_name({}),
                    :version => engine_instance::VERSION,
                    :build => engine_instance::BUILD,
                    :dir => Gem::Specification.find_by_name(engine.underscore).gem_dir
                }
            end 

            # also include the rails main_app
            ENGINES["Root"] = {
                :code => "root", 
                :name => "Root", 
                :path => "/",
                :version => "1.0.0",
                :build => "0000000",
                :dir => Rails.root.to_s
            }

            ENGINES
        end

        private 

        LESLI_ENGINES = [
            "Lesli", 
            "LesliBell", 
            "LesliAdmin", 
            "LesliBabel", 
            "LesliAudit", 
            "LesliShield", 
            "LesliLetter",
            "LesliSupport",
            "LesliSecurity",
            "LesliCalendar",
            "LesliDashboard"
        ]
    end
end
