=begin

Lesli

Copyright (c) 2025, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Ruby on Rails SaaS Development Framework.

Made with ♥ by LesliTech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

require(Lesli::Engine.root.join("lib/migrate/common"))

require(Lesli::Engine.root.join("lib/migrate/items/action_structure"))
require(Lesli::Engine.root.join("lib/migrate/items/activity_structure"))
require(Lesli::Engine.root.join("lib/migrate/items/attachment_structure"))
require(Lesli::Engine.root.join("lib/migrate/items/discussion_structure"))
require(Lesli::Engine.root.join("lib/migrate/items/subscriber_structure"))
require(Lesli::Engine.root.join("lib/migrate/items/version_structure"))

require(Lesli::Engine.root.join("lib/migrate/shared/account_structure"))
require(Lesli::Engine.root.join("lib/migrate/shared/catalog_structure"))


ActiveRecord::Migration.include(MigrationHelpers::Common)

ActiveRecord::Migration.include(MigrationHelpers::Items::ActionStructure)
ActiveRecord::Migration.include(MigrationHelpers::Items::ActivityStructure)
ActiveRecord::Migration.include(MigrationHelpers::Items::AttachmentStructure)
ActiveRecord::Migration.include(MigrationHelpers::Items::DiscussionStructure)
ActiveRecord::Migration.include(MigrationHelpers::Items::SubscriberStructure)
ActiveRecord::Migration.include(MigrationHelpers::Items::VersionStructure)

ActiveRecord::Migration.include(MigrationHelpers::Shared::AccountStructure)
ActiveRecord::Migration.include(MigrationHelpers::Shared::CatalogStructure)
