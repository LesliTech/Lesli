=begin

Copyright (c) 2020, all rights reserved.

All the information provided by this platform is protected by international laws related  to
industrial property, intellectual property, copyright and relative international laws.
All intellectual or industrial property rights of the code, texts, trade mark, design,
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// ·

=end

account = Account.find_by(company_name: Rails.application.config.lesli_settings["account"]["company"]["name"])
# Project variables

    # Main owner customer
account.template.variables.create(name: "Main_Owner_Customer_Last_Name", field_name: "last_name", table_name: "cloud_house_contact_details", table_alias: "chcd1", model_type: "CloudHouse::Project", variable_type: "table")
account.template.variables.create(name: "Main_Owner_Customer_Street_Name", field_name: "street_name", table_name: "cloud_house_contact_details", table_alias: "chcd1", model_type: "CloudHouse::Project", variable_type: "table")
account.template.variables.create(name: "Main_Owner_Customer_Street_Number", field_name: "street_number", table_name: "cloud_house_contact_details", table_alias: "chcd1", model_type: "CloudHouse::Project", variable_type: "table")
account.template.variables.create(name: "Main_Owner_Customer_Street_Other", field_name: "street_other", table_name: "cloud_house_contact_details", table_alias: "chcd1", model_type: "CloudHouse::Project", variable_type: "table")
account.template.variables.create(name: "Main_Owner_Customer_Zipcode", field_name: "postcode", table_name: "cloud_house_contact_details", table_alias: "chcd1", model_type: "CloudHouse::Project", variable_type: "table")
account.template.variables.create(name: "Main_Owner_Customer_Birthdate", field_name: "birthdate", table_name: "cloud_house_contact_details", table_alias: "chcd1", model_type: "CloudHouse::Project", variable_type: "table")
account.template.variables.create(name: "Main_Owner_Customer_Gender", field_name: "gender", table_name: "cloud_house_contact_details", table_alias: "chcd1", model_type: "CloudHouse::Project", variable_type: "table")
account.template.variables.create(name: "Main_Owner_Customer_Salutation", field_name: "salutation", table_name: "cloud_house_contact_details", table_alias: "chcd1", model_type: "CloudHouse::Project", variable_type: "table")
account.template.variables.create(name: "Main_Owner_Customer_Email", field_name: "email", table_name: "cloud_house_contact_details", table_alias: "chcd1", model_type: "CloudHouse::Project", variable_type: "table")
account.template.variables.create(name: "Main_Owner_Customer_Phone", field_name: "Telephone", table_name: "cloud_house_contact_details", table_alias: "chcd1", model_type: "CloudHouse::Project", variable_type: "table")
account.template.variables.create(name: "Main_Owner_Customer_Mobile_Number", field_name: "mobile_number", table_name: "cloud_house_contact_details", table_alias: "chcd1", model_type: "CloudHouse::Project", variable_type: "table")
account.template.variables.create(name: "Main_Owner_Customer_Fax", field_name: "fax_number", table_name: "cloud_house_contact_details", table_alias: "chcd1", model_type: "CloudHouse::Project", variable_type: "table")
account.template.variables.create(name: "Main_Owner_Customer_Title", field_name: "title", table_name: "cloud_house_contact_details", table_alias: "chcd1", model_type: "CloudHouse::Project", variable_type: "table")
account.template.variables.create(name: "Main_Owner_Customer_Occupation", field_name: "occupation", table_name: "cloud_house_contact_details", table_alias: "chcd1", model_type: "CloudHouse::Project", variable_type: "table")
account.template.variables.create(name: "Main_Owner_Customer_Children", field_name: "children", table_name: "cloud_house_contact_details", table_alias: "chcd1", model_type: "CloudHouse::Project", variable_type: "table")
account.template.variables.create(name: "Main_Owner_Customer_Marital_Status", field_name: "marital_status", table_name: "cloud_house_contact_details", table_alias: "chcd1", model_type: "CloudHouse::Project", variable_type: "table")

    # Owner customer
account.template.variables.create(name: "Owner_Customer_First_Name", field_name: "first_name", table_name: "cloud_house_contact_details", table_alias: "chcd2", model_type: "CloudHouse::Project", variable_type: "table")
account.template.variables.create(name: "Owner_Customer_Street_Name", field_name: "street_name", table_name: "cloud_house_contact_details", table_alias: "chcd2", model_type: "CloudHouse::Project", variable_type: "table")
account.template.variables.create(name: "Owner_Customer_Street_Number", field_name: "street_number", table_name: "cloud_house_contact_details", table_alias: "chcd2", model_type: "CloudHouse::Project", variable_type: "table")
account.template.variables.create(name: "Owner_Customer_Street_Other", field_name: "street_other", table_name: "cloud_house_contact_details", table_alias: "chcd2", model_type: "CloudHouse::Project", variable_type: "table")
account.template.variables.create(name: "Owner_Customer_Zipcode", field_name: "postcode", table_name: "cloud_house_contact_details", table_alias: "chcd2", model_type: "CloudHouse::Project", variable_type: "table")
account.template.variables.create(name: "Owner_Customer_City", field_name: "name", table_name: "account_locations", table_alias: "chcd2_location", model_type: "CloudHouse::Project", variable_type: "table")
account.template.variables.create(name: "Owner_Customer_Birthdate", field_name: "birthdate", table_name: "cloud_house_contact_details", table_alias: "chcd2", model_type: "CloudHouse::Project", variable_type: "table")
account.template.variables.create(name: "Owner_Customer_Gender", field_name: "gender", table_name: "cloud_house_contact_details", table_alias: "chcd2", model_type: "CloudHouse::Project", variable_type: "table")
account.template.variables.create(name: "Owner_Customer_Salutation", field_name: "salutation", table_name: "cloud_house_contact_details", table_alias: "chcd2", model_type: "CloudHouse::Project", variable_type: "table")
account.template.variables.create(name: "Owner_Customer_Email", field_name: "email", table_name: "cloud_house_contact_details", table_alias: "chcd2", model_type: "CloudHouse::Project", variable_type: "table")
account.template.variables.create(name: "Owner_Customer_Phone", field_name: "Telephone", table_name: "cloud_house_contact_details", table_alias: "chcd2", model_type: "CloudHouse::Project", variable_type: "table")
account.template.variables.create(name: "Owner_Customer_Mobile_Number", field_name: "mobile_number", table_name: "cloud_house_contact_details", table_alias: "chcd2", model_type: "CloudHouse::Project", variable_type: "table")
account.template.variables.create(name: "Owner_Customer_Fax", field_name: "fax_number", table_name: "cloud_house_contact_details", table_alias: "chcd2", model_type: "CloudHouse::Project", variable_type: "table")
account.template.variables.create(name: "Owner_Customer_Title", field_name: "title", table_name: "cloud_house_contact_details", table_alias: "chcd2", model_type: "CloudHouse::Project", variable_type: "table")
account.template.variables.create(name: "Owner_Customer_Children", field_name: "children", table_name: "cloud_house_contact_details", table_alias: "chcd2", model_type: "CloudHouse::Project", variable_type: "table")
account.template.variables.create(name: "Owner_Customer_Marital_Status", field_name: "marital_status", table_name: "cloud_house_contact_details", table_alias: "chcd2", model_type: "CloudHouse::Project", variable_type: "table")

    # Project details
account.template.variables.create(name: "Project_Code", field_name: "code", table_name: "cloud_house_project_details", table_alias: "", model_type: "CloudHouse::Project", variable_type: "table")
account.template.variables.create(name: "Project_Status", field_name: "name", table_name: "cloud_house_workflow_statuses", table_alias: "", model_type: "CloudHouse::Project", variable_type: "table")

    # User assigned
account.template.variables.create(name: "Project_Manager_First_Name", field_name: "first_name", table_name: "user_details", table_alias: "", model_type: "CloudHouse::Project", variable_type: "table")
account.template.variables.create(name: "Project_Manager_Last_Name", field_name: "last_name", table_name: "user_details", table_alias: "", model_type: "CloudHouse::Project", variable_type: "table")
account.template.variables.create(name: "Project_Manager_Salutation", field_name: "salutation", table_name: "user_details", table_alias: "", model_type: "CloudHouse::Project", variable_type: "table")
account.template.variables.create(name: "Project_Manager_Title", field_name: "title", table_name: "user_details", table_alias: "", model_type: "CloudHouse::Project", variable_type: "table")
account.template.variables.create(name: "Project_Manager_Email", field_name: "email", table_name: "users", table_alias: "", model_type: "CloudHouse::Project", variable_type: "table")
account.template.variables.create(name: "Project_Manager_Telephone", field_name: "Telephone", table_name: "user_details", table_alias: "", model_type: "CloudHouse::Project", variable_type: "table")


    # Custom project variables
account.template.variables.create(name: "Customers_Full_Name", field_name: "customers_full_name", table_name: "", table_alias: "", model_type: "CloudHouse::Project", variable_type: "table")
account.template.variables.create(name: "Customers_Last_Name", field_name: "customers_name", table_name: "", table_alias: "", model_type: "CloudHouse::Project", variable_type: "table")
account.template.variables.create(name: "Customers_First_Name", field_name: "customers_last_name", table_name: "", table_alias: "", model_type: "CloudHouse::Project", variable_type: "table")
account.template.variables.create(name: "Customers_Last_Name_Greeting", field_name: "customers_last_name_greeting", table_name: "", table_alias: "", model_type: "CloudHouse::Project", variable_type: "table")
account.template.variables.create(name: "Customers_First_Name_Greeting", field_name: "customers_name_greeting", table_name: "", table_alias: "", model_type: "CloudHouse::Project", variable_type: "table")
account.template.variables.create(name: "Customers_Full_Name_Greeting", field_name: "customers_full_name_greeting", table_name: "", table_alias: "", model_type: "CloudHouse::Project", variable_type: "table")

# Company variables

    # Company details
account.template.variables.create(name: "Company_Name", field_name: "name", table_name: "cloud_house_company_details", table_alias: "", model_type: "CloudHouse::Company", variable_type: "table")
account.template.variables.create(name: "Company_Cooperation_Limited_To", field_name: "cooperation_limited_to", table_name: "cloud_house_company_details", table_alias: "", model_type: "CloudHouse::Company", variable_type: "table")
account.template.variables.create(name: "Company_Market_Region_Assigned", field_name: "market_region_designed", table_name: "cloud_house_company_details", table_alias: "", model_type: "CloudHouse::Company", variable_type: "table")
account.template.variables.create(name: "Company_Commission_Rate", field_name: "commission_rate", table_name: "cloud_house_company_details", table_alias: "", model_type: "CloudHouse::Company", variable_type: "table")
account.template.variables.create(name: "Company_Region", field_name: "region", table_name: "cloud_house_company_details", table_alias: "", model_type: "CloudHouse::Company", variable_type: "table")
account.template.variables.create(name: "Company_Email", field_name: "email", table_name: "cloud_house_company_details", table_alias: "", model_type: "CloudHouse::Company", variable_type: "table")
account.template.variables.create(name: "Company_Phone", field_name: "phone", table_name: "cloud_house_company_details", table_alias: "", model_type: "CloudHouse::Company", variable_type: "table")
account.template.variables.create(name: "Company_Street_Name", field_name: "street_name", table_name: "cloud_house_company_departments", table_alias: "chcdep", model_type: "CloudHouse::Company", variable_type: "table")

    # Main contact
account.template.variables.create(name: "Main_Owner_Customer_First_Name", field_name: "first_name", table_name: "cloud_house_contact_details", table_alias: "chcd1", model_type: "CloudHouse::Project", variable_type: "table")
account.template.variables.create(name: "Main_Owner_Customer_City", field_name: "name", table_name: "account_locations", table_alias: "chcd1_location", model_type: "CloudHouse::Project", variable_type: "table")
account.template.variables.create(name: "Owner_Customer_Last_Name", field_name: "last_name", table_name: "cloud_house_contact_details", table_alias: "chcd2", model_type: "CloudHouse::Project", variable_type: "table")
account.template.variables.create(name: "Owner_Customer_Occupation", field_name: "occupation", table_name: "cloud_house_contact_details", table_alias: "chcd2", model_type: "CloudHouse::Project", variable_type: "table")
account.template.variables.create(name: "Company_Cooperation_Agreement_Range", field_name: "cooperation_agreement_range", table_name: "cloud_house_company_details", table_alias: "", model_type: "CloudHouse::Company", variable_type: "table")
account.template.variables.create(name: "Company_Street_Number", field_name: "street_number", table_name: "cloud_house_company_departments", table_alias: "chcdep", model_type: "CloudHouse::Company", variable_type: "table")
account.template.variables.create(name: "Company_Zipcode", field_name: "postcode", table_name: "cloud_house_company_departments", table_alias: "chcdep", model_type: "CloudHouse::Company", variable_type: "table")
account.template.variables.create(name: "Company_Street_Other", field_name: "street_other", table_name: "cloud_house_company_departments", table_alias: "chcdep", model_type: "CloudHouse::Company", variable_type: "table")
account.template.variables.create(name: "Company_City", field_name: "name", table_name: "account_locations", table_alias: "", model_type: "CloudHouse::Company", variable_type: "table")
account.template.variables.create(name: "Main_Contact_First_Name", field_name: "first_name", table_name: "cloud_house_employee_details", table_alias: "", model_type: "CloudHouse::Company", variable_type: "table")
account.template.variables.create(name: "Main_Contact_Last_Name", field_name: "last_name", table_name: "cloud_house_employee_details", table_alias: "", model_type: "CloudHouse::Company", variable_type: "table")
account.template.variables.create(name: "Main_Contact_Salutation", field_name: "salutation", table_name: "cloud_house_employee_details", table_alias: "", model_type: "CloudHouse::Company", variable_type: "table")
account.template.variables.create(name: "Main_Contact_Title", field_name: "title", table_name: "cloud_house_employee_details", table_alias: "", model_type: "CloudHouse::Company", variable_type: "table")
account.template.variables.create(name: "Main_Contact_Email", field_name: "email", table_name: "cloud_house_employee_details", table_alias: "", model_type: "CloudHouse::Company", variable_type: "table")
account.template.variables.create(name: "Main_Contact_Phone", field_name: "Telephone", table_name: "cloud_house_employee_details", table_alias: "", model_type: "CloudHouse::Company", variable_type: "table")
account.template.variables.create(name: "Main_Contact_Mobile_Number", field_name: "mobile_number", table_name: "cloud_house_employee_details", table_alias: "", model_type: "CloudHouse::Company", variable_type: "table")
account.template.variables.create(name: "Main_Contact_Fax", field_name: "fax_number", table_name: "cloud_house_employee_details", table_alias: "", model_type: "CloudHouse::Company", variable_type: "table")
account.template.variables.create(name: "Main_Contact_Position", field_name: "position", table_name: "cloud_house_employee_details", table_alias: "", model_type: "CloudHouse::Company", variable_type: "table")

# Tools
account.template.variables.create(name: "Date_Today", field_name: "today", table_name: "LC::Date", table_alias: "to_string", model_type: "tool", variable_type: "method")