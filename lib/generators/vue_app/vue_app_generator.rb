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
class VueAppGenerator < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)
    argument :model, type: :string

=begin
@return [void]
@description Sets the variables @engine_data, which contains information about the engine, and
    @app_data, which contains information about the name and namespace of the created app
@example
    # imagine the command is rails generate vue_app CloudHouse::Catalog::ProjectType
    puts @engine_data   # will display nil
    puts @app_data      # will display nil
    parse_app_name
    puts @engine_data.to_json   # will display something similar to {"name":"CloudHouse","base_path":"./engines/CloudHouse/"}
    puts @app_data.to_json      # will display something similar to {"path":"catalog_project_types","route":"/house/catalog/project_types","underscore_resource":"project_type","camel_case_resource":"ProjectType","snake_case_resource":"project-type","humanized_resource":"Project type"}
    first_ticket = CloudHelp::Ticket.find( 1 )
    second_ticket = CloudHelp::Ticket.find( 2 )
    user = current_user
    CloudHelp::Ticket::Subscriber.add_subscriber( first_ticket, current_user )
    CloudHelp::Ticket::Subscriber.add_subscriber( second_ticket, current_user, :http_post, :email )
=end
    def parse_app_name
        @engine_data = parse_engine_data
        @app_data = parse_app_data
    end

=begin
@return [void]
@description Creates the erb view new, show, edit and index using the template found
    in ./templates/views/view_html_erb.template
@example
    # imagine the command is rails generate vue_app CloudHouse::Catalog::ProjectType
    create_erb_files
    # will generate the files
    # engines/CloudHouse/app/views/cloud_house/catalog/project_types/index.html.erb
    # engines/CloudHouse/app/views/cloud_house/catalog/project_types/new.html.erb
    # engines/CloudHouse/app/views/cloud_house/catalog/project_types/show.html.erb
    # engines/CloudHouse/app/views/cloud_house/catalog/project_types/edit.html.erb
=end
    def create_erb_files

        destination_path = "#{@engine_data[:base_path]}/app/views/cloud_#{@app_data[:route][1..-1]}"
        if @engine_data[:name] == "Core"
            destination_path = "#{@engine_data[:base_path]}/app/views#{@app_data[:route]}"
        end

        ["index", "new", "edit", "show"].each do |view|
            copy_file("views/view_html_erb.template", "#{destination_path}/#{view}.html.erb")
        end
    end

=begin
@return [void]
@description Creates the scss file imported by the views and copies the content of
    the template found in ./templates/assets/stylesheet_css.template
@example
    # imagine the command is rails generate vue_app CloudHouse::Catalog::ProjectType
    create_scss_files
    # will generate the file
    # engines/CloudHouse/app/assets/stylesheets/cloud_house/catalog/project_types.scss
=end
    def create_scss_files
        destination_path = "#{@engine_data[:base_path]}/app/assets/stylesheets/cloud_#{@app_data[:route][1..-1]}.scss"
        if @engine_data[:name] == "Core"
            destination_path = "#{@engine_data[:base_path]}/app/assets/stylesheets#{@app_data[:route]}.scss"
        end

        copy_file("assets/stylesheet_css.template", destination_path)
    end

=begin
@return [void]
@description Creates the js file of the main app that imports all other apps and works with the Vue-router.
    Copies the content of the template found in ./templates/app_js.template and modifies some placeholders
    to match the engine, namespace, and name of the model
@example
    # imagine the command is rails generate vue_app CloudHouse::Catalog::ProjectType
    create_main_app
    # will generate the file
    # engines/CloudHouse/app/vue/catalog_project_types/app.js
=end
    def create_main_app
        destination_path = "#{@engine_data[:base_path]}/app/vue/#{@app_data[:path]}/app.js"

        copy_file("app_js.template", destination_path)
        gsub_file(destination_path, "%engine%", @engine_data[:name])
        gsub_file(destination_path, "%app_route%", @app_data[:route])
    end

=begin
@return [void]
@description Creates the js files of the list, new, edit and show apps.
    Copies the content of the template found in ./templates/apps/[app_name]_vue.template and modifies some placeholders
    to match the engine, namespace, and name of the model
@example
    # imagine the command is rails generate vue_app CloudHouse::Catalog::ProjectType
    create_apps
    # will generate the files
    # engines/CloudHouse/app/vue/catalog_project_types/apps/list.vue
    # engines/CloudHouse/app/vue/catalog_project_types/apps/new.vue
    # engines/CloudHouse/app/vue/catalog_project_types/apps/show.vue
    # engines/CloudHouse/app/vue/catalog_project_types/apps/edit.vue
=end
    def create_apps
        ["list", "new", "edit", "show"].each do |app|
            destination_path = "#{@engine_data[:base_path]}/app/vue/#{@app_data[:path]}/apps/#{app}.vue"

            copy_file("apps/#{app}_vue.template", destination_path)
            gsub_file(destination_path, "%app_route%", @app_data[:route])
            gsub_file(destination_path, "%underscore_resource%", @app_data[:underscore_resource])
            gsub_file(destination_path, "%underscore_resources%", @app_data[:underscore_resource].pluralize)
            gsub_file(destination_path, "%camel_case_resource%", @app_data[:camel_case_resource])
            gsub_file(destination_path, "%camel_case_resources%", @app_data[:camel_case_resource].pluralize)
            gsub_file(destination_path, "%snake_case_resource%", @app_data[:snake_case_resource])
            gsub_file(destination_path, "%humanized_resource%", @app_data[:humanized_resource])
            gsub_file(destination_path, "%humanized_resources%", @app_data[:humanized_resource].pluralize)
        end
    end

=begin
@return [void]
@description Creates the js file of the form component.
    Copies the content of the template found in ./templates/components/form_vue.template and modifies some placeholders
    to match the engine, namespace, and name of the model
@example
    # imagine the command is rails generate vue_app CloudHouse::Catalog::ProjectType
    create_components
    # will generate the file
    # engines/CloudHouse/app/vue/catalog_project_types/components/form.vue
=end
    def create_components
        ["form"].each do |component|
            destination_path = "#{@engine_data[:base_path]}/app/vue/#{@app_data[:path]}/components/#{component}.vue"

            copy_file("components/#{component}_vue.template", destination_path)
            gsub_file(destination_path, "%app_route%", @app_data[:route])
            gsub_file(destination_path, "%underscore_resource%", @app_data[:underscore_resource])
            gsub_file(destination_path, "%underscore_resources%", @app_data[:underscore_resource].pluralize)
            gsub_file(destination_path, "%camel_case_resource%", @app_data[:camel_case_resource])
            gsub_file(destination_path, "%camel_case_resources%", @app_data[:camel_case_resource].pluralize)
            gsub_file(destination_path, "%snake_case_resource%", @app_data[:snake_case_resource])
            gsub_file(destination_path, "%humanized_resource%", @app_data[:humanized_resource])
        end
    end

    private

=begin
@return [Hash] Information of the path to which the generated files are going to be stored
@description Based on the *model* variable received when invoking the generator, returns a hash with the
    *:name* and *:base_path* keys, that indicate the directory to which the generated files are going to be stored
@example
    #imagine the user invoked the generation using: rails generate vue_app Core::User
    engine_data = parse_engine_data
    puts engine_data[:name]         # will display 'Core'
    puts engine_data[:base_path]    # will display './'
=end
    def parse_engine_data
        base_path = "./"
        name_data = model.split("::")
        if name_data[0] != "Core"
            base_path+= "engines/#{name_data[0]}/"
        end

        return {
            name: name_data[0],
            base_path: base_path
        }
    end

=begin
@return [Hash] Information of the engine, namespace and model that the user wants to generate.
@description Based on the *model* variable received when invoking the generator, returns a hash with the
    *:path*, *:route*, *:undescore_resource*, *:camel_case_resource*, *:snake_case_resource*
    and *:humanized_resource* keys
@example
    #imagine the user invoked the generation using: rails generate vue_app CloudHouse::Catalog::ProjectType
    app_data = parse_app_data
    puts engine_data[:path]                 # will display 'catalog_project_types', the path of the vue files
    puts engine_data[:route]                # will display '/house/catalog/project_types', the Lesli API main route
    puts engine_data[:underscore_resource]  # will display 'project_type', similar to a variable name
    puts engine_data[:camel_case_resource]  # will display 'ProjectType', simiar to a function name
    puts engine_data[:snake_case_resource]  # will display 'project-type', similar to a prop name
    puts engine_data[:humanized_resource]   # will display 'Project type', the way we write it
=end
    def parse_app_data
        route = ""
        underscore_resource = []
        camel_case_resource = []
        
        name_data = model.split("::")
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
            humanized_resource: humanized_resource
        }
        
    end
end
