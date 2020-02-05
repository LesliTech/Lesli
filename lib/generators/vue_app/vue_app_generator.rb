class VueAppGenerator < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)
    argument :model, type: :string

    def parse_app_name
        @engine_data = parse_engine_data
        @app_data = parse_app_path
    end

    def create_erb_files
        destination_path = "#{@engine_data[:base_path]}/app/views/cloud_#{@app_data[:route][1..-1]}"
        if @engine_data[:name] == "Core"
            destination_path = "#{@engine_data[:base_path]}/app/views#{@app_data[:route]}"
        end

        ["index", "new", "edit", "show"].each do |view|
            copy_file("views/view_html_erb.template", "#{destination_path}/#{view}.html.erb")
        end
    end

    def create_scss_files
        destination_path = "#{@engine_data[:base_path]}/app/assets/stylesheets/cloud_#{@app_data[:route][1..-1]}.scss"
        if @engine_data[:name] == "Core"
            destination_path = "#{@engine_data[:base_path]}/app/assets/stylesheets#{@app_data[:route]}.scss"
        end

        copy_file("assets/stylesheet_css.template", destination_path)
    end
    
    def create_main_app
        destination_path = "#{@engine_data[:base_path]}/app/vue/#{@app_data[:path]}/app.js"

        copy_file("app_js.template", destination_path)
        gsub_file(destination_path, "%engine%", @engine_data[:name])
        gsub_file(destination_path, "%app_route%", @app_data[:route])
    end

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
        end
    end

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

    def parse_app_path
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

        {
            path: name_data.join("_"),
            route: route,
            underscore_resource: underscore_resource,
            camel_case_resource: camel_case_resource,
            snake_case_resource: snake_case_resource,
            humanized_resource: humanized_resource
        }
        
    end
end
