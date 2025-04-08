# config/initializers/migration_helpers.rb
require(Lesli::Engine.root.join("lib/migration_helpers/items"))
require(Lesli::Engine.root.join("lib/migration_helpers/shared"))

ActiveRecord::Migration.include(MigrationHelpers::Items)
ActiveRecord::Migration.include(MigrationHelpers::Shared)
