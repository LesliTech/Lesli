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

    def send_confirmation_email
        AccountMailer.with(email: self.email).issue_received_confirmation.deliver_later
    end

end
