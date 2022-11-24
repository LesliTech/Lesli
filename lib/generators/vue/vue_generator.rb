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
class VueGenerator < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)
    argument :model, type: :string


    # Sets the variables @engine_data, which contains information about the engine, and
    # @app_data, which contains information about the name and namespace of the created app
    def parse_app_name
        @engine_data = parse_engine_data
        @app_data = parse_app_data

        pp @app_data

        @license = File.read(Rails.root.join("license")).to_s.force_encoding("ASCII-8BIT")
    end

    # Creates the js files of the list, new, edit and show apps.
    # Copies the content of the template found in ./templates/apps/[app_name]_vue.template and modifies some placeholders
    # to match the engine, namespace, and name of the model
    def create_apps
        #["index", "new", "edit", "show"]
        ["index", "new"].each do |app| # only index is migrated
            destination_path = Rails.root.join(@engine_data[:base_path], "app", "vue3", "apps", @app_data[:path], "#{app}.vue")

            copy_file("apps/#{app}_vue.template", destination_path)
            gsub_file(destination_path, "%license%", @license)
            gsub_file(destination_path, "%engine%", @app_data[:engine])
            gsub_file(destination_path, "%app_route%", @app_data[:route])
            gsub_file(destination_path, "%underscore_resource%", @app_data[:underscore_resource])
            gsub_file(destination_path, "%underscore_resources%", @app_data[:underscore_resource].pluralize)
            gsub_file(destination_path, "%camel_case_resource%", @app_data[:camel_case_resource])
            gsub_file(destination_path, "%camel_case_resources%", @app_data[:camel_case_resource].pluralize)
            gsub_file(destination_path, "%snake_case_resource%", @app_data[:snake_case_resource])
            gsub_file(destination_path, "%humanized_resource%", @app_data[:humanized_resource])
            gsub_file(destination_path, "%humanized_resources%", @app_data[:humanized_resource].pluralize)
        end

        # create store
        destination_path = Rails.root.join(@engine_data[:base_path], "app", "vue3", "stores", "#{@app_data[:underscore_resource]}.js")
        copy_file("stores/store_js.template", destination_path)
        gsub_file(destination_path, "%license%", @license)
        gsub_file(destination_path, "%engine%", @app_data[:engine])
        gsub_file(destination_path, "%app_route%", @app_data[:route])
        gsub_file(destination_path, "%underscore_resource%", @app_data[:underscore_resource])
        gsub_file(destination_path, "%underscore_resources%", @app_data[:underscore_resource].pluralize)
        gsub_file(destination_path, "%camel_case_resource%", @app_data[:camel_case_resource])
        gsub_file(destination_path, "%camel_case_resources%", @app_data[:camel_case_resource].pluralize)
        gsub_file(destination_path, "%snake_case_resource%", @app_data[:snake_case_resource])
        gsub_file(destination_path, "%humanized_resource%", @app_data[:humanized_resource])
        gsub_file(destination_path, "%humanized_resources%", @app_data[:humanized_resource].pluralize)
    end

=begin
    # Creates the js file of the form component.
    # Copies the content of the template found in ./templates/components/form_vue.template and modifies some placeholders
    # to match the engine, namespace, and name of the model
    def create_components
        ["form"].each do |component|
            destination_path = Rails.root.join(@engine_data[:base_path], "app", "vue", @app_data[:path], "components", "#{component}.vue")

            copy_file("components/#{component}_vue.template", destination_path)
            gsub_file(destination_path, "%license%", @license)
            gsub_file(destination_path, "%engine%", @app_data[:engine])
            gsub_file(destination_path, "%app_route%", @app_data[:route])
            gsub_file(destination_path, "%underscore_resource%", @app_data[:underscore_resource])
            gsub_file(destination_path, "%underscore_resources%", @app_data[:underscore_resource].pluralize)
            gsub_file(destination_path, "%camel_case_resource%", @app_data[:camel_case_resource])
            gsub_file(destination_path, "%camel_case_resources%", @app_data[:camel_case_resource].pluralize)
            gsub_file(destination_path, "%snake_case_resource%", @app_data[:snake_case_resource])
            gsub_file(destination_path, "%humanized_resource%", @app_data[:humanized_resource])
        end
    end
=end

    private

    # Based on the *model* variable received when invoking the generator, returns a hash with the
    # *:name* and *:base_path* keys, that indicate the directory to which the generated files are going to be stored
    def parse_engine_data
        base_path = ""
        name_data = model.split("/")

        engine_code = name_data[0].underscore

        if engine_code != "core"
            base_path+= "engines/#{engine_code}/"
        end

        return {
            name: name_data[0],
            base_path: base_path
        }
    end


    # Based on the *model* variable received when invoking the generator, returns a hash with the
    # *:path*, *:route*, *:undescore_resource*, *:camel_case_resource*, *:snake_case_resource*
    # and *:humanized_resource* keys
    # imagine the user invoked the generation using: rails generate vue_app CloudHouse::Catalog::ProjectType
    # app_data = parse_app_data
    # puts engine_data[:path]                 # will display 'catalog_project_types', the path of the vue files
    # puts engine_data[:route]                # will display '/house/catalog/project_types', the Lesli API main route
    # puts engine_data[:underscore_resource]  # will display 'project_type', similar to a variable name
    # puts engine_data[:camel_case_resource]  # will display 'ProjectType', simiar to a function name
    # puts engine_data[:snake_case_resource]  # will display 'project-type', similar to a prop name
    # puts engine_data[:humanized_resource]   # will display 'Project type', the way we write it
    def parse_app_data
        route = ""
        underscore_resource = []
        camel_case_resource = []
        
        name_data = model.split("/")
        engine = name_data.shift

        name_data = name_data.each_with_index.map do |string, index|
            if (index + 1) == name_data.length
                camel_case_resource.push(string)
            end
            string = string.underscore
            
            if (index + 1) == name_data.length
                underscore_resource.push(string)
                string = string.pluralize
            end

            route += "/#{string}"
            string
        end

        if engine != "Core"
            route = "/#{engine.gsub("Cloud","").downcase}#{route}" 
        end

        route[0] = "" if route[0] == "/"
        
        camel_case_resource = camel_case_resource.join("")
        underscore_resource = underscore_resource.join("_")
        snake_case_resource = underscore_resource.gsub("_", "-")
        humanized_resource = underscore_resource.humanize

        return {
            path: name_data.join("_"),
            route: route,
            underscore_resource: underscore_resource,
            camel_case_resource: camel_case_resource,
            snake_case_resource: snake_case_resource,
            humanized_resource: humanized_resource,
            engine: engine
        }
        
    end
end
