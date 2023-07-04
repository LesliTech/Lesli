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

module LC

    module System

        class Info

            def self.instance
                Rails.application.config.lesli.dig(:instance)
            end

            def self.path
                instance_klass = instance()[:name].safe_constantize
                instance_klass::Engine.root
            end

            def self.revision(as_string: false)

                version = 0
                build = 0

                # Every instance (builder module) is loaded into the platform using the same
                # name of the engine
                instance = instance()[:name]

                if (instance != 'Lesli' and defined?(instance.safe_constantize))
                    version = instance.safe_constantize::VERSION
                    build = instance.safe_constantize::BUILD
                end

                return { version: version, build: build } if as_string == false
                return "version: #{version}, build: #{build}" if as_string == true

            end

            def self.revisions(as_string: false)

                revisions = {}

                Lesli::engines().each do |engine|

                    next if engine[:type] == "builder"

                    version = 0
                    build = 0

                    # Every module is loaded into the platform using the engine name
                    modulo = engine[:name]

                    if (defined?(modulo.safe_constantize))
                        begin
                            version = modulo.safe_constantize::VERSION
                            build = modulo.safe_constantize::BUILD
                        rescue => exception
                        end
                    end

                    if as_string == true
                        next
                    end

                    revisions[engine[:code]] = {
                        version: version,
                        build: build
                    }

                end

                revisions

            end

            def self.theme(property, value_if_nil=nil)
                Rails.application.config.lesli.dig(:theme, property) || value_if_nil
            end

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

end
