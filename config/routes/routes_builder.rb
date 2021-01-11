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

module RoutesBuilder
    def self.extended(router)
        if Lesli::instance[:name] != "Lesli"
            router.instance_exec do

                #settings = Rails.configuration.lesli_settings
                #return unless File.exists?("./engines/#{settings["info"]["name"]}/routes.rb")
                #require "./engines/#{settings["info"]["name"]}/routes"

                instance_klass = Rails.application.config.lesli_settings["instance"][:name].safe_constantize
                return unless instance_klass
                return unless File.exists?("#{instance_klass::Engine.root}/routes.rb")

                require "#{instance_klass::Engine.root}/routes"

                extend RoutesEngine
            end
        end
    end
end
