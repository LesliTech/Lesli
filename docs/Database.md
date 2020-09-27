## Database

Contents
1. [00.00. Lesli](#0000-lesli-core)
3. [02.04. CloudHouse](#0204-cloudhouse)
4. [02.05. CloudMailer](#0205-cloudmailer)


### 00.00 Lesli (core)
```  
    00.01. accounts
    00.02. roles 
    00.03. users 

    00.10. account/settings
    00.11. account/locations
    00.12. account/activities   # tracks system tasks and processes
    
    00.20. role/details
    00.21. role/privileges
    00.22. role/overrides
    00.23. role/privilege_defaults

    00.30. user/details
    00.31. user/settings
    00.32. user/sessions    # save user login information
    00.33. user/requests    # tracks user activities on the system
    00.34. user/activities  # tracks changes over current_user

    00.40. user/templates
    00.41. user/template/documents
    00.42. user/template/variables
    00.43. user/template/mapping
```


### 02.04. CloudHouse  
```
    00.01. house/account
    
    01.01. house/catalogs
    01.02. house/catalog/business_services
    01.03. house/catalog/project_types
    01.04. house/catalog/company_categories

    02.01. house/workflows
    02.02. house/workflow/statuses
    02.03. house/workflow/associations
    02.04. house/workflow/actions 

    03.01. house/custom_fields

    04.01. house/custom_validations  
    04.02. house/custom_validation/rules  
    04.03. house/custom_validation/fields  

    10.01. house/contacts
    10.02. house/contact/details 
    10.03. house/contact/actions 
    10.04. house/contact/activities 
    10.05. house/contact/discussions 
    10.06. house/contact/files 
    10.07. house/contact/subscribers  
    10.08. house/contact/custom_fields

    11.01. house/properties
    11.02. house/property/details 
    11.03. house/property/actions 
    11.04. house/property/activities 
    11.05. house/property/discussions 
    11.06. house/property/files 
    11.07. house/property/subscribers  
    11.08. house/property/custom_fields
    11.10. house/property/uses
    11.11. house/property/registers
    11.12. house/property/validations
    11.13. house/property/binding_validations
    11.14. house/property/annuities

    12.01. house/companies
    12.02. house/company/details 
    12.03. house/company/actions 
    12.05. house/company/activities 
    12.05. house/company/discussions 
    12.06. house/company/files 
    12.07. house/company/subscribers  
    12.08. house/company/custom_fields
    12.10. house/company/associates
    
    13.01. house/employees
    13.02. house/employee/details 
    13.03. house/employee/actions 
    13.04. house/employee/activities 
    13.05. house/employee/discussions 
    13.06. house/employee/files 
    13.07. house/employee/subscribers  
    13.08. house/employee/custom_fields
    13.10. house/employee/services

    14.01. house/projects
    14.02. house/project/details
    14.03. house/project/actions 
    14.04. house/project/activities 
    14.05. house/project/discussions 
    14.06. house/project/files 
    14.07. house/project/subscribers  
    14.08. house/project/custom_fields
    14.10. house/project/customers
    14.11. house/project/services
    14.12. house/project/offer_reports
    14.13. house/project/marketing_information

    00.00. house/[deals|contracts]
```

### 02.05. CloudMailer 
```
    00.01. mailer/account

    10.00. mailer/audience
    10.01. mailer/audience/details 
    10.02. mailer/audience/actions 
    10.03. mailer/audience/activities 
    10.04. mailer/audience/discussions 
    10.05. mailer/audience/subscribers 
    10.06. mailer/audience/files 
    10.10. mailer/audience/contacts
    
    11.00. mailer/campaigns
    11.01. mailer/campaign/details 
    11.02. mailer/campaign/actions 
    11.03. mailer/campaign/activities 
    11.04. mailer/campaign/discussions 
    11.06. mailer/campaign/subscribers  
    11.05. mailer/campaign/files 
    11.10. mailer/campaign/statistics
```

# To review

### 03.01. CloudDriver
```
    00.01. driver/account
    00.02. driver/custom_fields
    
    01.01. driver/catalog
    01.02. driver/catalog/business_services

    02.01. driver/workflow
    02.02. driver/workflow/statuses
    02.03. driver/workflow/associations
    02.04. driver/workflow/actions

    10.01. driver/calendar
    10.02. driver/calendar/details 
    10.03. driver/calendar/actions 
    10.04. driver/calendar/activities 
    10.05. driver/calendar/discussions 
    10.06. driver/calendar/files 
    10.07. driver/calendar/subscribers  
    10.09. driver/calendar/custom_field_values

    11.01. driver/event
    11.02. driver/events/details 
    11.03. driver/events/actions 
    11.04. driver/events/activities 
    11.05. driver/events/discussions 
    11.06. driver/events/files 
    11.07. driver/events/subscribers  
    11.08. driver/events/custom_field
    11.09. driver/events/attendances
```

### 03.03. CloudFocus - Task Management
```
    00.01. focus/account
    
    02.01. focus/workflows
    02.02. focus/workflow/statuses
    02.03. focus/workflow/associations
    02.04. focus/workflow/actions 

    03.01. focus/custom_fields

    04.01. focus/custom_validations  
    04.02. focus/custom_validation/rules  
    04.03. focus/custom_validation/fields  

    10.01. focus/task
    10.02. focus/task/details 
    10.03. focus/task/actions 
    10.04. focus/task/activities 
    10.05. focus/task/discussions 
    10.06. focus/task/files 
    10.07. focus/task/subscribers 
    10.08. focus/task/custom_field_values  
```

### 03.05. CloudNotes - Notes & Notebooks
```
    00.01. notes/account

    10.01. notes/notebook
    10.02. notes/notebook/details 
    10.03. notes/notebook/actions 
    10.04. notes/notebook/activities 
    10.05. notes/notebook/discussions 
    10.06. notes/notebook/files 
    10.07. notes/notebook/subscribers  

    11.01. notes/note
    11.02. notes/note/details 
    11.03. notes/note/actions 
    11.04. notes/note/activities 
    11.05. notes/note/discussions 
    11.06. notes/note/files 
    11.07. notes/note/subscribers  

```

### 07.01. CloudKb
```
    00.01. kb/account 

    01.01. kb/catalog
    01.02. kb/catalog/categories

    02.01. kb/workflow
    02.02. kb/workflow/states
    02.03. kb/workflow/details

    10.01. kb/article
    10.02. kb/article/details 
    10.03. kb/article/actions 
    10.04. kb/article/activities 
    10.05. kb/article/discussions 
    10.06. kb/article/files 
    10.07. kb/article/subscribers  
    10.08. kb/article/custom_fields 
    10.09. kb/article/categories 
```

### 07.02. CloudHelp
```
    00.01. help/account 

    01.01. help/catalog
    01.02. help/catalog/ticket_categories 
    01.03. help/catalog/ticket_priorities
    01.04. help/catalog/ticket_types
    01.05. help/catalog/ticket_sources

    02.01. help/workflow
    02.02. help/workflow/statuses
    02.03. help/workflow/associations

    03.01. help/ticket 
    03.02. help/ticket/details 
    03.03. help/ticket/actions 
    03.04. help/ticket/activities 
    03.05. help/ticket/discussions 
    03.06. help/ticket/files 
    03.07. help/ticket/subscribers
    03.08. help/ticket/custom_fields
    03.09. help/ticket/timelines
    03.10. help/ticket/assignments

    04.01. help/sla
    04.02. help/sla/associations
```

### 08.03. CloudAudit
```
    00.01. audit/account 
```

### 10.01. CloudBabel
```
    01.01. babel/translations 
    01.02. babel/translation/modules 
    01.03. babel/translation/buckets
    01.04. babel/translation/strings 
```
