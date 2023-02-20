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

        # Issues could be created without user, but never anonymous
        # check if request has an email to create the issue
        if account_issue_params[:email].blank?
            self.error(I18n.t("core.users.messages_danger_not_valid_email_found"))
            return self
        end

        # Find user by its email
        current_user = User.find_by_email(account_issue_params[:email])

        account_issue = Account::Issue.new(account_issue_params)

        # Trying to assign user and account to the issue
        account_issue.user = current_user
        account_issue.account = current_user&.account

        if account_issue.save
            self.resource = account_issue
        else
            self.error(account_issue.errors.full_messages.to_sentence)
        end

        self
    end

end
