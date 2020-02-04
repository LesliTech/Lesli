class CloudAppGenerator < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)
    argument :model, type: :string

    def create_main_app
        engine_data = parse_engine_data
        app_data = parse_app_path

        puts engine_data.to_json
        puts app_data.to_json

        destination_main_app_path = "#{engine_data[:base_path]}/app/vue/#{app_data[:path]}/app.js"

        # Copying main app
        copy_file("app_js.template", destination_main_app_path)
        gsub_file(destination_main_app_path, "%engine%", engine_data[:name])
        gsub_file(destination_main_app_path, "%app_route%", app_data[:route])

        # Copying list|new|show|edit apps
        ["list", "new", "edit", "show"].each do |app|
            destination_app_path = "#{engine_data[:base_path]}/app/vue/#{app_data[:path]}/apps/#{app}.vue"

            copy_file("apps/#{app}_vue.template", destination_app_path)
            gsub_file(destination_app_path, "%app_route%", app_data[:route])
            gsub_file(destination_app_path, "%data_resource%", app_data[:data_resource])
            gsub_file(destination_app_path, "%data_resources%", app_data[:data_resource].pluralize)
            gsub_file(destination_app_path, "%function_resource%", app_data[:function_resource])
            gsub_file(destination_app_path, "%function_resources%", app_data[:function_resource].pluralize)
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
        data_resource = []
        function_resource = []
        
        name_data = model.split("::")

        engine = name_data.shift
        if engine != "Core"
            route = engine.gsub("Cloud","").downcase
        end



        name_data = name_data.each_with_index.map do |string, index|
            function_resource.push(string)
            string = string.downcase
            data_resource.push(string)
            
            if (index + 1) == name_data.length
                string = string.pluralize
            end

            route += "/#{string}"
            string
        end
        
        function_resource = function_resource.join("")
        data_resource = data_resource.join("_")

        {
            path: name_data.join("_"),
            route: route,
            data_resource: data_resource,
            function_resource: function_resource
        }
        
    end
end
