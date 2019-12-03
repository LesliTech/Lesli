module Courier
    module Core
        class Users
            def self.list()

                employees = []
                if defined? (CloudLock)
                    return ::User.left_joins(:detail).select(:id, :email, :first_name, :last_name, :created_at).order(:id)
                else
                    return ::User.select(:id, :email, :created_at).order(:id)
                end


                if defined?(CloudTeam)
                    employees = ::CloudTeam::Employee.all
                end

                #users | employees returns a new array with the combination of users and employess

                users

            end

            def self.get(id)
                users = ::User
                    .left_joins(:detail)
                    .select(:id, :email, :first_name, :last_name, :created_at)
                    .find(id)
            end
        end
    end
end
