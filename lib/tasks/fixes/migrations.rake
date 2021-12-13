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
        Dir["engines/*"].find_all{|engine| engine.include? "cloud_dispatcher"}.each do |engine|

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

    desc "Fix schema migrations after move them"
    task schema_migrations: :environment do
        # INFO: 00000038_create_user_access_codes.rb -> 100003810_create_user_access_codes.rb

        ActiveRecord::Base.connection.exec_query("INSERT INTO schema_migrations (version) VALUES ('10003810');")
        ActiveRecord::Base.connection.exec_query("DELETE FROM schema_migrations WHERE version = '38';")


            # INFO: 00000034_create_user_requests.rb -> 100003410_create_user_requests.rb

        ActiveRecord::Base.connection.exec_query("INSERT INTO schema_migrations (version) VALUES ('10003410');")
        ActiveRecord::Base.connection.exec_query("DELETE FROM schema_migrations WHERE version = '34';")


            # INFO: 00000007_create_system_controller_actions.rb -> 100000710_create_system_controller_actions.rb

        ActiveRecord::Base.connection.exec_query("INSERT INTO schema_migrations (version) VALUES ('10000710');")
        ActiveRecord::Base.connection.exec_query("DELETE FROM schema_migrations WHERE version = '7';")


            # INFO: 00000057_create_role_activities.rb -> 100005710_create_role_activities.rb

        ActiveRecord::Base.connection.exec_query("INSERT INTO schema_migrations (version) VALUES ('10005710');")
        ActiveRecord::Base.connection.exec_query("DELETE FROM schema_migrations WHERE version = '57';")


            # INFO: 00000056_create_role_descriptor_assignments.rb -> 100005610_create_role_descriptor_assignments.rb

        ActiveRecord::Base.connection.exec_query("INSERT INTO schema_migrations (version) VALUES ('10005610');")
        ActiveRecord::Base.connection.exec_query("DELETE FROM schema_migrations WHERE version = '56';")


            # INFO: 00000070_create_invites.rb -> 100007010_create_invites.rb

        ActiveRecord::Base.connection.exec_query("INSERT INTO schema_migrations (version) VALUES ('10007010');")
        ActiveRecord::Base.connection.exec_query("DELETE FROM schema_migrations WHERE version = '70';")


            # INFO: 00000006_create_system_controllers.rb -> 100000610_create_system_controllers.rb

        ActiveRecord::Base.connection.exec_query("INSERT INTO schema_migrations (version) VALUES ('10000610');")
        ActiveRecord::Base.connection.exec_query("DELETE FROM schema_migrations WHERE version = '6';")


            # INFO: 00000002_create_roles.rb -> 100000210_create_roles.rb

        ActiveRecord::Base.connection.exec_query("INSERT INTO schema_migrations (version) VALUES ('10000210');")
        ActiveRecord::Base.connection.exec_query("DELETE FROM schema_migrations WHERE version = '2';")


            # INFO: 00000063_create_template_mappings.rb -> 100006310_create_template_mappings.rb

        ActiveRecord::Base.connection.exec_query("INSERT INTO schema_migrations (version) VALUES ('10006310');")
        ActiveRecord::Base.connection.exec_query("DELETE FROM schema_migrations WHERE version = '63';")


            # INFO: 00000052_create_role_descriptor_activities.rb -> 100005210_create_role_descriptor_activities.rb

        ActiveRecord::Base.connection.exec_query("INSERT INTO schema_migrations (version) VALUES ('10005210');")
        ActiveRecord::Base.connection.exec_query("DELETE FROM schema_migrations WHERE version = '52';")


            # INFO: 00000035_create_user_activities.rb -> 100003510_create_user_activities.rb

        ActiveRecord::Base.connection.exec_query("INSERT INTO schema_migrations (version) VALUES ('10003510');")
        ActiveRecord::Base.connection.exec_query("DELETE FROM schema_migrations WHERE version = '35';")


            # INFO: 00000050_create_role_descriptors.rb -> 100005010_create_role_descriptors.rb

        ActiveRecord::Base.connection.exec_query("INSERT INTO schema_migrations (version) VALUES ('10005010');")
        ActiveRecord::Base.connection.exec_query("DELETE FROM schema_migrations WHERE version = '50';")


            # INFO: 00000001_create_accounts.rb -> 100000110_create_accounts.rb
        ActiveRecord::Base.connection.exec_query("INSERT INTO schema_migrations (version) VALUES ('10000110');")
        ActiveRecord::Base.connection.exec_query("DELETE FROM schema_migrations WHERE version = '1';")


            # INFO: 00000014_create_account_files.rb -> 100001410_create_account_files.rb

        ActiveRecord::Base.connection.exec_query("INSERT INTO schema_migrations (version) VALUES ('10001410');")
        ActiveRecord::Base.connection.exec_query("DELETE FROM schema_migrations WHERE version = '14';")


            # INFO: 00000016_create_account_currency_exchange_rates.rb -> 100001610_create_account_currency_exchange_rates.rb

        ActiveRecord::Base.connection.exec_query("INSERT INTO schema_migrations (version) VALUES ('10001610');")
        ActiveRecord::Base.connection.exec_query("DELETE FROM schema_migrations WHERE version = '16';")


            # INFO: 00000031_create_user_details.rb -> 100003110_create_user_details.rb

        ActiveRecord::Base.connection.exec_query("INSERT INTO schema_migrations (version) VALUES ('10003110');")
        ActiveRecord::Base.connection.exec_query("DELETE FROM schema_migrations WHERE version = '31';")


            # INFO: 00000003_create_users.rb -> 100000310_create_users.rb

        ActiveRecord::Base.connection.exec_query("INSERT INTO schema_migrations (version) VALUES ('10000310');")
        ActiveRecord::Base.connection.exec_query("DELETE FROM schema_migrations WHERE version = '3';")


            # INFO: 00000032_create_user_settings.rb -> 100003210_create_user_settings.rb

        ActiveRecord::Base.connection.exec_query("INSERT INTO schema_migrations (version) VALUES ('10003210');")
        ActiveRecord::Base.connection.exec_query("DELETE FROM schema_migrations WHERE version = '32';")


            # INFO: 00000036_create_user_roles.rb -> 100003610_create_user_roles.rb

        ActiveRecord::Base.connection.exec_query("INSERT INTO schema_migrations (version) VALUES ('10003610');")
        ActiveRecord::Base.connection.exec_query("DELETE FROM schema_migrations WHERE version = '36';")


            # INFO: 00000037_create_user_logs.rb -> 100003710_create_user_logs.rb

        ActiveRecord::Base.connection.exec_query("INSERT INTO schema_migrations (version) VALUES ('10003710');")
        ActiveRecord::Base.connection.exec_query("DELETE FROM schema_migrations WHERE version = '37';")


            # INFO: 00000011_create_account_locations.rb -> 100001110_create_account_locations.rb

        ActiveRecord::Base.connection.exec_query("INSERT INTO schema_migrations (version) VALUES ('10001110');")
        ActiveRecord::Base.connection.exec_query("DELETE FROM schema_migrations WHERE version = '11';")


            # INFO: 00000040_create_user_privilege_actions.rb -> 100004010_create_user_privilege_actions.rb

        ActiveRecord::Base.connection.exec_query("INSERT INTO schema_migrations (version) VALUES ('10004010');")
        ActiveRecord::Base.connection.exec_query("DELETE FROM schema_migrations WHERE version = '40';")


            # INFO: 00000061_create_template_documents.rb -> 100006110_create_template_documents.rb

        ActiveRecord::Base.connection.exec_query("INSERT INTO schema_migrations (version) VALUES ('10006110');")
        ActiveRecord::Base.connection.exec_query("DELETE FROM schema_migrations WHERE version = '61';")


            # INFO: 00000010_create_account_settings.rb -> 100001010_create_account_settings.rb

        ActiveRecord::Base.connection.exec_query("INSERT INTO schema_migrations (version) VALUES ('10001010');")
        ActiveRecord::Base.connection.exec_query("DELETE FROM schema_migrations WHERE version = '10';")


            # INFO: 00000012_create_account_activities.rb -> 100001210_create_account_activities.rb

        ActiveRecord::Base.connection.exec_query("INSERT INTO schema_migrations (version) VALUES ('10001210');")
        ActiveRecord::Base.connection.exec_query("DELETE FROM schema_migrations WHERE version = '12';")


            # INFO: 00000033_create_user_sessions.rb -> 100003310_create_user_sessions.rb

        ActiveRecord::Base.connection.exec_query("INSERT INTO schema_migrations (version) VALUES ('10003310');")
        ActiveRecord::Base.connection.exec_query("DELETE FROM schema_migrations WHERE version = '33';")


            # INFO: 00000015_create_account_currencies.rb -> 100001510_create_account_currencies.rb

        ActiveRecord::Base.connection.exec_query("INSERT INTO schema_migrations (version) VALUES ('10001510');")
        ActiveRecord::Base.connection.exec_query("DELETE FROM schema_migrations WHERE version = '15';")


            # INFO: 00000039_create_user_shortcuts.rb -> 100003910_create_user_shortcuts.rb

        ActiveRecord::Base.connection.exec_query("INSERT INTO schema_migrations (version) VALUES ('10003910');")
        ActiveRecord::Base.connection.exec_query("DELETE FROM schema_migrations WHERE version = '39';")


            # INFO: 00000017_create_account_cronos.rb -> 100001710_create_account_cronos.rb

        ActiveRecord::Base.connection.exec_query("INSERT INTO schema_migrations (version) VALUES ('10001710');")
        ActiveRecord::Base.connection.exec_query("DELETE FROM schema_migrations WHERE version = '17';")


            # INFO: 00000064_create_template_audience_documents.rb -> 100006410_create_template_audience_documents.rb

        ActiveRecord::Base.connection.exec_query("INSERT INTO schema_migrations (version) VALUES ('10006410');")
        ActiveRecord::Base.connection.exec_query("DELETE FROM schema_migrations WHERE version = '64';")


            # INFO: 00000062_create_template_variables.rb -> 100006210_create_template_variables.rb

        ActiveRecord::Base.connection.exec_query("INSERT INTO schema_migrations (version) VALUES ('10006210');")
        ActiveRecord::Base.connection.exec_query("DELETE FROM schema_migrations WHERE version = '62';")


            # INFO: 00000013_create_account_integrations.rb -> 100001310_create_account_integrations.rb

        ActiveRecord::Base.connection.exec_query("INSERT INTO schema_migrations (version) VALUES ('10001310');")
        ActiveRecord::Base.connection.exec_query("DELETE FROM schema_migrations WHERE version = '13';")


            # INFO: 00000060_create_templates.rb -> 100006010_create_templates.rb

        ActiveRecord::Base.connection.exec_query("INSERT INTO schema_migrations (version) VALUES ('10006010');")
        ActiveRecord::Base.connection.exec_query("DELETE FROM schema_migrations WHERE version = '60';")


            # INFO: 00000051_create_role_descriptor_privilege_actions.rb -> 100005110_create_role_descriptor_privilege_actions.rb

        ActiveRecord::Base.connection.exec_query("INSERT INTO schema_migrations (version) VALUES ('10005110');")
        ActiveRecord::Base.connection.exec_query("DELETE FROM schema_migrations WHERE version = '51';")

        puts "FINISHED"
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