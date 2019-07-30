class User < ApplicationRecord

    devise  :database_authenticatable, 
            :registerable, 
            :recoverable, 
            :rememberable, 
            :trackable, 
            :validatable,
            :confirmable
    
    has_one :account, foreign_key: 'users_id'

end
