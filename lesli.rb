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

    def Lesli.engines

        engines = []

        builder_engines = []
        
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

            # next if engines should not be loaded
            next if engine_info['load'] == false

            # check if engine is a builder
            if engine_info['type'] == 'builder'
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
        lesli_settings = YAML.load_file(File.join("./config", "settings.yml"))[Rails.env]

        instance_settings = {}

        instance_engine = nil

        instance_engine = "CloudHaus" if defined?(CloudHaus)

        if instance_engine
            instance_engine = File.join("./engines", instance_engine, "config", "settings.yml")
            platform_settings = YAML.load_file(instance_engine)[Rails.env]
            
            # location: config/application.rb
            lesli_settings['i18n_default_locale'] = platform_settings['i18n_default_locale'] if not platform_settings['i18n_default_locale'].blank?

        end
    
        lesli_settings

    end

end
