
# Lesli Core Database Registry

This registry records stable table codes owned by Lesli Core. Tables provided by optional engines belong in the registry and migrations of those engines.

```text
00.00.00.01  lesli_accounts
00.00.00.02  lesli_users
00.00.00.03  lesli_roles
00.00.00.04  lesli_resources
```

The executable source of truth is `db/migrate`. See the [database architecture](database/structure.md) and [migration versioning](database/versioning.md) guides for ownership and filename conventions.

```plaintext

    00.00.00.01. lesli_accounts 
    00.00.00.02. lesli_roles
    00.00.00.03. lesli_users

    00.00.10.01. lesli_system_controllers 
    00.00.10.02. lesli_system_controller_actions

    00.00.11.01. lesli_accounts (reference only)
    00.00.11.02. lesli_account_details
    00.00.11.03. lesli_account_settings
    00.00.11.04. lesli_account_activities
    00.00.11.05. lesli_account_locations
    00.00.11.06. lesli_account_currencies

    00.00.12.01. lesli_roles (reference only)
    00.00.12.02. lesli_role_actions
    00.00.12.03. lesli_role_privileges

    00.00.13.01. lesli_user (reference only)
    00.00.13.02. lesli_user_roles
    00.00.13.03. lesli_user_sessions
    00.00.13.03. lesli_user_activities
```
