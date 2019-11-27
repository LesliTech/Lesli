class User < ApplicationRecord
    acts_as_paranoid
    devise  :database_authenticatable, 
            :registerable, 
            :recoverable, 
            :rememberable, 
            :trackable, 
            :validatable,
            :confirmable
    

    has_one     :user_detail, foreign_key: 'user_details_id'
    has_many    :notifications, class_name: 'Bell::Notification', foreign_key: 'users_id'
    has_and_belongs_to_many :lock_role_overrides, foreign_key: 'id'
    belongs_to  :account , foreign_key: 'accounts_id', optional: true
 

    has_one :detail, dependent: :delete, inverse_of: :user, autosave: true, foreign_key: 'users_id'
    accepts_nested_attributes_for :detail

    def revoke_access
        update_attributes(active: false)
    end

end
