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

require "yaml"

module Lesli

    @@builder = ''
    @@engines = []
    @@modules = []
    @@settings = Hash.new
    @@settings_lesli = Hash.new
    @@settings_builder = Hash.new
    @@settings_server = Hash.new


    # Load settings files
    def Lesli.settings_load

        path = File.join("./engines", @@builder, "lesli.yml")

        begin 

            # Lesli core settings
            @@settings_lesli = YAML.load_file("./lesli.yml")

            # build path to lesli engine info file
            @@settings_builder = YAML.load_file(path) if File.exist?(path)

            # specific settings for server, override core and instance settings
            @@settings_server = YAML.load_file("./lesli.server.yml") if File.exist?(File.join("./lesli.server.yml"))

        rescue => e

            pp e
        end

    end


    # Get collection of installed engines (as code)
    def Lesli.engines

        return @@engines if @@engines.any?

        # return empty if engine folder does not exists
        return [] unless Dir.exist?("./engines")

        # search for the builder engine (main module)
        Dir.entries("./engines").each do |engine|

            # ignore non folders
            next if [".","..",".gitkeep"].include?(engine)

            # build path to lesli engine info file
            path = File.join("./engines", engine, "lesli.yml")

            # next if lesli engine info file does not exist
            next unless File.exist?(path)

            begin

                # get engine information from settings file
                engine_lesli_file = YAML.load_file(path)
            rescue  => error

                # next if lesli engine info file does not contain valid json data
                next
            end

            # current engine information lesli.yml file
            engine_info = engine_lesli_file["info"]

            # build engine code just converting the engine name to underscore
            engine_info["code"] = engine_info["name"].gsub(/(.)([A-Z])/,'\1_\2').downcase

            # save engine builder code
            @@builder = engine_info["code"] if engine_info["type"] == "builder"

            # next if engine name does not match
            next unless engine_info["code"] == engine

            # next if engines should not be loaded
            next unless engine_info["load"] == true

            # add engine to the installed engines collection
            @@engines.push({
                type: engine_info["type"] || "engine",
                code: engine_info["code"],
                name: engine_info["name"],
                version: "latest",
                github: {
                    url: "https://github.com/leitfaden/#{engine_info['code']}",
                    ssh: "git@github.com:leitfaden/#{engine_info['code']}.git",
                    ssh_backup: "git@github.com:LesliTech/#{engine_info['code']}.git"
                }
            })

        end

        @@engines

    end


    def Lesli.modules 

        gems = []

        return @@modules if @@modules.any?
        
        # defined empty array if no modules defined for builder
        if @@settings_server.key?("modules")

            # add required engine-gem like to the engines collection
            gems = @@settings_server["modules"].map do |gem|
                {
                    type: "gem",
                    code: gem[0],
                    name: gem[0].split('_').collect(&:capitalize).join, # Convert to CamelCase
                    version: gem[1]
                }
            end

        end

        @@modules = @@engines.clone

        # load gems into the engine collection
        gems.each do |gem|

            # ignore gem if is already in the engines collection as cloned repo
            next if @@modules.find { |modulo| modulo[:code] == gem[:code] }

            @@modules.push({
                type: "gem",
                code: gem[:code],
                name: gem[:name],
                version: gem[:version]
            })

        end

        @@modules

    end


    # Get the builder information
    def Lesli.instance

        name = "Lesli"
        code = "lesli"

        @@engines.each do |engine|
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

        return @@settings unless @@settings.empty?

        @@settings = @@settings_lesli.clone

        @@settings = deep_merge(@@settings, @@settings_builder)

        @@settings = deep_merge(@@settings, @@settings_server)

        # overwrite list of options
        if (@@settings_builder.dig("configuration", "locales"))
            @@settings["configuration"]["locales"] = @@settings_builder["configuration"]["locales"]
        end

        if (@@settings_server.dig("configuration", "locales"))
            @@settings["configuration"]["locales"] = @@settings_server["configuration"]["locales"]
        end

        # disable web push notifications by default if bell is not installed
        @@settings["security"]["enable_pushes"] = false if !defined?(CloudBell)

        # parse available locales for instance
        @@settings["configuration"]["locales_available"] = @@settings["configuration"]["locales"]

        # parse available locale codes for Rails
        @@settings["configuration"]["locales"] = @@settings["configuration"]["locales"].keys

        @@settings["engines"] = modules()

        @@settings["modules"] = modules()

        @@settings["instance"] = instance()

        @@settings["env"] = @@settings["env"][env]

        @@settings

    end



    # @param tgt [Hash] target hash that we will be **altering**
    # @param src [Hash] read from this source hash
    # @return the modified target hash
    # @note this one does not merge Arrays
    def Lesli.deep_merge(tgt_hash, src_hash)
        tgt_hash.merge!(src_hash) { |key, oldval, newval|
            if oldval.kind_of?(Hash) && newval.kind_of?(Hash)
                deep_merge(oldval, newval)
            else
                newval
            end
        }
    end


    # initialize settings files
    settings_load()

end
