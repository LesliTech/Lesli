# Lesli Database structure

The database structure of Lesli and all the engines must be documented and maintained within the respective engine in the following path: *engine\_root/docs/database.md*. If you make any changes that add, remove or renumber any table, you **must** document it within this file, or your pull request will be rejected. 


## Example of database.md file

Here is an example of a database.md file for Lesli core and LesliSupport engine (code **07.02**) (this is just an example, for more details about database standards you should check the **DATABASE VERSIONING** section):

### Lesli core database 

```plaintext
00.00.00.01 lesli/accounts
00.00.00.02 lesli/users
00.00.00.03 lesli/roles
00.00.00.04 lesli/resources
```

### LesliSupport database

```plaintext
07.02.00.01. support/account  

// Tablas de servicio
07.02.00.10. support/catalogs 
07.02.00.20. support/workflows 

// Tablas de items
07.02.01.01. support/tasks 
07.02.01.02. support/activities 
07.02.01.03. support/discussions 
07.02.01.04. support/attachments 
07.02.01.05. support/subscribers

// Tablas de funcionalidad especifica
07.02.10.01. support/slas

// Tablas de funcionalidad especifica
07.02.11.01. support/tickets
```
