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

            # return specific property if requested
            return ENGINES[engine][property.to_sym] unless property.blank?

            # return the engine info
            return ENGINES[engine]
        end

        def self.engines 

            return ENGINES unless ENGINES.empty?

            # due we do not know the engine mounted path we have to look up for it every
            # time we load the html view so we can use the dynamic route from the main rails app
            # we use this in the url plugin 
            LESLI_ENGINES.each do |engine|
                next unless Object.const_defined?(engine)
                engine_instance = "#{engine}".constantize
                ENGINES[engine]= {
                    :code => engine.underscore, 
                    :name => lesli_engine_name(engine), 
                    :path => engine_instance::Engine.routes.find_script_name({}),
                    :version => engine_instance::VERSION,
                    :build => engine_instance::BUILD,
                    :dir => Gem::Specification.find_by_name(engine.underscore).gem_dir
                }
            end 

            ENGINES
        end

        private 

        # Prints the name of the engine
        def self.lesli_engine_name engine
            name = engine.camelcase
            return "Lesli" if name == "Lesli"
            name.sub("Lesli", "")
        end

        LESLI_ENGINES = [
            "Lesli", 
            "LesliAdmin", 
            "LesliBabel", 
            "LesliAudit", 
            "LesliBell", 
            "LesliShield", 
            "LesliSecurity",
            "LesliLetter",
            "LesliSupport",
            "LesliCalendar",
            "LesliDashboard"
        ]
    end
end
