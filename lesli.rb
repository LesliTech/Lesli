=begin

Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

Lesli - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  <hello@lesli.tech>
@website  <https://lesli.tech>
@license  Propietary - all rights reserved.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

require "yaml"

module Lesli

    def Lesli.engines

        engines = []

        builder_engines = []
        
        return [] if not Dir.exist?("./engines")

        Dir.entries("./engines").each do |entry|
            
            # next if entry is not an engine
            next if entry == "."
            next if entry == ".."
            next if entry == ".gitkeep"

            # build path to lesli engine info file
            path = File.join("./engines", entry, "lesli.yml")

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
            next unless engine_info["name"] == entry

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

    def Lesli.settings env="development"

        # Lesli core settings
        lesli_settings = YAML.load_file("./lesli.yml")

        # Get Lesli development user
        lesli_development_user = lesli_settings["configuration"]["security"]["login"]

        # get Lesli instance (builder engine)
        instance_engine = instance

        # specific settings for dedicated on-premises instance (not core)
        if instance_engine != "Lesli" 
    
            # get the settings from instance 
            # this file should be an exact copy of the one in the core
            # all the settings will be overrided by the settings in the builder engine 
            instance_settings = YAML.load_file(File.join("./engines", instance_engine, "lesli.yml"))

            # overwrite core settings with specific settings from instance
            lesli_settings = lesli_settings.merge(instance_settings)

            # include default Lesli user for development environment
            if env != "production"
                lesli_settings["configuration"]["security"]["login"].push(lesli_development_user[0])
            end

        end

        # parse available locales for instance
        lesli_settings["configuration"]["locales_available"] = lesli_settings["configuration"]["locales"]
        lesli_settings["configuration"]["locales"] = lesli_settings["configuration"]["locales"].keys

        lesli_settings["engines"] = engines

        lesli_settings["env"] = lesli_settings["env"][env]

        return lesli_settings

    end

    def Lesli.instance  

        instance = "Lesli"

        engines.each do |engine|
            next if engine["type"] != "builder"
            instance = engine["name"]
            break
        end

        instance
        
    end

end
