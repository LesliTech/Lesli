namespace :fixes do
    desc "Move core migrations inside a folder of v1.0 and rename migrations to new standard"
    task move_core_migrations: :environment do
        # core
        version = 1
        destination_folder = Rails.root.join("db", "migrate", "v#{version.to_f.to_s}")
        Dir.mkdir(destination_folder) unless File.exists?(destination_folder)

        Dir["db/migrate/**/*.rb"].find_all{ |creation_file|

            creation_file_name= creation_file.split("/").last
            module_code = creation_file_name[0..3] # first four digits of code are module code
            table_identifier = creation_file_name[4..7] # first four digits of code are module code
            new_file_name = creation_file_name.sub(module_code, "1000") #for core module code will be change
            new_file_name = new_file_name.sub(table_identifier, "#{table_identifier}#{(version * 10).to_s}")

            if (FileUtils.mv(creation_file, destination_folder.join(new_file_name)))
                LC::Debug.info("#{creation_file_name} -> #{new_file_name}")

                add_migration_code(creation_file_name, new_file_name)
            end
        }
    end


    desc "Move core migrations inside a folder of v1.0 and rename migrations to new standard"
    task move_engine_migrations: :environment do
        # engines
        version = 1
        # Dir["engines/*"].find_all{|engine| engine.include? "cloud_house"}.each do |engine|
        Dir["engines/*"].find_all{|engine| engine.include? "cloud_babel"}.each do |engine|
            destination_folder = Rails.root.join(engine, "db", "migrate", "v#{version.to_f.to_s}")
            Dir.mkdir(destination_folder) unless File.exists?(destination_folder)

            Dir["#{engine}/db/migrate/*.rb"].find_all{ |creation_file|

                creation_file_name = creation_file.split("/").last
                module_code = creation_file_name[0..3] # first four digits of code are module code
                table_identifier = creation_file_name[4..7] # first four digits of code are module code

                new_file_name = creation_file_name.sub(table_identifier, "#{table_identifier}#{(version * 10).to_s}")

                if (FileUtils.mv(creation_file, destination_folder.join(new_file_name)))
                    LC::Debug.info("# #{creation_file_name} -> #{new_file_name}")

                    add_migration_code(creation_file_name, new_file_name)
                end
            }
        end
    end

    def add_migration_code(old_file_name, new_file_name)
        old_code = old_file_name.scan(/\d+/).first
        new_code = new_file_name.scan(/\d+/).first

        old_code = old_code.to_i
        new_code = new_code.to_i

        puts "ActiveRecord::Base.connection.exec_query(\"INSERT INTO schema_migrations (version) VALUES ('#{new_code}');\")"
        puts "ActiveRecord::Base.connection.exec_query(\"DELETE FROM schema_migrations WHERE version = '#{old_code}';\")"
    end
end
