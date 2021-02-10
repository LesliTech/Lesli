class Account::Activity < ApplicationRecord
    belongs_to :account, foreign_key: "accounts_id"

    def self.log(system_module_action, system_process, title=nil, description=nil, payload=nil)
        Account.first.activities.create(
            system_module: system_module_action,
            system_process: system_process,
            description: description,
            title: title,
            payload: payload
        )
    end

    def log_activity(system_module, system_process, description=nil)
        LC::Debug.deprecation("use Account::Activity.log instead")
    end
    
    def self.log_email(system_module_action, description="email", payload=nil)
        activity = Account.first.activities.create(
            system_module: system_module_action,
            system_process: "mailer",
            description: description,
            payload: payload,
            title: "email_sent"
        )
    end
end
