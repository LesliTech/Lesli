# Database migrations

## Codes

Each engine of Lesli has it's own migration prefix which conforms the first 4 digits of the migration file.

### Administration
- 01.00. [**Lesli**](https://github.com/leitfaden/Lesli/blob/master/docs/db/database.md)
- 01.01. [**CloudTeam**](https://github.com/leitfaden/cloud_team/blob/master/docs/database.md)

### Sales & Marketing
- 02.04. [**CloudHouse**](https://github.com/leitfaden/cloud_house/blob/master/docs/database.md)
- 02.05. [**CloudMailer**](https://github.com/leitfaden/cloud_mailer/blob/master/docs/database.md)
- 02.08. [**CloudProposal**](https://github.com/leitfaden/cloud_proposal/blob/master/docs/database.md)

### Productivity & Teamwork
- 03.01. [**CloudDriver**](https://github.com/leitfaden/cloud_driver/blob/master/docs/database.md)
- 03.03. [**CloudFocus**](https://github.com/leitfaden/cloud_focus/blob/master/docs/database.md)
- 03.05. [**CloudText**](https://github.com/leitfaden/cloud_text/blob/master/docs/database.md)
- 03.08. [**CloudBell**](https://github.com/leitfaden/cloud_bell/blob/master/docs/database.md)
- 03.10. [**CloudTalk**](https://github.com/leitfaden/cloud_talk/blob/master/docs/database.md)
- 03.11. [**CloudStorage**](https://github.com/leitfaden/cloud_storage/blob/master/docs/database.md)


### Finance
- 04.03. [**CloudThings**](https://github.com/leitfaden/cloud_things/blob/master/docs/database.md)

### IT & Help Desk
- 07.01. [**CloudKb**](https://github.com/leitfaden/cloud_kb/blob/master/docs/database.md)
- 07.02. [**CloudHelp**](https://github.com/leitfaden/cloud_help/blob/master/docs/database.md)
- 09.06. [**CloudPortal**](https://github.com/leitfaden/cloud_portal/blob/master/docs/database.md)
### Security & Privacy
- 08.03. [**CloudAudit**](https://github.com/le`itfaden/cloud_audit/blob/master/docs/database.md)

### Integrations
- 09.01. [**CloudBabel**](https://github.com/leitfaden/cloud_babel/blob/master/docs/database.md)
- 09.02. [**CloudDispatcher**](https://github.com/leitfaden/cloud_dispatcher/blob/master/docs/database.md)
- 09.03. [**CloudFederation**](https://github.com/leitfaden/cloud_federation/blob/master/docs/database.md)
- 09.04. [**CloudOne**](https://github.com/leitfaden/cloud_one/blob/master/docs/database.md)
- 09.06. [**CloudDevelopment**](https://github.com/leitfaden/cloud_development/blob/master/docs/database.md)

## Explaning migrations code

The migration code is conformed by **engine code** + **migration identifier** + **version**

Engine Code: `0100 (xxxx)`

Migration identifier: `0001 (yyyy)`

Folder Version: `v1.0 (zz)`

Code: `0100000110 (xxxxyyyyzz)`
## Database versioning
Every stable version of the platform should come with their own database structure; Lesli database version is completely different from Rails migration versioning.

Every change (version) of the database should be in their own folder, the folder should be named with the name of the current working version of the system and the migration should be sufixed with the same version that we are currently working on.

### Database versioning example
| version       |   migration name
|-              |-
| version 1.0   |   0100000310_create_test  (base migration)
| version 1.1   |   0100000311_alter_test   (add a new field)
| version 1.2   |   0100000312_alter_test   (add a new field)
| version 1.3   |   0100000320_alter_test   (change field from string to integer)

## Database versioning standard

### Create Table

The correct migration name to create a table is **create_<table_name>**.

Example:

Assuming we have the following migrations defined and we want to create new table **(user_shorcuts)**.

```bash
  - v1.0
    - 01000000310_create_users.rb
    - 01000003110_create_user_details.rb
    - 01000003210_create_user_settings.rb
    - 01000003310_create_user_sessions.rb
    - 01000003410_create_user_requests.rb
    - 01000003510_create_user_activites.rb
    - 01000003610_create_user_roles.rb
    - 01000003710_create_user_logs.rb
    - 01000003810_create_user_access_codes.rb
```

The correct migration code is 0100003811.

Explanation:
- Engine code: **0100**
- Migration identifier prefix for users: **003**
- Available identifier sufix for users: **9**
- Folder version: **1.1**


1. Create migration using the scaffold generator
```bash
  rails generate scaffold user_shortcuts
```

3. Move the migration with a standard name.
```bash
  mv db/migrate/20211029165345_create_user_shortcuts.rb db/v1.1/migrate/01000003911_create_user_shortcuts.rb
```

3. Create table
```ruby
class CreateUserShortcuts < ActiveRecord::Migration[6.1]
    def change
        create_table :user_shortcuts do |t|
            t.string :name
            t.string :icon
            t.string :url
            t.string :engine_code

            t.datetime :deleted_at, index: true
            t.timestamps
        end
        add_reference :user_shortcuts, :users, foreign_key: true
    end
end
```

### Alter Table
For any change on the table the correct migration name is **alter_<table_name>**.

- Add column
- Rename column
- Remove column
- Change column type

Example:

Assuming we have the following database definition.
```ruby
class CreateTests < ActiveRecord::Migration[6.0]
    def change
        create_table :tests do |t|
            t.string    :name
            t.string    :description
            t.boolean   :active

            t.timestamps
        end
    end
end
```

1. Add a new field on the table.

```ruby
  rails generate migration cre_test
```

2. Move the migration with a standard name.
```bash
  mv db/migrate/20211029165321_alter_tests.rb db/v1.1/migrate/0100000111_alter_tests.rb
```

3. Add a new column.
```ruby
class CreateTests < ActiveRecord::Migration[6.0]
    def change
        add_column :tests, :importance, :string
    end
end
```

### Drop Table

The correct migration name to delete a table is **drop_<table_name>**.

Example:
1. Create migration

```bash
  rails generate migration drop_tests
```

2. Rename the migration with a standard name
```bash
  mv db/migrate/20211029165321_drop_tests.rb db/v1.2/migrate/0100000112_drop_tests.rb
```

3. Drop table
```ruby
class DropTests < ActiveRecord::Migration[6.1]
    def change
        drop_table :tests
    end
end
```