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
    
    def self.log_email(system_module_action, description="email", title="email_sent", payload=nil)
        activity = Account&.first&.activities&.create(
            system_module: system_module_action,
            system_process: "mailer",
            description: description,
            payload: payload,
            title: title
        )
    end
end
