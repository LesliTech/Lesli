
# Initialization Values

In order for any engine to work properly on installation, a few initial values are created along with the account. These values may include catalog values, default resources, basic roles, and any other record that is required by the engine at all times. 

These resources must be created using the **after_create** callback on the Account model of the engine and shoud be whithin the **protected** directive. This is an example of how it should look:

```ruby
module CloudHelp
    class Account < ApplicationLesliRecord
        after_create :initialize_account
        
        protected

        def initialize_account
            Workflow.initialize_data(self)
            Dashboard.initialize_data(self)
            Sla.initialize_data(self)
            Catalog.initialize_data(self)

            Account::Setting.initialize_data(self)
        end
    end
end
```


# Localization for the Initialization Values

In order to provide compatibility to the localization feature, the names of these records are managed by a special **I18n** file. This file is located in the core as well as in every engine, and is bundled when the gem is created. The file is located in: **config/locales/engine_name/initializer.yml**.

The format of this can vary depending on the needs of the engine, but it must always start like this:

```yml
---
:locale:
  engine_suffix:
    initial_values:
        ...
```

You should always try to follow the DRY standard when creating labels. For example, the initializer.yml for cloud_help should be similar to:
```yml
---
:en:
  help:
    initial_values:
        catalog_ticket_sources:
            cloud_help: "CloudHelp"
        catalog_ticket_categories:
            user_management: "User Management"
        catalog_ticket_priorities:
        catalog_ticket_types:
            bug: "Bug"
        slas:
            default_sla: "Default SLA"
:es:
  help:
    initial_values:
        catalog_ticket_sources:
            cloud_help: "CloudHelp"
        catalog_ticket_categories:
            user_management: "Manejo de Usuarios"
        catalog_ticket_priorities:
            lowest: "Muy Baja"
        catalog_ticket_types:
            bug: "Bug"
        slas:
            default_sla: "ANS Predeterminado"
```
