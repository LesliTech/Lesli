# Database migrations and versioning
Each engine of Lesli has it's own migration prefix which conforms the first 4 digits of the migration file.


## Explaning migrations code
The migration code is conformed by **engine code** + **migration identifier** + **version**

Engine Code: `0100 (CCEE)`

Migration identifier: `0001 (NNTT)`

Folder Version: `v10 (VV)`

Code: `0100000110 (CCEENNTTVV)`


## Database versioning
Every stable version of the platform should come with their own database structure; Lesli database version is completely different from Rails migration versioning.

Every change (version) of the database should be in their own folder, the folder should be named with the name of the current working version of the system and the migration should be sufixed with the same version that we are currently working on.


### Database versioning example
| version           |   migration name
|-                  |-
| version **1.0**   |   01000003**10**\_create\_test  (base migration)
| version **1.1**   |   01000003**11**\_alter\_test   (add a new field)
| version **1.2**   |   01000003**12**\_alter\_test   (add a new field)
| version **2.0**   |   01000003**20**\_alter\_test   (change field from string to integer)



## Database versioning standard

### Create Table
The correct migration name to create a table is **create\_table\_name**.

Example:

Assuming we have the following migrations defined and we want to create new table **(user_shortcuts)**.

```textplain
v1.0/
    01000000310_create_users.rb
    01000003110_create_user_details.rb
    01000003210_create_user_settings.rb
    01000003310_create_user_sessions.rb
    01000003410_create_user_requests.rb
    01000003510_create_user_activites.rb
    01000003610_create_user_roles.rb
    01000003710_create_user_logs.rb
    01000003810_create_user_access_codes.rb
```

The correct migration code is 0100003811.

Explanation:
- Engine code: **0100**
- Migration identifier prefix for users: **003**
- Available identifier sufix for users: **9**
- Folder version: **1.1**


**1.** Create migration using the scaffold generator

```shell
  rails generate scaffold user_shortcuts
```

**3.** Rename the migration with a standard name.

```textplain
  20211029165345_create_user_shortcuts.rb ——> /v1.1/01000003911_create_user_shortcuts.rb
```

<br />

### Alter Table 
For any change on the table the correct migration name is **alter\_table\_name**.

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

**1.** Add a new field on the table.

```shell
  rails generate migration alter_tests
```

**2.** Rename the migration with a standard name.

```textplain
  20211029165321_alter_tests.rb ——> /v1.1/0100000111_alter_tests.rb
```

**3.** Add a new column.

```ruby
class CreateTests < ActiveRecord::Migration[6.0]
    def change
        add_column :tests, :importance, :string
    end
end
```

### Drop Table

The correct migration name to delete a table is **drop\_table\_name**.

Example:
**1.** Create migration

```shell
  rails generate migration drop_tests
```

**2.** Rename the migration with a standard name

```textplain
  20211029165321_drop_tests.rb ——> /v1.2/0100000112_drop_tests.rb
```

**3.** Drop table

```ruby
class DropTests < ActiveRecord::Migration[6.1]
    def change
        drop_table :tests
    end
end
```
