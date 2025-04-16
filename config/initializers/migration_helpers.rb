
require(Lesli::Engine.root.join("lib/migration_helpers/common"))
require(Lesli::Engine.root.join("lib/migration_helpers/items/action_structure"))
require(Lesli::Engine.root.join("lib/migration_helpers/items/activity_structure"))
require(Lesli::Engine.root.join("lib/migration_helpers/items/attachment_structure"))
require(Lesli::Engine.root.join("lib/migration_helpers/items/discussion_structure"))
require(Lesli::Engine.root.join("lib/migration_helpers/items/subscriber_structure"))
require(Lesli::Engine.root.join("lib/migration_helpers/items/version_structure"))
require(Lesli::Engine.root.join("lib/migration_helpers/shared"))

ActiveRecord::Migration.include(MigrationHelpers::Common)
ActiveRecord::Migration.include(MigrationHelpers::Items::ActionStructure)
ActiveRecord::Migration.include(MigrationHelpers::Items::ActivityStructure)
ActiveRecord::Migration.include(MigrationHelpers::Items::AttachmentStructure)
ActiveRecord::Migration.include(MigrationHelpers::Items::DiscussionStructure)
ActiveRecord::Migration.include(MigrationHelpers::Items::SubscriberStructure)
ActiveRecord::Migration.include(MigrationHelpers::Items::VersionStructure)
ActiveRecord::Migration.include(MigrationHelpers::Shared)
