module ActiveRecord
    class Migrator
        # @return [void] @override
        # based on https://github.com/rails/rails/blob/78e402077d4d69b08db7daf8944a32eef0cf6ac4/activerecord/lib/active_record/migration.rb#L1256
        # @description Lesli platform has its own migration versioning so having the same class name is valid for us when a table is being changed
        # this function is use to skip the default migration validation of duplicated names if the migration name starts with Alter.
        # Important notes!!
        # - This function is called each time that you run rake db:migrate
        # - when a migration could has the same class name?
        #   - Migrations names can be duplicated for any change on a table
        # Example
        # > v1.0
        #   0010000310_create_users.rb -> class name: CreateUsers
        # > v1.1
        #   0010000311_alter_users.rb  -> class name: AlterUsers
        # > v1.2
        #   0010000312_alter_users.rb  -> class name: AlterUsers

        def validate(migrations)
            name, = migrations.group_by(&:name).find { |_, v| v.length > 1 } # obtain migration name

            if (name&.starts_with? "Alter") # validate if migration starts with Alter

                # validate migration version
                version, = migrations.group_by(&:version).find { |_, v| v.length > 1 }
                raise DuplicateMigrationVersionError.new(version) if version

                return
            end

            super
        end
    end
end