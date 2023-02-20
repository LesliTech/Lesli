=begin

Copyright (c) 2023, all rights reserved.

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

class Account::IssuesServices < LesliServices

    def create account_issue_params
        account_issue = current_user.account.issues.new(account_issue_params)
        account_issue.user = current_user

        if account_issue.save
            self.resource = account_issue
        else
            self.error(account_issue.errors.full_messages.to_sentence)
        end

        self
    end

end
