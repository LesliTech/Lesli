=begin
Copyright (c) 2022, all rights reserved.

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
class Account::Issue < ApplicationRecord
    belongs_to :account,    foreign_key: "accounts_id"
    belongs_to :user,       foreign_key: "users_id", optional: true

    after_create            :send_confirmation_email

    enum category: {
        feedback: "feedback",
        contact_us: "contact_us",
        report_error: "report_error",
        report_abuse: "report_abuse",
        block_object: "block_object",
    }, _default: "feedback"

    enum status: {
        created: "created",
        reviewed: "reviewed",
        solved: "solved",
        closed: "closed",
    }, _default: "created"

    enum source: {
        not_specified: "not_specified",
        web_page: "web_page",
        web_app: "web_app",
        api: "api",
        email: "email",
        call_center: "call_center",
        mobile_app: "mobile_app",
    }, _default: "not_specified"

    def self.index(current_user, query)

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

    def show (current_user, query)
        {
            :id => self.id,
            :first_name => self.first_name,
            :last_name => self.last_name,
            :email => self.email,
            :telephone => self.telephone,
            :message => self.message,
            :category => self.category,
            :status => self.status,
            :source => self.source,
            :reference => self.reference,
            :created_at =>  LC::Date2.new(self.created_at).date_time.to_s 
        }
    end

    def self.options (current_user, query)
        return {
            statuses: statuses.map { |status, _value| {value: _value, text: status} }
        }
    end


    def send_confirmation_email
        AccountMailer.with(email: self.email).issue_received_confirmation.deliver_later
    end

end
