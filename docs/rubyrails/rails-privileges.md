# Lesli user privileges
The main function of this method is to provide the developer a way to validate the privileges from the backend side.



## Description
**User**.has_privilege? is a method of the **User** class wich is use to validate if a user has privileges to access a table before a query execution.  

Example:  

```ruby
module DeutscheLeibrenten
    class ReportsController < ApplicationController
        before_action :set_report, only: [:show]
    
        def show
            respond_to do |format|
                format.xlsx {
                    report_users if @report="users"
                    report_companies if @report="companies"
                }
            end
        end

        def report_users
            #if a user wants to create a report of the users first we need to validate that he can do the action

            return respond_with_unauthorized unless current_user
                .has_privileges?(["users"], ["index"])

            users = User.all

            users = Docm::Parser::Xlsx.parse(users)

            send_file Docm::Generator::Xlsx.generate("Users", [["List", users]]) 
        end

        def set_report
            @report = params[:id]
        end
    end
end
```
<hr>

## Function description

**has_privilege?()**
- params:
    - **[Array]** controllers: The controllers wich we want to validate.
    - **[Array]** actions:  The actions of the controllers.
- returns: [**Boolean**] 
- description:  Return true or false if a user is allowed to do specific actions on controllers. 