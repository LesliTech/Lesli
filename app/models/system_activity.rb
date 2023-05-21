class SystemActivity < ApplicationRecord
    belongs_to :account, foreign_key: "accounts_id"


    def log_activity system_module, system_process, description=nil
        self.activities.create({
            system_module: system_module,
            system_process: system_process,
            description: description
        })
    end
    
    def self.log_email(system_module, description)

 
    end
end
