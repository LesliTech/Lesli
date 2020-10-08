=begin

Copyright (c) 2020, all rights reserved.

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
        
            def self.revision(as_string: false)

                version = 0
                build = 0
        
                # Every instance (builder module) is loaded into the platform using the same 
                # name of the engine
                instance = Rails.application.config.lesli_settings["instance"]

                if defined?(instance.safe_constantize)
                    version = instance.safe_constantize::VERSION
                    build = instance.safe_constantize::BUILD
                end
        
                return { version: version, build: build , instance: instance} if as_string == false
                return "version: #{version}, build: #{build}, instance: #{instance}" if as_string == true

            end

        end

    end

end
