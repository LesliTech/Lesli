namespace :fixes do

    desc "Fix schema migration"
    task schema_migrations: :environment do

        # 10004114_alter_user_auth_providers.rb
        ActiveRecord::Base.connection.exec_query("INSERT INTO schema_migrations (version) VALUES ('10004114');")

        # 10004211_create_user_webpushes.rb
        ActiveRecord::Base.connection.exec_query("INSERT INTO schema_migrations (version) VALUES ('10004211');")

        # 10004313_create_user_requests_ext.rb
        ActiveRecord::Base.connection.exec_query("INSERT INTO schema_migrations (version) VALUES ('10004313');")


        # OLD migrations

        # 10004011_create_user_auth_providers.rb
        ActiveRecord::Base.connection.exec_query("DELETE FROM schema_migrations WHERE version = '10004011';")

        # 10004014_alter_user_auth_providers.rb
        ActiveRecord::Base.connection.exec_query("DELETE FROM schema_migrations WHERE version = '10004014';")

        # 10004113_create_user_requests_ext.rb
        ActiveRecord::Base.connection.exec_query("DELETE FROM schema_migrations WHERE version = '10004113';")

        puts "FINISHED"

    end

end
