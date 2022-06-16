class User::Setting < ApplicationRecord
    validates :name, presence: true, on: :create
    validates :value, presence: true, on: :create
end
