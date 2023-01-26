namespace :fixes do

    desc "Fix schema migration"
    task schema_migrations: :environment do
        # 10003010_create_user_details.rb
        ActiveRecord::Base.connection.exec_query("INSERT INTO schema_migrations (version) VALUES ('10003010');")

        # 10003911_create_user_auth_providers.rb
        ActiveRecord::Base.connection.exec_query("INSERT INTO schema_migrations (version) VALUES ('10003911');")

        # 10003914_alter_user_auth_providers.rb
        ActiveRecord::Base.connection.exec_query("INSERT INTO schema_migrations (version) VALUES ('10003914');")

        # 10005220_create_descriptor_activities.rb
        ActiveRecord::Base.connection.exec_query("INSERT INTO schema_migrations (version) VALUES ('10005220');")

        # 10005620_create_role_activities.rb
        ActiveRecord::Base.connection.exec_query("INSERT INTO schema_migrations (version) VALUES ('10005620');")

        puts "FINISHED"
    end

    desc "Delete migrations without file"
    task clean_schema_migrations: :environment do
        # OLD migrations
        ActiveRecord::Base.connection.exec_query("DELETE FROM schema_migrations WHERE version = '10003910';")
        ActiveRecord::Base.connection.exec_query("DELETE FROM schema_migrations WHERE version = '10004010';")
        ActiveRecord::Base.connection.exec_query("DELETE FROM schema_migrations WHERE version = '10004111';")
        ActiveRecord::Base.connection.exec_query("DELETE FROM schema_migrations WHERE version = '10004114';")
        ActiveRecord::Base.connection.exec_query("DELETE FROM schema_migrations WHERE version = '10004313';")
        ActiveRecord::Base.connection.exec_query("DELETE FROM schema_migrations WHERE version = '10005010';")
        ActiveRecord::Base.connection.exec_query("DELETE FROM schema_migrations WHERE version = '10005110';")
        ActiveRecord::Base.connection.exec_query("DELETE FROM schema_migrations WHERE version = '10005210';")
        ActiveRecord::Base.connection.exec_query("DELETE FROM schema_migrations WHERE version = '10005610';")
        ActiveRecord::Base.connection.exec_query("DELETE FROM schema_migrations WHERE version = '10005710';")
        ActiveRecord::Base.connection.exec_query("DELETE FROM schema_migrations WHERE version = '10005820';")
        ActiveRecord::Base.connection.exec_query("DELETE FROM schema_migrations WHERE version = '10008020';")
        ActiveRecord::Base.connection.exec_query("DELETE FROM schema_migrations WHERE version = '10008120';")
        ActiveRecord::Base.connection.exec_query("DELETE FROM schema_migrations WHERE version = '10008220';")
        ActiveRecord::Base.connection.exec_query("DELETE FROM schema_migrations WHERE version = '10008420';")

        ActiveRecord::Base.connection.exec_query("DELETE FROM schema_migrations WHERE version = '10004211';")
        ActiveRecord::Base.connection.exec_query("DELETE FROM schema_migrations WHERE version = '10008320';")

        puts "FINISHED"
    end

end
