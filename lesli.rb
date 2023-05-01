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

require "yaml"

module Lesli

    @@builder = ''
    @@engines = []
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

        # list of required gems
        gems = []

        # list of installed engines (cloned repos)
        engines = []

        # return list of engines if found
        return @@engines if @@engines.any?

        settings_load()

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
            engines.push({
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


        # load gems into the engine collection
        gems.each do |gem|

            # ignore gem if is already in the engines collection as cloned repo
            next if engines.find { |engine| engine[:code] == gem[:code] }

            engines.push({
                type: "gem",
                code: gem[:code],
                name: gem[:name],
                version: gem[:version]
            })

        end

        @@engines = engines.clone

    end


    # Get the builder information
    def Lesli.instance

        name = "Lesli"
        code = "lesli"

        engines().each do |engine|
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

        settings_load()

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

        @@settings["engines"] = engines()

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

end
