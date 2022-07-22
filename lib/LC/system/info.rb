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

            def self.sass_variables_by_instance
                instance_code = instance()[:code]
                return "lesli3/settings/variables" if instance_code
                return "#{instance_code}/lesli/variables"
            end

            def self.instance
                Rails.application.config.lesli[:instance]
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

        end

    end

end
