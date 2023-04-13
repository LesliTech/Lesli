=begin

Copyright (c) 2023, all rights reserved.

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
