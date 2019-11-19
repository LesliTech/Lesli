class User < ApplicationRecord

    devise  :database_authenticatable, 
            :registerable, 
            :recoverable, 
            :rememberable, 
            :trackable, 
            :validatable,
            :confirmable
    
    has_one     :user_detail, foreign_key: 'user_details_id'
    has_many    :notifications, class_name: 'CloudBell::Notification', foreign_key: 'users_id'
    belongs_to  :account , foreign_key: 'accounts_id', optional: true

    def revoke_access
        update_attributes(active: false)
    end

end
