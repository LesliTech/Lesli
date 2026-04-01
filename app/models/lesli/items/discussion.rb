module Lesli
    module Items
        class Discussion < ApplicationRecord
            self.abstract_class = true
            belongs_to :user, class_name: "Lesli::User"
            belongs_to :account, class_name: "Lesli::Account"
            belongs_to :discussable, polymorphic: true
        end
    end
end
