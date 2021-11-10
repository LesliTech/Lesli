# Lesli Command Line Interface

Lesli cli has commands, actions and arguments. Arguments are optional, while commands and actions are required. The syntax is:

```bash
rails lesli command action [arguments]
```

## User commands

The user commands allow to work with users globally in an instance.

```text
rails lesli:user add [email_address]
rails lesli:user delete [email_address]
rails lesli:user disable [email_address]
rails lesli:user enable [email_address|all]
rails lesli:user resetpassword [email_address|all]
rails lesli:user changepassword [email_address|all]
rails lesli:user [list role_id|role_code|role_name|all]
```

## Instance commands
```text
rails lesli:instance clean
rails lesli:instance release
```

## Account commands
```text
rails lesli:account clean [account_id]
rails lesli:account release [account_id]
```

## System commands
```text
rails lesli:system status
rails lesli:system maintenance
```

## System commands
```text 
rails lesli:cron disable 
rails lesli:cron enable 
rails lesli:cron run [task_name|all]
```
