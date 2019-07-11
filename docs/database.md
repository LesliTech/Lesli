# Database
```
LesliCloud 
    users 
    account_plans 


    CloudPanel
    -     -     -     -     -     -     -     -
    panel/companies

    panel/catalog_currencies                  -> belongs to enum
    panel/catalog_user_roles 
    panel/catalog_user_role_privileges
    panel/catalog_location_continents
    panel/catalog_location_countries
    panel/catalog_location_states
    panel/catalog_location_cities

    panel/core_attachments
    panel/core_activities (logs) 
    panel/core_comments 
    panel/core_actions (quick tasks) 
    panel/core_locations
        address
        zip_code
        street_name
        street_number
        street_other 
        geo_longitud
        geo_latitud
        geo_altitud

    panel/company_details 
    panel/company_contact_details 

    panel/users 
    panel/user_details 
    panel/user_settings 
    panel/user_privileges


    CloudTeam 
    -     -     -     -     -     -     -     -
    team/core_attachments
    team/core_activities (logs) 
    team/core_comments 
    team/core_actions (quick tasks) 
    team/core_locations

    team/employees 
    team/employee_details 

    team/employee_social_accounts 
    team/employee_contact_details 
    team/employee_contact_emergency_details
    
    team/employee_attachments 
    team/employee_activities 
    team/employee_comments 
    team/employee_actions 

    team/contracts
    team/contract_details

    team/contract_attachments
    team/contract_activities
    team/contract_comments
    team/contract_actions

    team/licenses (permisos)
    team/license_details
http://www.darrenbeck.co.uk/blockchain/nodejs/nodejscrypto/
    team/license_attachments
    team/license_activities
    team/license_comments
    team/license_actions

    team/onboardings








    CloudLeaf
        catalogs  
        actions  
        activities  
        statuses  
        companies  
            details  
            comments  
            activities  
            actions
        contacts  
            details  
        proposals  
            details  
            comments  
            activities  
            actions
            statuses
            contacts
            employees  
        contracts  
            details  
            comments  
            activities  
            actions
            statuses
            contacts
            employees  
        projects  
            details  
    CloudChaos  
    CloudDriver
    CloudLesli
    CloudPortal
    CloudAuth
    CloudPanel
```
