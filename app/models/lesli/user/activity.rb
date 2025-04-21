module Lesli
    class User::Activity < ApplicationRecord
        belongs_to :user
    end
end
