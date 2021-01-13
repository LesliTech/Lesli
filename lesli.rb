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

        # list of installed builders, engines and gems
        engines = []

        # builder lesli.yml file configuration
        builder_lesli_file = {}
        
        # return empty if engine folder does not exists
        return [] if not Dir.exist?("./engines")

        # search for the builder engine (main module)
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
                engine_lesli_file = YAML.load_file(path)
            rescue  => error
                next
            end

            # current engine information lesli.yml file
            engine_info = engine_lesli_file["info"]

            # save copy of lesli.yml of the builder engine
            builder_lesli_file = engine_lesli_file if engine_info["type"] == "builder"

            # next if engine name does not match
            next unless engine_info["code"] == engine

            # next if engines should not be loaded
            next unless engine_info["load"] == true

            # add engine to the installed engines collection
            engines.push({
                type: engine_info["type"] || "engine",
                code: engine_info["code"],
                name: engine_info["name"],
                version: "latest",
                github: engine_info["github"]
            })

        end

        return engines unless builder_lesli_file.has_key?("modules")

        # add required engine-gem like to the engines collection
        builder_lesli_file["modules"].each do |gem|

            # if required gem is already in the engines collection
            next if engines.find { |engine| engine[:code] == gem[0]}

            # add gem to the installed engines collection
            engines.push({
                type: "gem",
                code: gem[0],
                name: gem[0].split('_').collect(&:capitalize).join, # Convert to CamelCase
                version: gem[1]
            })
            
        end

        engines

    end

    def Lesli.instance

        name = "Lesli"
        code = "lesli"

        engines = engines()

        engines.each do |engine|
            next if engine[:type] != "builder"
            name = engine[:name]
            code = engine[:code]
            break
        end

        {
            "name": name,
            "code": code
        }

    end

    def Lesli.settings env="development"

        # Lesli core settings
        lesli_settings = YAML.load_file("./lesli.yml")

        # get Lesli instance (builder engine)
        instance_engine = instance()

        # specific settings for dedicated on-premises instance (not core)
        if instance_engine[:name] != "Lesli"

            instance_settings = YAML.load_file(File.join("./engines", instance_engine[:code], "lesli.yml"))

            # overwrite core settings with specific settings from instance
            lesli_settings = lesli_settings.merge(instance_settings) 

        end

        # parse available locales for instance
        lesli_settings["configuration"]["locales_available"] = lesli_settings["configuration"]["locales"]
        lesli_settings["configuration"]["locales"] = lesli_settings["configuration"]["locales"].keys

        lesli_settings["engines"] = engines()

        lesli_settings["instance"] = instance()

        lesli_settings["env"] = lesli_settings["env"][env]

        lesli_settings

    end
end
