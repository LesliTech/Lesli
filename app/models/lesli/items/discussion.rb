require "cgi"

module Lesli
    module Items
        class Discussion < ApplicationRecord
            self.abstract_class = true

            belongs_to :author,
                class_name: "Lesli::User",
                foreign_key: :user_id
            belongs_to :discussable, polymorphic: true

            validate :message_has_content

            private

            def message_has_content
                plain_message = ActionView::Base.full_sanitizer.sanitize(message.to_s)
                plain_message = plain_message.gsub(/&nbsp;/i, " ")
                plain_message = CGI.unescapeHTML(plain_message).tr("\u00A0", " ")

                errors.add(:message, :blank) if plain_message.squish.blank?
            end
        end
    end
end
