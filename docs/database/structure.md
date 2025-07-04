# Lesli Database structure

The database structure of Lesli and all the engines must be documented and maintained within the respective engine in the following path: *engine\_root/docs/database.md*. If you make any changes that add, remove or renumber any table, you **must** document it within this file, or your pull request will be rejected. 


## Example of database.md file

Here is an example of a database.md file for the LesliSupport engine (code **07.02**) (this is just an example, for more details about database standards you should check the **DATABASE VERSIONING** section):

```plaintext
// Se utiliza para asociar la data del engine a su propia cuenta
07.02.00.01. support/account  

// Tablas de servicio
07.02.00.10. support/settings 
07.02.00.20. support/catalogs 
07.02.00.21. support/catalog/items
07.02.00.30. support/dashboards 

// Tablas dedicadas de funcionalidad compartida
07.02.00.50. support/workflows
07.02.00.51. support/workflow/statuses
07.02.00.52. support/workflow/associations
07.02.00.53. support/workflow/actions

// Tablas de funcionalidad especifica
07.02.10.01. support/slas

// Tablas de funcionalidad especifica
07.02.11.01. support/tickets
07.02.11.02. support/ticket/actions 
07.02.11.03. support/ticket/activities 
07.02.11.04. support/ticket/discussions 
07.02.11.05. support/ticket/subscribers 
07.02.11.06. support/ticket/attachments 
07.02.11.07. support/ticket/versions
```
