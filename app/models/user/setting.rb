class User::Setting < ApplicationRecord
    belongs_to :user

    validates :name, presence: true, on: :create
    validates :value, presence: true, on: :create

    after_update :after_update_settings

    def after_update_settings
        #Courier::One::Firebase::User.sync_user(self.user)
    end
end
