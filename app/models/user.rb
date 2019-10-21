class User < ApplicationRecord

    devise  :database_authenticatable, 
            :registerable, 
            :recoverable, 
            :rememberable, 
            :trackable, 
            :validatable,
            :confirmable
    
    belongs_to :account , foreign_key: 'accounts_id', optional: true
    has_one :user_detail, foreign_key: 'user_details_id'
    has_many :notifications

end
