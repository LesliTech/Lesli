=begin

Copyright (c) 2021, all rights reserved.

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

class TestGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('templates', __dir__)

    def get_information
        
        @info = parse_information
        @license = File.read(Rails.root.join("license")).to_s.force_encoding("ASCII-8BIT")
    end

    def generate_standard_request_tests
        ["create", "destroy", "index", "show", "update"].each do |test_name|
            test_name = test_name + "_spec"
            test_file = test_name + ".rb"
            destination_path = @info[:path].join(test_file)
            copy_file("requests/#{test_name}.template", destination_path)
            gsub_file(destination_path, "[[license]]", @license)
            gsub_file(destination_path, "[[url]]", @info[:url])
            gsub_file(destination_path, "[[model]]", @info[:model])
            gsub_file(destination_path, "[[controller]]", @info[:controller])
            gsub_file(destination_path, "[[controller_file]]", @info[:controller_file])
            gsub_file(destination_path, "[[controller_folder]]", @info[:controller_folder])
            gsub_file(destination_path, "[[controller_file_upper]]", @info[:controller_file_upper])
            gsub_file(destination_path, "[[controller_folder_upper]]", @info[:controller_folder_upper])
            gsub_file(destination_path, "[[engine_name]]", @info[:engine_name])

        end
    end

    def generate_standard_version_test

        return if @info[:engine] == "core"

        destination_path = @info[:path].join("../", "../", "lib", "version_spec.rb")

        # standard test already exists
        return if File.file?(destination_path)

        copy_file("../lib/version_spec.template", destination_path)
        gsub_file(destination_path, "[[license]]", @license)
        gsub_file(destination_path, "[[engine_name]]", @info[:engine_name])
        gsub_file(destination_path, "[[engine]]", @info[:engine])
    end


    private


    def parse_information
        
        base_path = "spec/tests/requests"
        module_controller = name.downcase.split("/")
        engine = module_controller[0]
        controller = module_controller[1]
        if module_controller.length > 2
            controller = module_controller[1] + "/" + module_controller[2] 
            controller_folder =  module_controller[1]
            controller_file =  module_controller[2]
        end
        model = get_model(module_controller)

        if module_controller[0] == "core"
            path = Rails.root.join(base_path, controller)
            url = "/administration/" << controller 
        else
            path = Rails.root.join("engines", engine, base_path, controller)
            url = "/" << name.gsub("cloud_", "")
        end

        return {
            url: url,
            path: path,
            model: model,
            engine: engine,
            controller: controller,
            controller_folder: controller_folder || "",
            controller_file: controller_file || "",
            controller_folder_upper: controller_folder.capitalize || "",
            controller_file_upper: controller_file.capitalize.chop || "",
            engine_name: engine.camelize
        }

    end

    def get_model(controller)
        engine = controller[0].split("_").map { |word|  word.capitalize() }.join("")
        model = controller[1].capitalize()

        return engine + "::" + model
    end

end
