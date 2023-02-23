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

class LesliServicesGenerator < Rails::Generators::NamedBase
    source_root File.expand_path("templates", __dir__)

    desc "This generator creates the respective service based on Lesli conventions"

    def main
        @license = File.read(Rails.root.join("license")).to_s.force_encoding("ASCII-8BIT")
        @object_information = object_information()
    end

    def create_service
        destination_path = "#{@object_information[:service_path]}.rb"
        
        if @object_information[:engine].eql? "core"
            module_association = "." 
        else
            module_association = ".#{@object_information[:engine]}."
        end


        copy_file("lesli_services.rb", destination_path)
        gsub_file(destination_path, "[[license]]", @license)
        gsub_file(destination_path, "[[service_name]]", @object_information[:service_name])
        gsub_file(destination_path, "[[engine]]", module_association)
        gsub_file(destination_path, "[[object_name_plural]]", @object_information[:object_name_plural])
        gsub_file(destination_path, "[[object_name_singular]]", @object_information[:object_name_singular])
    end

    private

    def object_information 

        splitted_name = name.downcase.split("/")

        object_name_singular = splitted_name.last.singularize
        object_name_plural = splitted_name.last.pluralize
        
        module_name_underscore = splitted_name.first
        module_name = (splitted_name.first.split("_").map { |mn| mn.capitalize}).join
        engine = module_name_underscore.split("_").last

        # Info of the service itself
        service_name = (splitted_name.map {|r| (r.split("_").map {|o| o.singularize.capitalize}).join}).join("::").concat("Services")
        service_name = service_name.split("::")[1..].join if module_name_underscore.eql? "core"
        service_file_name = "#{object_name_singular}_services"
        
        # Building the service path on which the file will be created
        service_path = Rails.root.to_s

        if module_name_underscore.eql? "core"
            service_path = service_path.concat("/app/services/", service_file_name)
        else
            service_path = service_path.concat("/engines/#{module_name_underscore}/app/services/#{module_name_underscore}/", splitted_name[1...-1].join("/"), "/#{service_file_name}")
        end


        {
            :name => name,
            :object_name_singular => object_name_singular,
            :object_name_plural => object_name_plural,
            :engine => engine,
            :module_name => module_name,
            :service_path => service_path,
            :service_name => service_name,
            :service_file_name => service_file_name,
        }
    end
end
