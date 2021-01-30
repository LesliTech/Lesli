class Account::Activity < ApplicationRecord
    belongs_to :account, foreign_key: "accounts_id"

    def self.log(system_module, system_process, description=nil)
        self.activities.create({
            system_module: system_module,
            system_process: system_process,
            description: description
        })
    end

    def log_activity(system_module, system_process, description=nil)
        self.activities.create({
            system_module: system_module,
            system_process: system_process,
            description: description
        })
    end
    
    def self.log_email(system_module_action, description="email", payload=nil)

        activity = Account.first.activities.create(
            system_module: system_module_action,
            system_process: "mailer",
            description: description,
            payload: payload
        )

    end
end
