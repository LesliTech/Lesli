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

require "yaml"

module Lesli

    def Lesli.engines

        engines = []

        builder_engines = []
        
        return [] if not Dir.exist?("./engines")

        Dir.entries("./engines").each do |engine|
            
            # next if engine is not an engine
            next if engine == "."
            next if engine == ".."
            next if engine == ".gitkeep"

            # build path to lesli engine info file
            path = File.join("./engines", engine, "lesli.yml")

            # next if lesli engine info file does not exist
            next unless File.exist?(path)

            # next if lesli engine info file does not contain valid json data
            begin
                # get engine information from settings file
                engine_info = YAML.load_file(path)["info"]
            rescue  => error
                next
            end

            # next if engine name does not match
            next unless engine_info["code"] == engine

            # next if engines should not be loaded
            next if engine_info["load"] == false

            # check if engine is a builder
            if engine_info["type"] == "builder"
                builder_engines.push(engine_info)
                next
            end

            engines.push(engine_info)

        end

        # put builders at the end of the engines list
        builder_engines.each do |builder_engine|
            engines.push(builder_engine)
        end

        engines

    end

    def Lesli.instance

        name = "Lesli"
        code = "lesli"
        version = "~> 0.0.2"
        local_engines = false

        name = ENV['LESLI_INSTANCE_NAME'] unless ENV['LESLI_INSTANCE_NAME'].nil?
        code = ENV['LESLI_INSTANCE_CODE'] unless ENV['LESLI_INSTANCE_CODE'].nil?
        version = ENV['LESLI_INSTANCE_VERSION'] unless ENV['LESLI_INSTANCE_VERSION'].nil?

        engines.each do |engine|
            next if engine["type"] != "builder"
            name = engine["name"]
            code = engine["code"]
            local_engines = true
            break
        end

        {
            "name": name,
            "code": code,
            "version": version,
            "local_engines": local_engines
        }

    end

    def Lesli.settings env="development"

        # Lesli core settings
        lesli_settings = YAML.load_file("./lesli.yml")

         # get Lesli instance (builder engine)
         instance_engine = instance()

        # specific settings for dedicated on-premises instance (not core)
        if instance_engine[:name] != "Lesli"
    
            # get the settings from instance 
            # this file should be an exact copy of the one in the core
            # all the settings will be overrided by the settings in the builder engine
            instance_klass = instance_engine[:name].safe_constantize
            unless instance_klass
                raise Exception.new "The gem of the lesli instance is not installed, instance: #{instance_engine[:name]}"
            end
            instance_settings = YAML.load_file("#{instance_klass::Engine.root}/lesli.yml")

            # overwrite core settings with specific settings from instance
            lesli_settings = lesli_settings.merge(instance_settings) 

        end

        # parse available locales for instance
        lesli_settings["configuration"]["locales_available"] = lesli_settings["configuration"]["locales"]
        lesli_settings["configuration"]["locales"] = lesli_settings["configuration"]["locales"].keys

        lesli_settings["engines"] = engines

        lesli_settings["instance"] = instance

        lesli_settings["env"] = lesli_settings["env"][env]

        return lesli_settings

    end
end
