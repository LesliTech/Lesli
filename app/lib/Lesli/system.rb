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

module Lesli

    class System

        # instance information container
        # example hash:
        # type: "builder",
        # name: "LesliBuilder",
        # code: "lesli_builder",
        # version: "2.0.0"
        @@instance

        # get the instance information from builder
        def self.instance
            @@instance ||= Rails.application.config.lesli.dig(:instance)
        end

        # get engine installation path
        def self.path
            instance_klass = instance()[:name].safe_constantize
            instance_klass::Engine.root
        end

        # get compiled and parsed Lesli general settings
        def self.settings
            Rails.application.config.lesli
        end

        # get revision (version & build number)
        def self.revision(as_string: false)

            version = 0
            build = 0

            # Every instance (builder module) is loaded into the platform using the same
            # name of the engine
            instance = instance()[:name]
            instance_const = instance.safe_constantize

            if (instance != "Lesli" and defined?(instance_const))
                version = instance_const::VERSION
                build = instance_const::BUILD
            end

            return { version: version, build: build } if as_string == false
            return "version: #{version}, build: #{build}" if as_string == true

        end

        # get revision for all the installed engines (version & build number)
        def self.revisions(as_string: false)

            revisions = []

            Rails.application.config.lesli.dig(:engines).each do |engine|

                next if engine[:type] == "builder"

                version = 0
                build = 0

                # Every module is loaded into the platform using the engine name
                modulo = engine[:name]
                modulo_const = modulo.safe_constantize

                if (defined?(modulo_const))
                    begin
                        version = modulo_const::VERSION
                        build = modulo_const::BUILD
                    rescue => exception
                        version = "version error"
                        build = "build error"
                    end
                end

                # currently we dont have support for string format
                next if as_string == true

                # build revision hash for current engine
                revisions.push({
                    version: version,
                    build: build
                })

            end

            revisions

        end

        # get revision for all the installed engines (version & build number)
        def self.engines
            Rails.application.config.lesli.dig(:engines)
        end

        # return color customization from lesli.yml
        def self.theme(property, value_if_nil=nil)
            Rails.application.config.lesli.dig(:theme, property) || value_if_nil
        end

        # return the path to a custom theme.scss file in a builder engine
        def self.sass_instance_file(file, default="templates/empty")
            instance_code = instance()[:code]

            # path for import in SASS files
            path_sass = "#{instance_code}/#{file}"

            # path of file in disk, absolute path to the source file
            path_full = Rails.root.join("engines", instance_code, "app", "assets", "stylesheets", path_sass + ".scss")

            # check if customization.scss file exists
            exists = File.exist?(path_full)

            # return the file to the path only if it exists
            return path_sass if exists

            # return an empty file to avoid SASS @import errors
            return default
            
        end

    end
end
