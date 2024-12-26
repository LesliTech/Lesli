# Database versioning

Lesli is designed to integrate with multiple modules (standard Rails Engines). To prevent naming collisions and maintain a well-structured and organized database schema, we present the following guide for working with the Lesli database structure.

Working with Ruby on Rails migrations in the proposed way can have several benefits:

1. **Consistency**: By following a structured naming convention and versioning standard, developers ensure consistency across migrations within the project.

2. **Clarity**: The naming convention provides clear information about the purpose and version of each migration, making it easier for developers to understand and manage database changes.

3. **Maintainability**: Organizing migrations into version-specific folders and following consistent naming conventions can improve the maintainability of the database schema over time, especially in larger projects with frequent updates.

4. **Collaboration**: Standardized migration practices make it easier for multiple developers to collaborate on the same project, as everyone follows the same conventions and understands the structure of migrations.

5. **Scalability**: As the project grows and evolves, having a structured approach to migrations can help manage complexity and ensure that database changes remain manageable and organized.


## Working with Rails migrations
A rails migration file name must containt a number as a prefix that helps rails identify which migrations should be executed and in which order. We take advantage on this feature by replacing the default rails numeration (timestamp) with our custom numbering system. The prefix number of each table must be a 8-digit decimal number that adheres to the format CC.EE.NN.TT.VV, where:

**— CC** is a 2-digit number that represents a the collection of the table. Engines that work within the same area have the same collection number. For Example **LesliCalendar** (our Unified calendar app) and **LesliLetter** (Notes & Notebooks) are both under the **03** collection. There is a detailed list of all collections in the [Ecosystem section.](/engines/lesli/about/ecosystem). 

**— EE** is a 2-digit number that identifies a specific engine within a collection. In our previous example, LesliCalendar is **03.01** and LesliLetter is **03.05** There is a detailed list of all engines (implemented or not) in the [Ecosystem section.](/engines/lesli/about/ecosystem).  

**— NN** is a 2-digit number that identifies a namespace within the engine. Namespaces must be unique within the engine, but 2 different engines can (and will in some cases) have the same namespace. For example, the table **lesli\_letter\_notes** and all its child tables are all within the **03.05.11** namespace.

**— TT** is a 2-digit number that identifies a specific table within the namespace. For example, the table **lesli\_letter\_notes** has the code **03.05.11.01** while the table **lesli\_letter\_notes\_activities** has the code **03.05.11.04**.

**— VV** is a 2-digit number that identifies the version of the migration, this number correspond to the folder version inside the migration folder.

**Summary:**
<br /> **CC:** Collection of engines 
<br /> **EE:** Engine identification number 
<br /> **NN:** Engine feature namespace
<br /> **TT:** Engine feature table number
<br /> **VV:** Engine feature table version 


### Migration example 
For this example we are going to use the **0702110110_create_lesli_support_tickets.rb** migration of the [LesliSupport](/engines/support/) engine.

**07:** Collection of engines 
<br /> **02:** Engine identification number 
<br /> **11:** Engine feature namespace
<br /> **01:** Engine feature table number
<br /> **10:** Engine feature table version 

So the final code is **07.02.11.01.10.**

## Database versioning
Each stable version of the engines should include its own database structure; the Lesli database versioning 
system is completely different from Rails migration versioning.

Every database change (version) should reside in its own folder, named after the current working version of the system, and the migration file within should be suffixed with the same version we are currently working on.

You can check the [Lesli Ecosystem](/engines/lesli/about/ecosystem) for reference about the engine codes.


### Database versioning example
| version           |   migration name
|-                  |-
| version **1.0**   |   07021101**10**\_create\_lesli\_support\_tickets.rb  (base migration)
| version **1.1**   |   07021101**11**\_alter\_lesli\_support\_tickets.rb   (add a new field)
| version **1.2**   |   07021101**12**\_alter\_lesli\_support\_tickets.rb   (add a new field)
| version **2.0**   |   07021101**20**\_alter\_lesli\_support\_tickets.rb   (change field from string to integer)

### Database versioning standard for new tables
The correct migration name to create a table is **create\_table\_name**.

Example:
Assuming we've following migrations defined and we want to create new table **(tickets)**.

**1.** Create migration using the scaffold generator

```shell
  rails generate scaffold tickets
```

**3.** Rename the migration with a standard name.

```
  from 20211029165345_create_lesli_support_tickets.rb 
  to /v1.1/0702110510_create_lesli_support_tickets.rb
```

This is how our migration structure should look like for our new table:
```
rails_engine/
    db/
        migrate/
            v1.0/
                0702110110_create_lesli_support_tickets.rb
```



### Database versioning standard to modify existing tables
For any change on the table the correct migration name is **alter\_table\_name\_action**.

Actions:
- Add column
- Rename column
- Remove column
- Change column type

**Example:**

Assuming we have the following database definition.

```ruby
class CreateTickets < ActiveRecord::Migration[6.0]
    def change
        create_table :tickets do |t|
            t.string    :name
            t.string    :description
            t.boolean   :active

            t.timestamps
        end
    end
end
```

**1.** Add a new column to the table.

```shell
  rails generate migration alter_tickets
```

**2.** Rename the migration with a standard name.

```
  20211029165321_alter_tickets.rb ——> /v1.1/0702110111_create_lesli_support_tickets.rb
```

**3.** Add a new column.

```ruby
class AlterTickets < ActiveRecord::Migration[6.0]
    def change
        add_column :tickets, :importance, :string
    end
end
```

> [!IMPORTANT]
> Note that the migration code is the same as the original migration that creates the table, with the small difference that this new migration increase the version number.

So now of migration structure should look like:

```
rails_engine/
    db/
        migrate/
            v1.0/
                0702110110_create_lesli_support_tickets.rb
            v1.1/
                0702110111_alter_lesli_support_tickets.rb
```
