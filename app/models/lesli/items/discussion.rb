module Lesli
    module Items
        class Discussion < ApplicationRecord
            self.abstract_class = true

            belongs_to :author,
                class_name: "Lesli::User",
                foreign_key: :user_id
            belongs_to :discussable, polymorphic: true

            validates :message, presence: true
        end
    end
end
