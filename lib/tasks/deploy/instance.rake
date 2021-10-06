namespace :deploy do

    desc "Deploys the latest changes to the app and creates a backup for it in lesli/../lesli_previous"
    task execute: :environment do
        source_path = Rails.root.to_s
        destination_path = Rails.root.join("..", "lesli_previous")

        puts "Copying the lesli app from #{source_path} into #{destination_path}"
        FileUtils.copy_entry(source_path, destination_path)

        puts "Searching for the builder engine.."
        engines_path = File.join(destination_path, "engines")
        builder_engine = {
            lesli_yml: "",
            config: []
        }

        Dir.entries(engines_path).select do |entry|
            engine_path = File.join(engines_path, entry)

            if File.directory? engine_path and ! (entry == '.' || entry == '..')
                lesli_yml_path = File.join(engine_path, "lesli.yml")

                if (File.exists? lesli_yml_path) && (! File.directory? lesli_yml_path)
                    engine_config = YAML.load_file(lesli_yml_path)
                    
                    if engine_config["info"] && engine_config["info"]["type"] && (engine_config["info"]["type"] == "builder")
                        puts "Builder engine found in #{engine_path}"
                        builder_engine = {
                            lesli_yml: lesli_yml_path,
                            config: engine_config
                        }
                        break
                    end
                end
            end
        end

        puts "Modyfing the configuration to use the current gem versions installed"
        builder_engine[:config]["modules"].each do |gem_name, gem_version|
            builder_engine[:config]["modules"][gem_name] = "= #{Gem.loaded_specs[gem_name].version.to_s}"
        end

        puts "Writing the correct versions of the gems to lesli.yml in the builder engine"
        File.open(builder_engine[:lesli_yml], "w") do |file|
            file.write(builder_engine[:config].to_yaml)
            file.close
        end
    end
end
