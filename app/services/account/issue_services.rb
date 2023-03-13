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

class Account::IssueServices < LesliServices

    def create account_issue_params
        account_issue = ::Account::Issue.new(account_issue_params)

        # Issues can be created without a user,
        # so we need to check if the current_user is present to use its account
        # instead of using the account_id from the params
        if current_user
            account_issue.user = current_user
            account_issue.account = current_user.account

            # Set email and full name from the current user if not provided
            unless account_issue_params.dig(:email)
                account_issue.email = current_user.email
            end

            unless account_issue_params.dig(:first_name)
                account_issue.first_name = current_user.detail.first_name
                account_issue.last_name = current_user.detail.last_name
            end

        end

        if account_issue.save
            self.resource = account_issue
        else
            self.error(account_issue.errors.full_messages.to_sentence)
        end

        self
    end

    def index query, params

        # Get search string from query params
        search_string = query[:search].downcase.gsub(" ","%") unless query[:search].blank?

        issues = current_user.account.issues

        # Filter results by search string
        unless search_string.blank?
            issues = issues.where("(LOWER(first_name) SIMILAR TO :search_string) OR
                (LOWER(email) SIMILAR TO :search_string) OR
                (LOWER(category) SIMILAR TO :search_string) OR
                (LOWER(status) SIMILAR TO :search_string)
            ", search_string: "%#{sanitize_sql_like(search_string, " ")}%")
        end

        issues = issues.select(
            :id,
            "CONCAT(first_name, ' ', last_name) as full_name",
            :email,
            :category,
            :status,
            :source,
            :telephone,
            :company_name,
            :reference,
            :message,
            LC::Date2.new.date_time.db_column("created_at")
        )

        issues = issues
        .page(query[:pagination][:page])
        .per(query[:pagination][:perPage])
        .order("#{query[:order][:by]} #{query[:order][:dir]} NULLS LAST")

        issues

    end

    def show issue=nil

        issue = issue || resource

        return {
            id: issue[:id],
            first_name: issue[:first_name],
            last_name: issue[:last_name],
            email: issue[:email],
            telephone: issue[:telephone],
            message: issue[:message],
            category: issue[:category],
            status: issue[:status],
            source: issue[:source],
            reference: issue[:reference],
            model_type: issue[:model_type],
            model_id: issue[:model_id],
            created_at:  LC::Date2.new(issue[:created_at]).date_time.to_s
        }
    end

    def update params

        old_attributes = resource.attributes

        if resource.update(params)
            new_attributes = resource.attributes
        else
            self.error(resource.errors.full_messages.to_sentence)
        end

        self
    end

    def find id
        self.resource = current_user.account.issues.find_by(id: id)
        self
    end

end
