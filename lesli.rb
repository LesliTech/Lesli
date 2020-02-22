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

LesliCloud - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@license  Propietary - all rights reserved.
@version  0.1.0-alpha

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

require 'json'

module Lesli

    def Lesli.app

        app = { 
            instance: "LesliCloud"
        }

        # default for Deutsche Leibrenten
        if File.exist?(".deutsche-leibrenten")
            app[:instance] = "DeutscheLeibrenten"
        end

        app

    end

    def Lesli.engines

        engines = []
        
        Dir.entries("./engines").each do |entry|
            
            # next if entry is not an engine
            next if entry == "."
            next if entry == ".."
            next if entry == ".gitkeep"

            # build path to lesli engine info file
            path = File.join("./engines", entry, "lesli.json")
            
            # next if lesli engine info file does not exist
            next unless File.exist?(path)
            
            # next if lesli engine info file does not contain valid json data
            begin
                engine_info = JSON.parse(File.read(path))
            rescue JSON::ParserError
                next
            end

            # next if engine name does not match
            next unless engine_info['name'] == entry

            engines.push(engine_info)

        end

        engines

    end

end
