# Lesli Database structure

The database structure of Lesli and all the engines must be documented and maintained within the respective engine in the following path: *engine\_root/docs/database.md*. If you make any changes that add, remove or renumber any table, you **must** document it within this file, or your pull request will be rejected. 


## Namespace and Table Number Standard and Required Tables 
To calculate engines and tables numerations, you should meet the following requirements:

**1.** Each engine has an account table, that isolates the resources to each account, this table is always the code **CC.EE.00.01** 

**2.** After the account, the catalogs namespace is used with the numeration **CC.EE.01**. A catalog table is a table that has only data, with no foreign key other than the account, and is used to provide data to other more complex tables. Your first catalog table must have the code **CC.EE.01.01** 

**3.** The workflows namespace is next and it contains the codes **CC.EE.02.TT** starting with the table **CC.EE.02.01**: **cloud\_ENGINE\_workflows** 

**4.** The custom\_fields namespace is next and it contains the codes **CC.EE.03.TT** starting with the table **CC.EE.03.01**: **cloud\_ENGINE\_custom_fields** 

**5.** The custom_validations namespace is next and it contains the codes **CC.EE.04.TT** starting with the table **CC.EE.04.01**: **cloud\_ENGINE\_custom\_validations**

**6.** The dashboards namespace is next and it contains the codes **CC.EE.05.TT** starting with the table **CC.EE.05.01**: **cloud\_ENGINE\_dashboards** 

The codes **CC.EE.06.TT** to **CC.EE.09.TT** are reserved for future usage. 

After this you can create any number of tables depending on the amount of resources you will have in your engine. Starting with the namespace **CC.EE.10**, these tables have the following format:

```
- **CC.EE.10.00** Main table
- **CC.EE.10.01** Main table actions
- **CC.EE.10.02** Main table activities
- **CC.EE.10.03** Main table discussions
- **CC.EE.10.04** Main table subscribers
- **CC.EE.10.05** Main table files
- **CC.EE.10.06** Main table custom\_field\_values
- **CC.EE.10.07** to **10.09** are reserved
- **CC.EE.10.10** and higher are for your custom tables
```


## Example of database.md file

Here is an example of a database.md file for the CloudHelp engine (code **07.02**) (this is just an example, for the real database documentation you should review the **DATABASE STRUCTURE** section):

```plaintext
    07.02.00.01. support/account  

    07.02.00.10. support/settings 
    07.02.00.20. support/catalogs 
    07.02.00.30. support/dashboards 

    07.02.11.01. support/tickets
    07.02.11.02. support/ticket/actions 
    07.02.11.03. support/ticket/activities 
    07.02.11.04. support/ticket/discussions 
    07.02.11.05. support/ticket/subscribers 
    07.02.11.06. support/ticket/attachments 
    07.02.11.07. support/ticket/versions
```
