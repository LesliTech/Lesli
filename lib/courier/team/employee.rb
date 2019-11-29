module Courier
    module Team
        class Employee
            def self.all()

                employees = []

                users = ::User.left_joins(:detail).select(:id, :email, :first_name, :last_name, :created_at).order(:id)
                
                if defined?(CloudTeam)
                    employees = ::CloudTeam::Employee.all
                end

                #users | employees returns a new array with the combination of users and employess

                users

            end
        end
    end
end
