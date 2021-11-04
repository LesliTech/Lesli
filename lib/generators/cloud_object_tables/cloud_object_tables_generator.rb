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
class CloudObjectTablesGenerator < Rails::Generators::Base
    source_root File.expand_path("templates", __dir__)
    argument :model,            type: :string
    argument :database_code,    type: :string

    # @return [void]
    # @description Sets the variables @engine_data, which contains information about the engine, and
    #     @resource_data, which contains information about the name and namespace of the created app
    # @example
    #     # imagine the command is rails generate cloud_object_tables cloud_house/project
    #     puts @engine_data   # will display nil
    #     puts @resource_data      # will display nil
    #     parse_cloud_object
    #     puts @engine_data.to_json   # will display something similar to
    #     # {
    #     #     "underscore_name" : "cloud_team",
    #     #     "camel_case_name" : "CloudTeam",
    #     #     "base_path" : "engines/cloud_team/"
    #     # }
    #     puts @resource_data.to_json      # will display something similar to 
    #     # {
    #     #     "path" : "custom_vacations",
    #     #     "route" : "cloud_team/custom_vacations",
    #     #     "underscore_name" : "custom_vacation",
    #     #     "camel_case_name" : "CustomVacation",
    #     #     "snake_case_name" : "custom-vacation",
    #     #     "humanized_name" : "Custom vacation"
    #     # }
    def parse_cloud_object
        @engine_data = parse_engine_data
        @resource_data = parse_resource_data
        @license = File.read(Rails.root.join("license")).to_s.force_encoding("ASCII-8BIT")
    end

    def create_migrations
        child_tables.each do |child_table|
            destination_path = Rails.root.join(
                @engine_data[:base_path],
                "db",
                "migrate",
                "#{database_code}#{child_table[:code]}_create_#{@engine_data[:underscore_name]}_#{@resource_data[:underscore_name]}_#{child_table[:name].pluralize}.rb"
            )

            template = "migrations/generic_rb.template"
            template = child_table[:migration_template] if child_table[:migration_template]

            copy_file(template, destination_path)
            gsub_file(destination_path, "[[license]]", @license)
            gsub_file(destination_path, "[[camel_case_engine]]", @engine_data[:camel_case_name])
            gsub_file(destination_path, "[[camel_case_resource]]", @resource_data[:camel_case_name])
            gsub_file(destination_path, "[[child_model_code]]", child_table[:code].rjust(8, "0"))
            gsub_file(destination_path, "[[underscore_plural_child]]", child_table[:name].pluralize)
            gsub_file(destination_path, "[[camel_case_plural_child]]", child_table[:name].camelize.pluralize)
            gsub_file(destination_path, "[[underscore_engine]]", @engine_data[:underscore_name])
            gsub_file(destination_path, "[[underscore_resource]]", @resource_data[:underscore_name])
            gsub_file(destination_path, "[[underscore_plural_resource]]", @resource_data[:underscore_name].pluralize)
        end
    end

    def create_models
        child_tables.each do |child_table|
            destination_path = Rails.root.join(
                @engine_data[:base_path],
                "app",
                "models",
                @engine_data[:underscore_name],
                @resource_data[:underscore_name],
                "#{child_table[:name]}.rb"
            )

            template = "models/generic_rb.template"
            template = child_table[:model_template] if child_table[:model_template]

            copy_file(template, destination_path)
            gsub_file(destination_path, "[[license]]", @license)
            gsub_file(destination_path, "[[camel_case_engine]]", @engine_data[:camel_case_name])
            gsub_file(destination_path, "[[camel_case_resource]]", @resource_data[:camel_case_name])
            gsub_file(destination_path, "[[underscore_engine]]", @engine_data[:underscore_name])
            gsub_file(destination_path, "[[underscore_plural_resource]]", @resource_data[:underscore_name].pluralize)
        end
    end

    def create_controllers
        child_tables.each do |child_table|
            destination_path = Rails.root.join(
                @engine_data[:base_path],
                "app",
                "controllers",
                @engine_data[:underscore_name],
                @resource_data[:underscore_name],
                "#{child_table[:name].pluralize}_controller.rb"
            )

            copy_file("controllers/generic_rb.template", destination_path)
            gsub_file(destination_path, "[[license]]", @license)
            gsub_file(destination_path, "[[camel_case_engine]]", @engine_data[:camel_case_name])
            gsub_file(destination_path, "[[underscore_engine]]", @engine_data[:underscore_name])
            gsub_file(destination_path, "[[camel_case_resource]]", @resource_data[:camel_case_name])
            gsub_file(destination_path, "[[camel_case_plural_child]]", child_table[:name].camelize.pluralize)
        end
    end

    private

    def child_tables
        [
            {code: "03", name: "action", add_user_reference: true},
            {code: "04", name: "activity", add_user_reference: false, migration_template: "migrations/activity_rb.template"},
            {code: "05", name: "discussion", add_user_reference: true, model_template: "models/discussion_rb.template"},
            {code: "06", name: "file", add_user_reference: true},
            {code: "07", name: "subscriber", add_user_reference: true},
        ]
    end

    # @return [Hash] Information of the path to which the generated files are going to be stored
    # @description Based on the *model* variable received when invoking the generator, returns a hash with the
    #     *:name* and *:base_path* keys, that indicate the directory to which the generated files are going to be stored
    # @example
    #     #imagine the user invoked the generation using: rails generate cloud_object_tables cloud_team::vacation
    #     engine_data = parse_engine_data
    #     puts engine_data[:underscore_name]         # will display 'cloud_team'
    #     puts engine_data[:name_camel_case]         # will display 'CloudTeam'
    #     puts engine_data[:base_path]    # will display 'engines/cloud_team/'
    def parse_engine_data
        base_path = ""
        name_data = model.split("/")
        if name_data[0] != "core"
            base_path+= "engines/#{name_data[0]}/"
        end

        return {
            underscore_name: name_data[0],
            camel_case_name: name_data[0].camelize,
            base_path: base_path
        }
    end

    # @return [Hash] Information of the engine, namespace and model that the user wants to generate.
    # @description Based on the *model* variable received when invoking the generator, returns a hash with the
    #     *:path*, *:route*, *:undescore_resource*, *:camel_case_name*, *:snake_case_name*
    #     and *:humanized_name* keys
    # @example
    #     #imagine the user invoked the generation using: rails generate cloud_object_tables cloud_house/project_type
    #     resource_data = parse_resource_data
    #     puts resource_data[:path]             # will display 'project_types', the path of the vue files
    #     puts resource_data[:route]            # will display '/house/project_types', the Lesli API main route
    #     puts resource_data[:underscore_name]  # will display 'project_type', similar to a variable name
    #     puts resource_data[:camel_case_name]  # will display 'ProjectType', simiar to a function name
    #     puts resource_data[:snake_case_name]  # will display 'project-type', similar to a prop name
    #     puts resource_data[:humanized_name]   # will display 'Project type', the way we write it
    def parse_resource_data
        route = ""
        underscore_name = []
        camel_case_name = []
        
        name_data = model.split("/")
        engine = name_data.shift

        name_data = name_data.each_with_index.map do |string, index|
            if (index + 1) == name_data.length
                camel_case_name.push(string.camelize)
            end
            string = string.underscore
            
            if (index + 1) == name_data.length
                underscore_name.push(string)
                string = string.pluralize
            end

            route += "/#{string}"
            string
        end

        if engine != "core"
            route = "/#{engine.gsub("Cloud","").downcase}#{route}" 
        end

        route[0] = "" if route[0] == "/"
        
        camel_case_name = camel_case_name.join("")
        underscore_name = underscore_name.join("_")
        snake_case_name = underscore_name.gsub("_", "-")
        humanized_name = underscore_name.humanize

        return {
            path: name_data.join("_"),
            route: route,
            underscore_name: underscore_name,
            camel_case_name: camel_case_name,
            snake_case_name: snake_case_name,
            humanized_name: humanized_name
        }
        
    end
end
