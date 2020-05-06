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

    def Lesli.settings  

        # Lesli core settings
        lesli_settings = YAML.load_file("./lesli.yml")

        # add engine information into env section
        lesli_settings[Rails.env]["info"] = lesli_settings["info"]

        # overwrite settings with env version
        lesli_settings = lesli_settings[Rails.env]

        instance_settings = {}

        # get Lesli instance (builder engine)
        instance_engine = instance

        # specific settings for dedicated on-premises instance
        if instance_engine != "Lesli" # not core
            
            # get settings from instance
            platform_settings = YAML.load_file(File.join("./engines", instance_engine, "lesli.yml"))

            # add instance information into env section
            platform_settings[Rails.env]["info"] = platform_settings["info"]

            # overwrite settings with env version
            platform_settings = platform_settings[Rails.env]

            # overwrite core settings
            platform_settings.each do |key, value|

                if value.class.to_s == "Hash"

                    value.each do |subkey, subvalue|
                        lesli_settings[key][subkey] = subvalue
                    end

                    next
                    
                end

                lesli_settings[key] = value

            end

        end

        lesli_settings["engines"] = engines

        lesli_settings

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
