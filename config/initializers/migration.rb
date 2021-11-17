module ActiveRecord
    class Migrator
        def validate(migrations)
            name, = migrations.group_by(&:name).find { |_, v| v.length > 1 }

            if (name.downcase.include? "alter")

                # validate migration version
                version, = migrations.group_by(&:version).find { |_, v| v.length > 1 }
                raise DuplicateMigrationVersionError.new(version) if version

                return
            end

            super
        end
    end
end