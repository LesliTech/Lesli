=begin

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

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
    

    def self.options (current_user, query)
        return {
            statuses: statuses.map { |status, _value| {value: _value, text: status} }
        }
    end


    def send_confirmation_email
        AccountMailer.with(email: self.email).issue_received_confirmation.deliver_later
    end

end
